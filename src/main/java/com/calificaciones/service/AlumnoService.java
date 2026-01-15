package com.calificaciones.service;

import com.calificaciones.entity.Alumno;
import com.calificaciones.repository.AlumnoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AlumnoService {
    
    @Autowired
    private AlumnoRepository alumnoRepository;
    
    public Alumno crearAlumno(Alumno alumno) {
        if (alumnoRepository.existsByEmail(alumno.getEmail())) {
            throw new RuntimeException("Ya existe un alumno con el email: " + alumno.getEmail());
        }
        return alumnoRepository.save(alumno);
    }
    
    @Transactional(readOnly = true)
    public List<Alumno> listarAlumnos() {
        return alumnoRepository.findAll();
    }
    
    @Transactional(readOnly = true)
    public Optional<Alumno> obtenerAlumnoPorId(Long id) {
        return alumnoRepository.findById(id);
    }
    
    public Alumno actualizarAlumno(Long id, Alumno alumnoActualizado) {
        Alumno alumno = alumnoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Alumno no encontrado con id: " + id));
        
        // Verificar si el email ya existe en otro alumno
        if (!alumno.getEmail().equals(alumnoActualizado.getEmail()) && 
            alumnoRepository.existsByEmail(alumnoActualizado.getEmail())) {
            throw new RuntimeException("Ya existe un alumno con el email: " + alumnoActualizado.getEmail());
        }
        
        alumno.setNombre(alumnoActualizado.getNombre());
        alumno.setApellido(alumnoActualizado.getApellido());
        alumno.setEmail(alumnoActualizado.getEmail());
        alumno.setFechaNacimiento(alumnoActualizado.getFechaNacimiento());
        
        return alumnoRepository.save(alumno);
    }
    
    public void eliminarAlumno(Long id) {
        if (!alumnoRepository.existsById(id)) {
            throw new RuntimeException("Alumno no encontrado con id: " + id);
        }
        alumnoRepository.deleteById(id);
    }
}
