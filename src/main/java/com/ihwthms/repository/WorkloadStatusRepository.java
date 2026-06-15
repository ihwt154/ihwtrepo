package com.ihwthms.repository;

import com.ihwthms.entity.WorkloadStatusEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WorkloadStatusRepository extends JpaRepository<WorkloadStatusEntity, Integer> {
    List<WorkloadStatusEntity> findByWorkloadStatusObjTypeAndActive(String workloadStatusObjType, Boolean active);
}
