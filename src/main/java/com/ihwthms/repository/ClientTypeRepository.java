package com.ihwthms.repository;

import com.ihwthms.entity.ClientTypeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClientTypeRepository extends JpaRepository<ClientTypeEntity, Long> {
    List<ClientTypeEntity> findByActiveTrue();
}
