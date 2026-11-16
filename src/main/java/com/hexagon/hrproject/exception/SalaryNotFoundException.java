package com.hexagon.hrproject.exception;

public class SalaryNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public SalaryNotFoundException() {
        super("該当する給与明細が見つかりません。 給与一覧からもう一度選択してください。");
    }
}