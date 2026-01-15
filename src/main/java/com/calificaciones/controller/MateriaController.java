package com.calificaciones.controller;

import com.calificaciones.dto.MateriaResponse;
import com.calificaciones.entity.Materia;
import com.calificaciones.service.MateriaService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/materias")
@CrossOrigin(origins = "*")
public class MateriaController {
    
    @Autowired
    private MateriaService materiaService;
    
    @PostMapping
    public ResponseEntity<?> crearMateria(@Valid @RequestBody Materia materia) {
        try {
            Materia nuevaMateria = materiaService.crearMateria(materia);
            return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(nuevaMateria));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    
    @GetMapping
    public ResponseEntity<List<MateriaResponse>> listarMaterias() {
        List<Materia> materias = materiaService.listarMaterias();
        List<MateriaResponse> response = materias.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> obtenerMateriaPorId(@PathVariable Long id) {
        return materiaService.obtenerMateriaPorId(id)
                .map(materia -> ResponseEntity.ok(toResponse(materia)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<?> actualizarMateria(@PathVariable Long id, @Valid @RequestBody Materia materia) {
        try {
            Materia materiaActualizada = materiaService.actualizarMateria(id, materia);
            return ResponseEntity.ok(toResponse(materiaActualizada));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    private MateriaResponse toResponse(Materia materia) {
        return new MateriaResponse(
                materia.getId(),
                materia.getNombre(),
                materia.getCodigo(),
                materia.getCreditos()
        );
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminarMateria(@PathVariable Long id) {
        try {
            materiaService.eliminarMateria(id);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}
