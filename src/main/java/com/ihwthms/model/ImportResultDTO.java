package com.ihwthms.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Result summary returned after a bulk client import operation.
 */
public class ImportResultDTO {

    private int totalProcessed;
    private int successCount;
    private int failedCount;
    private List<ImportErrorRow> errors = new ArrayList<>();

    public ImportResultDTO() {}

    public int getTotalProcessed() { return totalProcessed; }
    public void setTotalProcessed(int totalProcessed) { this.totalProcessed = totalProcessed; }

    public int getSuccessCount() { return successCount; }
    public void setSuccessCount(int successCount) { this.successCount = successCount; }

    public int getFailedCount() { return failedCount; }
    public void setFailedCount(int failedCount) { this.failedCount = failedCount; }

    public List<ImportErrorRow> getErrors() { return errors; }
    public void setErrors(List<ImportErrorRow> errors) { this.errors = errors; }

    public void addError(ImportErrorRow row) { this.errors.add(row); }
}
