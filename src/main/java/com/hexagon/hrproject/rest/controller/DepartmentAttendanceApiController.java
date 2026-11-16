
package com.hexagon.hrproject.rest.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import com.hexagon.hrproject.dto.response.DepartmentAttendanceRow;
import com.hexagon.hrproject.service.DepartmentAttendanceService;

@Controller
@RequestMapping("/api/attendance")
public class DepartmentAttendanceApiController {

    private final DepartmentAttendanceService service;

    public DepartmentAttendanceApiController(
            DepartmentAttendanceService service) {
        this.service = service;
    }

    @GetMapping("/department")
    @ResponseBody
    public List<DepartmentAttendanceRow> getDepartmentAttendance(

            @RequestParam(required = false)
            Integer departmentId,

            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate workDate,

            Authentication authentication) {

        if (authentication == null
                || !authentication.isAuthenticated()) {
            throw new ResponseStatusException(
                HttpStatus.UNAUTHORIZED
            );
        }

        // 공통 로그인/사이드바와 동일한 관리자 역할
        boolean isAdmin = hasAuthority(
            authentication, "ROLE_HR_ADMIN"
        );

        boolean canReadTeam = hasAuthority(
            authentication, "PERMISSION_TEAM_MEMBER_READ"
        );

        if (!isAdmin && !canReadTeam) {
            throw new ResponseStatusException(
                HttpStatus.FORBIDDEN,
                "勤怠情報の閲覧権限がありません。"
            );
        }

        Integer allowedDepartmentId = departmentId;

        // 팀 조회 권한만 있으면 본인 부서만 허용
        if (!isAdmin) {

            Integer myDepartmentId =
                service.findMyDepartmentId(
                    authentication.getName()
                );

            if (myDepartmentId == null) {
                throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN
                );
            }

            if (departmentId != null
                    && !departmentId.equals(myDepartmentId)) {
                throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "他の部署の情報は閲覧できません。"
                );
            }

            allowedDepartmentId = myDepartmentId;
        }

        return service.findByDepartment(
            allowedDepartmentId,
            workDate
        );
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(ResponseStatusException.class)
    @ResponseBody
    public org.springframework.http.ResponseEntity<java.util.Map<String, String>> handleStatus(ResponseStatusException e) {
        return org.springframework.http.ResponseEntity.status(e.getStatus()).body(
            java.util.Collections.singletonMap("message", e.getReason() == null ? "リクエストを処理できません。" : e.getReason()));
    }

    private boolean hasAuthority(
            Authentication authentication,
            String authority) {

        return authentication.getAuthorities()
            .stream()
            .anyMatch(a ->
                authority.equals(a.getAuthority())
            );
    }
}
