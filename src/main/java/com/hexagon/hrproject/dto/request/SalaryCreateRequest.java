package com.hexagon.hrproject.dto.request;

import java.math.BigDecimal;
import java.time.LocalDate;

import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SalaryCreateRequest {

    @NotNull(message = "社員を選択してください。")
    @Min(value = 1, message = "社員番号は 1 以上である必要があります。")
    private Long empId;

    @NotBlank(message = "支給年月を入力してください。")
    @Pattern(
        regexp = "[0-9]{4}-(0[1-9]|1[0-2])",
        message = "支給年月は yyyy-MM 形式である必要があります。"
    )
    private String salaryYearMonth;

    @NotNull(message = "基本給を入力してください。")
    @DecimalMin(value = "0", message = "基本給に負の値は指定できません。")
    @Digits(integer = 15, fraction = 0,
            message = "基本給は 15桁以内の整数で入力してください。")
    private BigDecimal baseSalary;

    @NotNull(message = "手当を入力してください。")
    @DecimalMin(value = "0", message = "手当に負の値は指定できません。")
    @Digits(integer = 15, fraction = 0,
            message = "手当は 15桁以内の整数で入力してください。")
    private BigDecimal bonus;

    @NotNull(message = "控除額を入力してください。")
    @DecimalMin(value = "0", message = "控除額に負の値は指定できません。")
    @Digits(integer = 15, fraction = 0,
            message = "控除額は 15桁以内の整数で入力してください。")
    private BigDecimal deduction;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate paymentDate;
}