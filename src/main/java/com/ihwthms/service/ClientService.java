package com.ihwthms.service;

import com.ihwthms.entity.ClientEntity;
import com.ihwthms.repository.ClientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

@Service
public class ClientService {

    @Autowired
    private ClientRepository clientRepository;

    public ClientEntity saveClient(ClientEntity entity) {
        entity.setUpdatedAt(java.time.LocalDateTime.now());
        return clientRepository.save(entity);
    }

    public ClientEntity findById(Long id) {
        return clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found: " + id));
    }

    public List<ClientEntity> findAllActive() {
        return clientRepository.findByActiveTrue();
    }

    public List<ClientEntity> searchByName(String name) {
        return clientRepository.findByClientNameContainingIgnoreCase(name);
    }

    public boolean isMobileExists(String mobile) {
        return clientRepository.existsByMobile(mobile);
    }

    public boolean isMobileExistsForOther(String mobile, Long clientId) {
        return clientRepository.existsByMobileAndClientIdNot(mobile, clientId);
    }

    public Page<ClientEntity> filterClients(String clientName, Boolean active, String city, Pageable pageable) {
        Specification<ClientEntity> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (clientName != null && !clientName.trim().isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("clientName")), "%" + clientName.toLowerCase() + "%"));
            }
            if (active != null) {
                predicates.add(cb.equal(root.get("active"), active));
            }
            if (city != null && !city.trim().isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("city")), "%" + city.toLowerCase() + "%"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        return clientRepository.findAll(spec, pageable);
    }

    public List<ClientEntity> filterClientsList(String clientName, Boolean active, String city) {
        Specification<ClientEntity> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (clientName != null && !clientName.trim().isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("clientName")), "%" + clientName.toLowerCase() + "%"));
            }
            if (active != null) {
                predicates.add(cb.equal(root.get("active"), active));
            }
            if (city != null && !city.trim().isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("city")), "%" + city.toLowerCase() + "%"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        return clientRepository.findAll(spec);
    }

    public void toggleActive(Long id) {
        ClientEntity c = findById(id);
        c.setActive(!Boolean.TRUE.equals(c.getActive()));
        c.setUpdatedAt(java.time.LocalDateTime.now());
        clientRepository.save(c);
    }
}
