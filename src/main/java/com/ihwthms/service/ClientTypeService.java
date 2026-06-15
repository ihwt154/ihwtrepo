package com.ihwthms.service;

import com.ihwthms.entity.ClientTypeEntity;
import com.ihwthms.repository.ClientTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClientTypeService {

    @Autowired
    private ClientTypeRepository clientTypeRepository;

    public List<ClientTypeEntity> findAll() {
        return clientTypeRepository.findAll();
    }

    public List<ClientTypeEntity> findAllActive() {
        return clientTypeRepository.findByActiveTrue();
    }

    public ClientTypeEntity findById(Long id) {
        return clientTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client Type not found: " + id));
    }

    public ClientTypeEntity save(ClientTypeEntity entity) {
        return clientTypeRepository.save(entity);
    }

    public void toggleActive(Long id) {
        ClientTypeEntity entity = findById(id);
        entity.setActive(!Boolean.TRUE.equals(entity.getActive()));
        clientTypeRepository.save(entity);
    }
}
