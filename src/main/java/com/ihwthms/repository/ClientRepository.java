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
    boolean existsByEmailId(String emailId);
    boolean existsByEmailIdAndClientIdNot(String emailId, Long clientId);

    @org.springframework.data.jpa.repository.Query("SELECT MAX(c.clientCode) FROM ClientEntity c WHERE c.clientCode LIKE 'CLI-%'")
    String findMaxClientCode();
}
