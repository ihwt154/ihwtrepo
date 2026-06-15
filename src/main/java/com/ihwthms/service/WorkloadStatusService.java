package com.ihwthms.service;

import com.ihwthms.entity.WorkloadStatusEntity;
import com.ihwthms.repository.WorkloadStatusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class WorkloadStatusService {

    @Autowired
    private WorkloadStatusRepository workloadStatusRepository;

    private static final List<String> FALLBACK_LEAD_STATUSES = Arrays.asList(
            "Open", "Work In Progress", "Won-Converted", "Failed-Closed", "Duplicate");

    public List<String> getActiveLeadStatuses() {
        try {
            List<WorkloadStatusEntity> statuses = workloadStatusRepository
                    .findByWorkloadStatusObjTypeAndActive("LEAD_STATUS", true);
            if (statuses == null || statuses.isEmpty()) {
                return FALLBACK_LEAD_STATUSES;
            }
            return statuses.stream()
                    .map(WorkloadStatusEntity::getWorkloadStatusName)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return FALLBACK_LEAD_STATUSES;
        }
    }
}
