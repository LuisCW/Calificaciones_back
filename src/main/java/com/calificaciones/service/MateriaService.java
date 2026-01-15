package com.calificaciones.service;

import com.calificaciones.entity.Materia;
import com.calificaciones.repository.MateriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MateriaService {
    
    @Autowired
    private MateriaRepository materiaRepository;
    
    public Materia crearMateria(Materia materia) {
        if (materiaRepository.existsByCodigo(materia.getCodigo())) {
            throw new RuntimeException("Ya existe una materia con el código: " + materia.getCodigo());
        }
        return materiaRepository.save(materia);
    }
    
    @Transactional(readOnly = true)
    public List<Materia> listarMaterias() {
        return materiaRepository.findAll();
    }
    
    @Transactional(readOnly = true)
    public Optional<Materia> obtenerMateriaPorId(Long id) {
        return materiaRepository.findById(id);
    }
    
    public Materia actualizarMateria(Long id, Materia materiaActualizada) {
        Materia materia = materiaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Materia no encontrada con id: " + id));
        
        // Verificar si el código ya existe en otra materia
        if (!materia.getCodigo().equals(materiaActualizada.getCodigo()) && 
            materiaRepository.existsByCodigo(materiaActualizada.getCodigo())) {
            throw new RuntimeException("Ya existe una materia con el código: " + materiaActualizada.getCodigo());
        }
        
        materia.setNombre(materiaActualizada.getNombre());
        materia.setCodigo(materiaActualizada.getCodigo());
        materia.setCreditos(materiaActualizada.getCreditos());
        
        return materiaRepository.save(materia);
    }
    
    public void eliminarMateria(Long id) {
        if (!materiaRepository.existsById(id)) {
            throw new RuntimeException("Materia no encontrada con id: " + id);
        }
        materiaRepository.deleteById(id);
    }
}
