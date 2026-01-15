package com.calificaciones.service;

import com.calificaciones.entity.Alumno;
import com.calificaciones.entity.Materia;
import com.calificaciones.entity.Nota;
import com.calificaciones.repository.AlumnoRepository;
import com.calificaciones.repository.MateriaRepository;
import com.calificaciones.repository.NotaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class NotaService {
    
    @Autowired
    private NotaRepository notaRepository;
    
    @Autowired
    private AlumnoRepository alumnoRepository;
    
    @Autowired
    private MateriaRepository materiaRepository;
    
    public Nota registrarNota(Nota nota) {
        // Si ya existe nota para el mismo alumno y materia, actualizarla
        return notaRepository.findFirstByAlumnoIdAndMateriaId(
                        nota.getAlumno().getId(),
                        nota.getMateria().getId()
                )
                .map(existente -> {
                    existente.setValor(nota.getValor());
                    existente.setFechaRegistro(nota.getFechaRegistro());
                    return notaRepository.save(existente);
                })
                .orElseGet(() -> notaRepository.save(nota));
    }
    
    @Transactional(readOnly = true)
    public List<Nota> listarNotasPorAlumno(Long alumnoId) {
        if (!alumnoRepository.existsById(alumnoId)) {
            throw new RuntimeException("Alumno no encontrado con id: " + alumnoId);
        }
        return notaRepository.findByAlumnoId(alumnoId);
    }
    
    @Transactional(readOnly = true)
    public List<Nota> listarNotasPorMateria(Long materiaId) {
        if (!materiaRepository.existsById(materiaId)) {
            throw new RuntimeException("Materia no encontrada con id: " + materiaId);
        }
        return notaRepository.findByMateriaId(materiaId);
    }
    
    @Transactional(readOnly = true)
    public List<Nota> listarNotasPorAlumnoYMateria(Long alumnoId, Long materiaId) {
        if (!alumnoRepository.existsById(alumnoId)) {
            throw new RuntimeException("Alumno no encontrado con id: " + alumnoId);
        }
        if (!materiaRepository.existsById(materiaId)) {
            throw new RuntimeException("Materia no encontrada con id: " + materiaId);
        }
        return notaRepository.findByAlumnoIdAndMateriaId(alumnoId, materiaId);
    }
    
    @Transactional(readOnly = true)
    public List<Nota> listarTodasLasNotas() {
        return notaRepository.findAll();
    }
}
