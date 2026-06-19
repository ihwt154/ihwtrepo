package com.ihwthms.service;

import com.ihwthms.entity.City;
import com.ihwthms.repository.CityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CityService {

    @Autowired
    private CityRepository cityRepository;

    public List<City> getAllCities() {
        return cityRepository.findAll();
    }

    public City saveCity(City city) {
        return cityRepository.save(city);
    }

    public Optional<City> findById(Long id) {
        return cityRepository.findById(id);
    }

    public boolean existsByName(String name) {
        return cityRepository.findByName(name).isPresent();
    }
}
