package com.hexagon.hrproject.dto.response;

public class AdminLeaveRequestRow {
    private int requestId;
    private int empId;
    private String empName;
    private Integer departmentId;
    private String department;
    private String requestDate;
    private String startDate;
    private String endDate;
    private java.math.BigDecimal days;
    private String reason;
    private String status;
    private Integer approverId;
    private String approverName;
    private String approvedAt;
    public int getRequestId() { return requestId; }
    public void setRequestId(int value) { this.requestId = value; }
    public int getEmpId() { return empId; }
    public void setEmpId(int value) { this.empId = value; }
    public String getEmpName() { return empName; }
    public void setEmpName(String value) { this.empName = value; }
    public Integer getDepartmentId() { return departmentId; }
    public void setDepartmentId(Integer value) { this.departmentId = value; }
    public String getDepartment() { return department; }
    public void setDepartment(String value) { this.department = value; }
    public String getRequestDate() { return requestDate; }
    public void setRequestDate(String value) { this.requestDate = value; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String value) { this.startDate = value; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String value) { this.endDate = value; }
    public java.math.BigDecimal getDays() { return days; }
    public void setDays(java.math.BigDecimal value) { this.days = value; }
    public String getReason() { return reason; }
    public void setReason(String value) { this.reason = value; }
    public String getStatus() { return status; }
    public void setStatus(String value) { this.status = value; }
    public Integer getApproverId() { return approverId; }
    public void setApproverId(Integer value) { this.approverId = value; }
    public String getApproverName() { return approverName; }
    public void setApproverName(String value) { this.approverName = value; }
    public String getApprovedAt() { return approvedAt; }
    public void setApprovedAt(String value) { this.approvedAt = value; }
}
