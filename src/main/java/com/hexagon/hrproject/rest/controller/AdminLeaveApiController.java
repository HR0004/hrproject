package com.hexagon.hrproject.rest.controller;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import com.hexagon.hrproject.dto.response.AdminLeaveRequestRow;
import com.hexagon.hrproject.service.AdminLeaveService;
import com.hexagon.hrproject.spring.security.AccountDetails;

@RestController
@RequestMapping("/api/leave/admin/requests")
@PreAuthorize("hasRole('HR_ADMIN')")
public class AdminLeaveApiController {
    private final AdminLeaveService service;
    public AdminLeaveApiController(AdminLeaveService service) { this.service = service; }

    @GetMapping
    public List<AdminLeaveRequestRow> list(@RequestParam(value = "departmentId", required = false) Integer departmentId,
            @RequestParam(value = "startDate", required = false) String startDate, @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "status", required = false) String status, @RequestParam(value = "keyword", required = false) String keyword) {
        return service.findRequests(departmentId, startDate, endDate, status, keyword);
    }
    @PostMapping("/{requestId}/approve")
    public Map<String, String> approve(@PathVariable("requestId") int requestId, @AuthenticationPrincipal AccountDetails details) {
        service.decide(requestId, approver(details), true);
        return Collections.singletonMap("message", "休暇申請を承認しました。");
    }
    @PostMapping("/{requestId}/reject")
    public Map<String, String> reject(@PathVariable("requestId") int requestId, @AuthenticationPrincipal AccountDetails details) {
        service.decide(requestId, approver(details), false);
        return Collections.singletonMap("message", "休暇申請を否認しました。");
    }
    private int approver(AccountDetails details) {
        if (details == null || details.getAccount() == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "ログインが必要です。");
        if (details.getAccount().getEmp() == null) throw new ResponseStatusException(HttpStatus.CONFLICT, "管理者アカウントに社員情報を紐付けてください。");
        return details.getAccount().getEmp().getEmpId();
    }
    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Map<String, String>> handleStatus(ResponseStatusException e) {
        return ResponseEntity.status(e.getStatus()).body(Collections.singletonMap("message", e.getReason() == null ? "リクエストを処理できません。" : e.getReason()));
    }
}
