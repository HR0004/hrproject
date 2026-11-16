package com.hexagon.hrproject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hexagon.hrproject.mapper.AccountStatusMapper;

@Service
public class AccountStatusService {

    private final AccountStatusMapper accountStatusMapper;

    @Autowired
    public AccountStatusService(AccountStatusMapper accountStatusMapper) {
        this.accountStatusMapper = accountStatusMapper;
    }

    @Transactional
    @PreAuthorize("hasRole('HR_ADMIN')")
    public boolean changeStatus(
            long accountId,
            int enabled,
            int operatorAccountId) {

        if (accountId <= 0) {
            throw new IllegalArgumentException(
                "有効なアカウントを選択してください。");
        }

        if (enabled != 0 && enabled != 1) {
            throw new IllegalArgumentException(
                "アカウントの状態は有効または無効を指定してください。");
        }

        if (accountId == operatorAccountId && enabled == 0) {
            throw new IllegalArgumentException(
                "自分のアカウントは無効にできません。");
        }

        Integer currentEnabled =
            accountStatusMapper.selectEnabledForUpdate(accountId);

        if (currentEnabled == null) {
            throw new IllegalArgumentException(
                "該当するアカウント情報がありません。");
        }

        if (currentEnabled.intValue() == enabled) {
            return false;
        }

        int updated =
            accountStatusMapper.updateEnabled(accountId, enabled);

        if (updated != 1) {
            throw new IllegalStateException(
                "アカウントの状態変更結果を確認できません。");
        }

        return true;
    }
}