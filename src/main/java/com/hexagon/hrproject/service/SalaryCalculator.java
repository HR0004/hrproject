
package com.hexagon.hrproject.service;

import java.math.BigDecimal;

public class SalaryCalculator {

    // 실수령액 계산
    public static BigDecimal calculate(
            BigDecimal baseSalary,
            BigDecimal bonus,
            BigDecimal deduction) {

        // 금액 필수 입력 검사
        if (baseSalary == null ||
            bonus == null ||
            deduction == null) {

            throw new IllegalArgumentException(
                "金額をすべて入力してください。"
            );
        }

        // 음수 검사
        if (baseSalary.signum() < 0 ||
            bonus.signum() < 0 ||
            deduction.signum() < 0) {

            throw new IllegalArgumentException(
                "金額に負の値は指定できません。"
            );
        }

        // 실수령액 = 기본급 + 수당 - 공제액
        return baseSalary.add(bonus).subtract(deduction);
    }
}
