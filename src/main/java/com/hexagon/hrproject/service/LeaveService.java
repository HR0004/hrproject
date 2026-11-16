
package com.hexagon.hrproject.service;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hexagon.hrproject.domain.LeaveBalance;
import com.hexagon.hrproject.domain.LeaveRequestHistory;
import com.hexagon.hrproject.domain.LeaveUsage;
import com.hexagon.hrproject.mapper.LeaveMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LeaveService {

	private final LeaveMapper leaveMapper;

	// 휴가 잔액
	public LeaveBalance findBalanceByEmpId(int empId, String fiscalYear) {

		return leaveMapper.findBalanceByEmpId(empId, fiscalYear);
	}

	// 휴가 사용 내역
	public List<LeaveUsage> findUsedLeaveByEmpId(int empId) {

		return leaveMapper.findUsedLeaveByEmpId(empId);
	}

	// 로그인한 사원의 전체 휴가 신청 내역
	public List<LeaveRequestHistory> findRequestHistoryByEmpId(int empId) {

		return leaveMapper.findRequestHistoryByEmpId(empId);

	}

	// 간단한 휴가 신청 기능
	public void applyLeave(int empId, String startDate, String endDate, String halfDayType, String reason) {

		if (reason == null || reason.trim().isEmpty() || reason.trim().length() > 50) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "申請理由は 1~50文字で入力してください。");
		}

		LocalDate start;
		LocalDate end;

		try {
			start = LocalDate.parse(startDate);
			end = LocalDate.parse(endDate);
		} catch (DateTimeParseException | NullPointerException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "休暇の日付を確認してください。");
		}

		if (end.isBefore(start) || end.isAfter(start.plusYears(1))) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "休暇期間を確認してください。");
		}

		BigDecimal days = BigDecimal.ZERO;

		if ("FULL".equals(halfDayType)) {

			// 토요일과 일요일을 제외한 일수
			for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {

				if (date.getDayOfWeek() != DayOfWeek.SATURDAY && date.getDayOfWeek() != DayOfWeek.SUNDAY) {

					days = days.add(BigDecimal.ONE);
				}
			}

		} else if ("AM".equals(halfDayType) || "PM".equals(halfDayType)) {

			if (!start.equals(end) || start.getDayOfWeek() == DayOfWeek.SATURDAY
					|| start.getDayOfWeek() == DayOfWeek.SUNDAY) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "半日休暇は平日の1日のみ申請できます。");
			}

			days = new BigDecimal("0.5");

		} else {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "休暇区分が正しくありません。");
		}

		if (days.compareTo(BigDecimal.ZERO) <= 0) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "申請可能な平日がありません。");
		}

		leaveMapper.insertLeaveRequest(empId, Date.valueOf(start), Date.valueOf(end), days, reason.trim());
	}

}
