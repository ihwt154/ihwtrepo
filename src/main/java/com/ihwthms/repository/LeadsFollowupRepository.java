package com.ihwthms.repository;

import com.ihwthms.entity.LeadsFollowupEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LeadsFollowupRepository extends JpaRepository<LeadsFollowupEntity, Long> {
    List<LeadsFollowupEntity> findByLeadEntity_IdOrderByNextfollowuptimeDesc(Long leadId);
}
