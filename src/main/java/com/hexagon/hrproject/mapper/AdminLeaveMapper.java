package com.hexagon.hrproject.mapper;

import java.util.List;
import java.sql.Date;
import java.math.BigDecimal;
import org.apache.ibatis.annotations.Param;
import com.hexagon.hrproject.dto.response.AdminLeaveRequestRow;
import com.hexagon.hrproject.dto.response.AdminLeaveBalance;

public interface AdminLeaveMapper {
    List<AdminLeaveRequestRow> findRequests(@Param("departmentId") Integer departmentId,
        @Param("startDate") Date startDate, @Param("endExclusive") Date endExclusive,
        @Param("status") String status, @Param("keyword") String keyword);
    AdminLeaveRequestRow lockRequest(@Param("requestId") int requestId);
    AdminLeaveBalance lockBalance(@Param("empId") int empId, @Param("fiscalYear") String fiscalYear);
    int consumeBalance(@Param("balanceId") int balanceId, @Param("days") BigDecimal days);
    int decide(@Param("requestId") int requestId, @Param("status") String status,
        @Param("approverId") int approverId);
}
