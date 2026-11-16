package com.hexagon.hrproject.dto.response;

public class AdminLeaveBalance {
    private int balanceId;
    private java.math.BigDecimal totalDays;
    private java.math.BigDecimal usedDays;
    public int getBalanceId() { return balanceId; }
    public void setBalanceId(int value) { this.balanceId = value; }
    public java.math.BigDecimal getTotalDays() { return totalDays; }
    public void setTotalDays(java.math.BigDecimal value) { this.totalDays = value; }
    public java.math.BigDecimal getUsedDays() { return usedDays; }
    public void setUsedDays(java.math.BigDecimal value) { this.usedDays = value; }
}
