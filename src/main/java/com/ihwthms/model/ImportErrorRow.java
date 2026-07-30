package com.ihwthms.model;

/**
 * Represents a single failed row from the bulk client import.
 */
public class ImportErrorRow {

    private int rowNumber;
    private String clientName;
    private String mobile;
    private String email;
    private String reason;

    public ImportErrorRow() {}

    public ImportErrorRow(int rowNumber, String clientName, String mobile, String email, String reason) {
        this.rowNumber = rowNumber;
        this.clientName = clientName;
        this.mobile = mobile;
        this.email = email;
        this.reason = reason;
    }

    public int getRowNumber() { return rowNumber; }
    public void setRowNumber(int rowNumber) { this.rowNumber = rowNumber; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}
