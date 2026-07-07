package com.oilfield.petition.repository;

import com.oilfield.petition.entity.Petition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PetitionRepository extends JpaRepository<Petition, Long> {
    Petition findTopByOrderByIdDesc();
}
