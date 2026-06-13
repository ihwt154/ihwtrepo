package com.ihwthms.repository;

import com.ihwthms.entity.CentralConfigEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CentralConfigEntityRepository extends JpaRepository<CentralConfigEntity, Integer> {
    CentralConfigEntity findTopByOrderByIdAsc();
}
