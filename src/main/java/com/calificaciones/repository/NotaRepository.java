package com.calificaciones.repository;

import com.calificaciones.entity.Nota;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NotaRepository extends JpaRepository<Nota, Long> {
    List<Nota> findByAlumnoId(Long alumnoId);
    List<Nota> findByMateriaId(Long materiaId);
    
    @Query("SELECT n FROM Nota n WHERE n.alumno.id = :alumnoId AND n.materia.id = :materiaId")
    List<Nota> findByAlumnoIdAndMateriaId(@Param("alumnoId") Long alumnoId, @Param("materiaId") Long materiaId);

    @Query("SELECT n FROM Nota n WHERE n.alumno.id = :alumnoId AND n.materia.id = :materiaId")
    Optional<Nota> findFirstByAlumnoIdAndMateriaId(@Param("alumnoId") Long alumnoId, @Param("materiaId") Long materiaId);
}
