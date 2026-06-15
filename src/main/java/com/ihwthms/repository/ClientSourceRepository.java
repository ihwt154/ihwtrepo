package com.ihwthms.repository;

import com.ihwthms.entity.ClientSourceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClientSourceRepository extends JpaRepository<ClientSourceEntity, Long> {
    List<ClientSourceEntity> findByActiveTrue();
}
