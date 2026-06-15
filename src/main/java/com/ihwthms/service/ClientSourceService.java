package com.ihwthms.service;

import com.ihwthms.entity.ClientSourceEntity;
import com.ihwthms.repository.ClientSourceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClientSourceService {

    @Autowired
    private ClientSourceRepository clientSourceRepository;

    public List<ClientSourceEntity> findAll() {
        return clientSourceRepository.findAll();
    }

    public List<ClientSourceEntity> findAllActive() {
        return clientSourceRepository.findByActiveTrue();
    }

    public ClientSourceEntity findById(Long id) {
        return clientSourceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client Source not found: " + id));
    }

    public ClientSourceEntity save(ClientSourceEntity entity) {
        return clientSourceRepository.save(entity);
    }

    public void toggleActive(Long id) {
        ClientSourceEntity entity = findById(id);
        entity.setActive(!Boolean.TRUE.equals(entity.getActive()));
        clientSourceRepository.save(entity);
    }
}
