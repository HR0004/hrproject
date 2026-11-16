package com.hexagon.hrproject.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hexagon.hrproject.domain.Salary;
import com.hexagon.hrproject.dto.request.SalaryCreateRequest;
import com.hexagon.hrproject.dto.response.SalaryEmployeeOption;
import com.hexagon.hrproject.exception.SalaryBusinessException;
import com.hexagon.hrproject.exception.SalaryNotFoundException;
import com.hexagon.hrproject.mapper.SalaryMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SalaryService {

    private final SalaryMapper salaryMapper;

    // 1. 급여 등록용 사원 목록 조회
    public List<SalaryEmployeeOption> getEmployeeOptions() {
        return salaryMapper.selectEmployeeOptions();
    }

    // 2. 전체 급여 목록 조회
    public List<Salary> getSalaryList() {
        return salaryMapper.selectAll();
    }

    // 3. 급여 검색
    public List<Salary> getSalaryList(
            String salaryYearMonth,
            String employeeKeyword) {

        String month = salaryYearMonth == null
                ? "" : salaryYearMonth.trim();

        String keyword = employeeKeyword == null
                ? "" : employeeKeyword.trim();

        // 지급 연월 형식 검사
        if (!month.isEmpty()
                && !month.matches("[0-9]{4}-(0[1-9]|1[0-2])")) {

            throw new SalaryBusinessException(
                    "支給年月は yyyy-MM 形式で入力してください。");
        }

        // 검색어 길이 검사
        if (keyword.length() > 50) {
            throw new SalaryBusinessException(
                    "社員検索キーワードは 50文字以内で入力してください。");
        }

        // 검색 조건이 없으면 전체 조회
        if (month.isEmpty() && keyword.isEmpty()) {
            return salaryMapper.selectAll();
        }

        Long employeeId = null;

        // 숫자로 검색하면 사번 검색도 가능
        if (keyword.matches("[0-9]+")) {
            try {
                long number = Long.parseLong(keyword);

                if (number > 0) {
                    employeeId = number;
                }

            } catch (NumberFormatException e) {
                // 숫자 범위를 초과하면 일반 검색어로 처리
            }
        }

        return salaryMapper.selectByFilters(
                month, keyword, employeeId);
    }

    // 4. 급여 상세 조회
    public Salary getSalaryDetail(Long salaryId) {

        if (salaryId == null || salaryId <= 0) {
            throw new SalaryNotFoundException();
        }

        Salary salary = salaryMapper.selectById(salaryId);

        if (salary == null) {
            throw new SalaryNotFoundException();
        }

        return salary;
    }

    // 5. 급여 등록 전 데이터 준비 및 실수령액 계산
    public Salary prepareSalary(SalaryCreateRequest request) {

        if (request == null) {
            throw new SalaryBusinessException(
                    "給与情報を入力してください。");
        }

        // 사원 번호 검사
        if (request.getEmpId() == null
                || request.getEmpId() <= 0) {

            throw new SalaryBusinessException(
                    "社員を選択してください。");
        }

        // 지급 연월 검사
        String yearMonth = request.getSalaryYearMonth();

        if (yearMonth == null
                || !yearMonth.matches(
                        "[0-9]{4}-(0[1-9]|1[0-2])")) {

            throw new SalaryBusinessException(
                    "支給年月は yyyy-MM 形式で入力してください。");
        }

        // 금액 필수 입력 검사
        if (request.getBaseSalary() == null
                || request.getBonus() == null
                || request.getDeduction() == null) {

            throw new SalaryBusinessException(
                    "基本給、 手当、 控除額をすべて入力してください。");
        }

        // 음수 검사
        if (request.getBaseSalary().signum() < 0
                || request.getBonus().signum() < 0
                || request.getDeduction().signum() < 0) {

            throw new SalaryBusinessException(
                    "金額に負の値は指定できません。");
        }

        // DB DECIMAL(15,0) 범위 검사
        BigDecimal maxAmount =
                new BigDecimal("999999999999999");

        if (request.getBaseSalary().scale() > 0
                || request.getBonus().scale() > 0
                || request.getDeduction().scale() > 0) {

            throw new SalaryBusinessException(
                    "金額は整数で入力してください。");
        }

        if (request.getBaseSalary().compareTo(maxAmount) > 0
                || request.getBonus().compareTo(maxAmount) > 0
                || request.getDeduction().compareTo(maxAmount) > 0) {

            throw new SalaryBusinessException(
                    "金額は 15桁以内で入力してください。");
        }

        // 실수령액 계산
        BigDecimal netSalary = SalaryCalculator.calculate(
                request.getBaseSalary(),
                request.getBonus(),
                request.getDeduction()
        );

        if (netSalary.abs().compareTo(maxAmount) > 0) {
            throw new SalaryBusinessException(
                    "手取り額は 15桁以内の金額である必要があります。");
        }

        // Salary 도메인 객체 생성
        Salary salary = new Salary();

        salary.setEmpId(request.getEmpId());
        salary.setSalaryYearMonth(yearMonth);
        salary.setBaseSalary(request.getBaseSalary());
        salary.setBonus(request.getBonus());
        salary.setDeduction(request.getDeduction());
        salary.setNetSalary(netSalary);
        salary.setPaymentDate(request.getPaymentDate());

        return salary;
    }

    // 6. 급여 등록
    @Transactional
    public Long createSalary(SalaryCreateRequest request) {

        // 입력값 검사 및 실수령액 계산
        Salary salary = prepareSalary(request);

        // 사원 존재 여부 확인
        if (salaryMapper.countEmployeeById(
                salary.getEmpId()) == 0) {

            throw new SalaryBusinessException(
                    "指定された社員番号は存在しません。");
        }

        // 같은 사원의 동일 지급 연월 중복 검사
        int count = salaryMapper.countByEmpAndYearMonth(
                salary.getEmpId(),
                salary.getSalaryYearMonth()
        );

        if (count > 0) {
            throw new SalaryBusinessException(
                    "この社員の同じ支給年月の給与はすでに登録されています。");
        }

        int result;

        try {
            result = salaryMapper.insert(salary);

        } catch (DuplicateKeyException e) {
            throw new SalaryBusinessException(
                    "この社員の同じ支給年月の給与はすでに登録されています。",
                    e
            );
        }

        // 등록 성공 여부 확인
        if (result != 1) {
            throw new SalaryBusinessException(
                    "給与の登録に失敗しました。");
        }

        // 새로 생성된 급여 ID 반환
        return salary.getSalaryId();
    }

 // =========================================
 // 7. 본인 급여 목록 조회
 // =========================================
 public List<Salary> getMySalaryList(Long empId, String year) {

     if (empId == null || empId <= 0) {
         throw new SalaryBusinessException(
                 "社員情報を確認できません。");
     }

     String searchYear = year == null ? "" : year.trim();

     // 연도 형식 검사
     if (!searchYear.isEmpty()
             && !searchYear.matches("[0-9]{4}")) {

         throw new SalaryBusinessException(
                 "検索年は yyyy 形式で入力してください。");
     }

     return salaryMapper.selectMySalaries(empId, searchYear);
 }


 // =========================================
 // 8. 본인 급여 상세 조회
 // =========================================
 public Salary getMySalaryDetail(Long empId, Long salaryId) {

     if (empId == null || empId <= 0
             || salaryId == null || salaryId <= 0) {

         throw new SalaryNotFoundException();
     }

     Salary salary = salaryMapper.selectMySalaryDetail(
             empId, salaryId);

     if (salary == null) {
         throw new SalaryNotFoundException();
     }

     return salary;
 }

    
}