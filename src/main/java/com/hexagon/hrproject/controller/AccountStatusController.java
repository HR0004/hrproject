package com.hexagon.hrproject.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hexagon.hrproject.service.AccountStatusService;
import com.hexagon.hrproject.spring.security.AccountDetails;

@Controller
@RequestMapping("/admin/accounts")
@PreAuthorize("hasRole('HR_ADMIN')")
public class AccountStatusController {

    private final AccountStatusService accountStatusService;

    @Autowired
    public AccountStatusController(
            AccountStatusService accountStatusService) {

        this.accountStatusService = accountStatusService;
    }

    @PostMapping("/{accountId}/status")
    public String changeStatus(
            @PathVariable("accountId") long accountId,
            @RequestParam("enabled") int enabled,
            @RequestParam(value = "keyword", required = false)
                String keyword,
            @AuthenticationPrincipal AccountDetails principal,
            RedirectAttributes redirectAttributes) {

        if (principal == null || principal.getAccount() == null) {
            throw new AccessDeniedException("ログインが必要です。");
        }

        try {
            boolean changed = accountStatusService.changeStatus(
                accountId,
                enabled,
                principal.getAccount().getAccountId()
            );

            redirectAttributes.addFlashAttribute(
                "accountStatusMessage",
                changed
                    ? "アカウントの状態を変更しました。"
                    : "すでに指定された状態です。"
            );

        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute(
                "accountStatusMessage",
                exception.getMessage()
            );
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            redirectAttributes.addAttribute(
                "keyword",
                keyword.trim()
            );
        }

        return "redirect:/admin/accounts";
    }
}