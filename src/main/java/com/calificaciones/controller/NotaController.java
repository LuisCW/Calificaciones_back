package com.calificaciones.controller;

import com.calificaciones.dto.NotaRequest;
import com.calificaciones.dto.NotaResponse;
import com.calificaciones.entity.Alumno;
import com.calificaciones.entity.Materia;
import com.calificaciones.entity.Nota;
import com.calificaciones.repository.AlumnoRepository;
import com.calificaciones.repository.MateriaRepository;
import com.calificaciones.service.NotaService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/notas")
@CrossOrigin(origins = "*")
public class NotaController {
    
    @Autowired
    private NotaService notaService;
    
    @Autowired
    private AlumnoRepository alumnoRepository;
    
    @Autowired
    private MateriaRepository materiaRepository;
    
    @PostMapping
    public ResponseEntity<?> registrarNota(@Valid @RequestBody NotaRequest notaRequest) {
        try {
            Alumno alumno = alumnoRepository.findById(notaRequest.getAlumnoId())
                .orElseThrow(() -> new RuntimeException("Alumno no encontrado"));
            
            Materia materia = materiaRepository.findById(notaRequest.getMateriaId())
                .orElseThrow(() -> new RuntimeException("Materia no encontrada"));
            
            Nota nota = new Nota();
            nota.setValor(notaRequest.getValor());
            nota.setFechaRegistro(notaRequest.getFechaRegistro());
            nota.setAlumno(alumno);
            nota.setMateria(materia);
            
            Nota nuevaNota = notaService.registrarNota(nota);
            
            // Devolver DTO simple sin relaciones para evitar problemas de serialización
            NotaResponse response = new NotaResponse();
            response.setId(nuevaNota.getId());
            response.setValor(nuevaNota.getValor());
            response.setFechaRegistro(nuevaNota.getFechaRegistro());
            response.setAlumnoId(alumno.getId());
            response.setAlumnoNombre(alumno.getNombre() + " " + alumno.getApellido());
            response.setMateriaId(materia.getId());
            response.setMateriaNombre(materia.getNombre());
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    
    @GetMapping("/alumno/{alumnoId}")
    public ResponseEntity<?> listarNotasPorAlumno(@PathVariable Long alumnoId) {
        try {
            List<Nota> notas = notaService.listarNotasPorAlumno(alumnoId);
            List<NotaResponse> response = notas.stream()
                    .map(this::toResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
    
    @GetMapping("/materia/{materiaId}")
    public ResponseEntity<?> listarNotasPorMateria(@PathVariable Long materiaId) {
        try {
            List<Nota> notas = notaService.listarNotasPorMateria(materiaId);
            List<NotaResponse> response = notas.stream()
                    .map(this::toResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
    
    @GetMapping("/alumno/{alumnoId}/materia/{materiaId}")
    public ResponseEntity<?> listarNotasPorAlumnoYMateria(
            @PathVariable Long alumnoId, 
            @PathVariable Long materiaId) {
        try {
            List<Nota> notas = notaService.listarNotasPorAlumnoYMateria(alumnoId, materiaId);
            List<NotaResponse> response = notas.stream()
                    .map(this::toResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
    
    @GetMapping
    public ResponseEntity<List<NotaResponse>> listarTodasLasNotas() {
        List<Nota> notas = notaService.listarTodasLasNotas();
        List<NotaResponse> response = notas.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    private NotaResponse toResponse(Nota nota) {
        NotaResponse response = new NotaResponse();
        response.setId(nota.getId());
        response.setValor(nota.getValor());
        response.setFechaRegistro(nota.getFechaRegistro());

        if (nota.getAlumno() != null) {
            response.setAlumnoId(nota.getAlumno().getId());
            response.setAlumnoNombre(nota.getAlumno().getNombre() + " " + nota.getAlumno().getApellido());
        }

        if (nota.getMateria() != null) {
            response.setMateriaId(nota.getMateria().getId());
            response.setMateriaNombre(nota.getMateria().getNombre());
        }

        return response;
    }
}
