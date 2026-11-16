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
        if (departmentId != null && departmentId <= 0) throw bad("検索する部署を確認してください。");
        LocalDate start = optionalDate(startDate), end = optionalDate(endDate);
        if (start != null && end != null && start.isAfter(end)) throw bad("申請終了日は開始日以降に設定してください。");
        String state = trim(status), search = trim(keyword);
        if ("ALL".equals(state)) state = null;
        if (state != null && !Arrays.asList("PENDING", "APPROVED", "REJECTED", "CANCELED").contains(state)) throw bad("処理状態が正しくありません。");
        if (search != null && search.length() > 50) throw bad("検索キーワードは 50文字以内で入力してください。");
        return mapper.findRequests(departmentId, start == null ? null : Date.valueOf(start),
            end == null ? null : Date.valueOf(end.plusDays(1)), state, search);
    }

    @Transactional
    public void decide(int requestId, int approverId, boolean approve) {
        if (requestId <= 0) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "休暇申請が見つかりません。");
        if (approverId <= 0) throw new ResponseStatusException(HttpStatus.CONFLICT, "管理者アカウントに社員情報を紐付けてください。");
        AdminLeaveRequestRow request = mapper.lockRequest(requestId);
        if (request == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "休暇申請が見つかりません。");
        if (!"PENDING".equals(request.getStatus())) throw conflict("この申請はすでに処理されています。 一覧を再読み込みしてください。");
        if (approve) {
            Map<String, BigDecimal> yearlyDays = splitByYear(request);
            List<AdminLeaveBalance> balances = new ArrayList<>();
            // Lock balances in year order; validate all years before updating any balance.
            for (Map.Entry<String, BigDecimal> entry : yearlyDays.entrySet()) {
                AdminLeaveBalance balance = mapper.lockBalance(request.getEmpId(), entry.getKey());
                if (balance == null) throw conflict(entry.getKey() + "年の休暇残日数が登録されていません。");
                if (balance.getTotalDays() == null || balance.getUsedDays() == null
                        || balance.getTotalDays().subtract(balance.getUsedDays()).compareTo(entry.getValue()) < 0) {
                    throw conflict(entry.getKey() + "年の休暇残日数が不足しています。");
                }
                balances.add(balance);
            }
            int index = 0;
            for (BigDecimal days : yearlyDays.values()) {
                if (mapper.consumeBalance(balances.get(index++).getBalanceId(), days) != 1)
                    throw conflict("休暇残日数が変更されました。 もう一度検索してください。");
            }
        }
        if (mapper.decide(requestId, approve ? "APPROVED" : "REJECTED", approverId) != 1)
            throw conflict("この申請はすでに処理されています。 一覧を再読み込みしてください。");
    }

    private Map<String, BigDecimal> splitByYear(AdminLeaveRequestRow request) {
        LocalDate start = optionalDate(request.getStartDate()), end = optionalDate(request.getEndDate());
        BigDecimal days = request.getDays();
        if (start == null || end == null || end.isBefore(start) || end.isAfter(start.plusYears(1))
                || days == null || days.signum() <= 0) throw conflict("申請期間と日数を確認してください。");
        Map<String, BigDecimal> result = new TreeMap<>();
        if (days.compareTo(new BigDecimal("0.5")) == 0) {
            if (!start.equals(end) || !weekday(start)) throw conflict("半日休暇の申請内容を確認してください。");
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
            if (total.compareTo(days) != 0) throw conflict("申請日数が平日数と一致しません。 申請内容を確認してください。");
        }
        return result;
    }
    private static boolean weekday(LocalDate date) { return date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY; }
    private static String trim(String value) { return value == null || value.trim().isEmpty() ? null : value.trim(); }
    private static LocalDate optionalDate(String value) {
        if (trim(value) == null) return null;
        try { LocalDate date = LocalDate.parse(value.trim()); if (date.getYear() < 1900 || date.getYear() > 9998) throw bad("検索する日付を確認してください。"); return date; }
        catch (DateTimeParseException e) { throw bad("日付の形式を確認してください。"); }
    }
    private static ResponseStatusException bad(String message) { return new ResponseStatusException(HttpStatus.BAD_REQUEST, message); }
    private static ResponseStatusException conflict(String message) { return new ResponseStatusException(HttpStatus.CONFLICT, message); }
}
