package com.hexagon.hrproject.service;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import com.hexagon.hrproject.dto.response.AdminLeaveRequestRow;
import com.hexagon.hrproject.dto.response.AdminLeaveBalance;
import com.hexagon.hrproject.mapper.AdminLeaveMapper;

@Service
public class AdminLeaveService {
    private final AdminLeaveMapper mapper;
    public AdminLeaveService(AdminLeaveMapper mapper) { this.mapper = mapper; }

    @Transactional(readOnly = true)
    public List<AdminLeaveRequestRow> findRequests(Integer departmentId, String startDate,
            String endDate, String status, String keyword) {
        if (departmentId != null && departmentId <= 0) throw bad("조회 부서를 확인하세요.");
        LocalDate start = optionalDate(startDate), end = optionalDate(endDate);
        if (start != null && end != null && start.isAfter(end)) throw bad("신청 종료일은 시작일보다 빠를 수 없습니다.");
        String state = trim(status), search = trim(keyword);
        if ("ALL".equals(state)) state = null;
        if (state != null && !Arrays.asList("PENDING", "APPROVED", "REJECTED", "CANCELED").contains(state)) throw bad("처리 상태가 올바르지 않습니다.");
        if (search != null && search.length() > 50) throw bad("검색어는 50자 이내로 입력하세요.");
        return mapper.findRequests(departmentId, start == null ? null : Date.valueOf(start),
            end == null ? null : Date.valueOf(end.plusDays(1)), state, search);
    }

    @Transactional
    public void decide(int requestId, int approverId, boolean approve) {
        if (requestId <= 0) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "휴가 신청을 찾을 수 없습니다.");
        if (approverId <= 0) throw new ResponseStatusException(HttpStatus.CONFLICT, "관리자 계정에 사원 정보를 연결해 주세요.");
        AdminLeaveRequestRow request = mapper.lockRequest(requestId);
        if (request == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "휴가 신청을 찾을 수 없습니다.");
        if (!"PENDING".equals(request.getStatus())) throw conflict("이미 처리된 신청입니다. 목록을 새로 조회하세요.");
        if (approve) {
            Map<String, BigDecimal> yearlyDays = splitByYear(request);
            List<AdminLeaveBalance> balances = new ArrayList<>();
            // Lock balances in year order; validate all years before updating any balance.
            for (Map.Entry<String, BigDecimal> entry : yearlyDays.entrySet()) {
                AdminLeaveBalance balance = mapper.lockBalance(request.getEmpId(), entry.getKey());
                if (balance == null) throw conflict(entry.getKey() + "년 휴가 잔액이 등록되어 있지 않습니다.");
                if (balance.getTotalDays() == null || balance.getUsedDays() == null
                        || balance.getTotalDays().subtract(balance.getUsedDays()).compareTo(entry.getValue()) < 0) {
                    throw conflict(entry.getKey() + "년 잔여 휴가가 부족합니다.");
                }
                balances.add(balance);
            }
            int index = 0;
            for (BigDecimal days : yearlyDays.values()) {
                if (mapper.consumeBalance(balances.get(index++).getBalanceId(), days) != 1)
                    throw conflict("휴가 잔액이 변경되었습니다. 다시 조회하세요.");
            }
        }
        if (mapper.decide(requestId, approve ? "APPROVED" : "REJECTED", approverId) != 1)
            throw conflict("이미 처리된 신청입니다. 목록을 새로 조회하세요.");
    }

    private Map<String, BigDecimal> splitByYear(AdminLeaveRequestRow request) {
        LocalDate start = optionalDate(request.getStartDate()), end = optionalDate(request.getEndDate());
        BigDecimal days = request.getDays();
        if (start == null || end == null || end.isBefore(start) || end.isAfter(start.plusYears(1))
                || days == null || days.signum() <= 0) throw conflict("신청 기간과 일수를 확인하세요.");
        Map<String, BigDecimal> result = new TreeMap<>();
        if (days.compareTo(new BigDecimal("0.5")) == 0) {
            if (!start.equals(end) || !weekday(start)) throw conflict("반차 신청 정보를 확인하세요.");
            result.put(String.valueOf(start.getYear()), days);
        } else {
            for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
                if (weekday(date)) {
                    String year = String.valueOf(date.getYear());
                    result.put(year, result.getOrDefault(year, BigDecimal.ZERO).add(BigDecimal.ONE));
                }
            }
            BigDecimal total = BigDecimal.ZERO;
            for (BigDecimal part : result.values()) total = total.add(part);
            if (total.compareTo(days) != 0) throw conflict("신청 일수가 평일 계산과 다릅니다. 신청 정보를 확인하세요.");
        }
        return result;
    }
    private static boolean weekday(LocalDate date) { return date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY; }
    private static String trim(String value) { return value == null || value.trim().isEmpty() ? null : value.trim(); }
    private static LocalDate optionalDate(String value) {
        if (trim(value) == null) return null;
        try { LocalDate date = LocalDate.parse(value.trim()); if (date.getYear() < 1900 || date.getYear() > 9998) throw bad("조회 날짜를 확인하세요."); return date; }
        catch (DateTimeParseException e) { throw bad("날짜 형식을 확인하세요."); }
    }
    private static ResponseStatusException bad(String message) { return new ResponseStatusException(HttpStatus.BAD_REQUEST, message); }
    private static ResponseStatusException conflict(String message) { return new ResponseStatusException(HttpStatus.CONFLICT, message); }
}
