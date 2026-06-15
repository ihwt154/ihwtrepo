package com.ihwthms.service;

import com.ihwthms.entity.Lead;
import com.ihwthms.entity.LeadsFollowupEntity;
import com.ihwthms.repository.LeadRepository;
import com.ihwthms.repository.LeadsFollowupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class LeadService {

    @Autowired
    private LeadRepository leadRepository;

    @Autowired
    private LeadsFollowupRepository followupRepository;

    /**
     * Statuses that count as "Open" in the filter.
     */
    private static final List<String> OPEN_STATUSES = Arrays.asList("Open", "Work In Progress");

    /**
     * Statuses that count as "Closed" in the filter.
     */
    private static final List<String> CLOSED_STATUSES = Arrays.asList("Won-Converted", "Failed-Closed", "Duplicate");

    public Lead saveLead(Lead lead) {
        lead.setUpdatedAt(java.time.LocalDateTime.now());
        return leadRepository.save(lead);
    }

    public Lead findById(Long id) {
        return leadRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Lead not found: " + id));
    }

    public void saveFollowup(LeadsFollowupEntity followup) {
        followupRepository.save(followup);
    }

    public List<LeadsFollowupEntity> findFollowupsByLeadId(Long leadId) {
        return followupRepository.findByLeadEntity_IdOrderByNextfollowuptimeDesc(leadId);
    }

    /**
     * Build status predicates for the "Open"/"Closed" grouped filter.
     * If leadStatus is "Open" → match Open or Work In Progress.
     * If leadStatus is "Closed" → match Won-Converted, Failed-Closed, or Duplicate.
     * Otherwise (a specific status string) → exact match.
     */
    private void addStatusPredicate(List<Predicate> predicates,
                                     javax.persistence.criteria.Root<Lead> root,
                                     javax.persistence.criteria.CriteriaBuilder cb,
                                     String leadStatus) {
        if (leadStatus == null || leadStatus.trim().isEmpty()) return;

        if ("Open".equalsIgnoreCase(leadStatus.trim())) {
            predicates.add(root.get("leadStatus").in(OPEN_STATUSES));
        } else if ("Closed".equalsIgnoreCase(leadStatus.trim())) {
            predicates.add(root.get("leadStatus").in(CLOSED_STATUSES));
        } else {
            // direct / exact status
            predicates.add(cb.equal(root.get("leadStatus"), leadStatus));
        }
    }

    /**
     * Dynamic paginated filter matching vistalux pattern.
     */
    public Page<Lead> filterLeads(int pageNo, int pageSize, String leadStatus,
                                   String leadSource, String clientName,
                                   Long assignedTo, String priority) {
        Pageable pageable = PageRequest.of(pageNo, pageSize, Sort.by(Sort.Direction.DESC, "id"));

        Specification<Lead> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            query.distinct(true);

            addStatusPredicate(predicates, root, cb, leadStatus);

            if (leadSource != null && !leadSource.trim().isEmpty()) {
                predicates.add(cb.equal(root.get("leadSource"), leadSource));
            }
            if (clientName != null && !clientName.trim().isEmpty()) {
                predicates.add(cb.like(
                        cb.lower(root.join("client").get("clientName")),
                        "%" + clientName.toLowerCase() + "%"));
            }
            if (assignedTo != null && assignedTo > 0) {
                predicates.add(cb.equal(root.get("assignedTo"), assignedTo));
            }
            if (priority != null && !priority.trim().isEmpty()) {
                predicates.add(cb.equal(root.get("priority"), priority));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return leadRepository.findAll(spec, pageable);
    }

    /**
     * Unpaginated version of filterLeads – used for Excel/PDF exports.
     */
    public List<Lead> filterLeadsList(String leadStatus, String leadSource,
                                       String clientName, Long assignedTo, String priority) {
        Specification<Lead> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            query.distinct(true);

            addStatusPredicate(predicates, root, cb, leadStatus);

            if (leadSource != null && !leadSource.trim().isEmpty()) {
                predicates.add(cb.equal(root.get("leadSource"), leadSource));
            }
            if (clientName != null && !clientName.trim().isEmpty()) {
                predicates.add(cb.like(
                        cb.lower(root.join("client").get("clientName")),
                        "%" + clientName.toLowerCase() + "%"));
            }
            if (assignedTo != null && assignedTo > 0) {
                predicates.add(cb.equal(root.get("assignedTo"), assignedTo));
            }
            if (priority != null && !priority.trim().isEmpty()) {
                predicates.add(cb.equal(root.get("priority"), priority));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return leadRepository.findAll(spec);
    }
}
