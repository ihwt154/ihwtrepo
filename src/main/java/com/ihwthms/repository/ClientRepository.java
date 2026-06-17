package com.ihwthms.repository;

import com.ihwthms.entity.ClientEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClientRepository extends JpaRepository<ClientEntity, Long>, JpaSpecificationExecutor<ClientEntity> {
    List<ClientEntity> findByActiveTrue();
    List<ClientEntity> findByClientNameContainingIgnoreCaseAndActiveTrue(String clientName);
    List<ClientEntity> findByClientNameContainingIgnoreCase(String clientName);
    boolean existsByMobile(String mobile);
    boolean existsByMobileAndClientIdNot(String mobile, Long clientId);
}
