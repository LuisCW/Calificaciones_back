package com.calificaciones.controller;

import com.calificaciones.dto.AlumnoResponse;
import com.calificaciones.entity.Alumno;
import com.calificaciones.service.AlumnoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/alumnos")
@CrossOrigin(origins = "*")
public class AlumnoController {
    
    @Autowired
    private AlumnoService alumnoService;
    
    @PostMapping
    public ResponseEntity<?> crearAlumno(@Valid @RequestBody Alumno alumno) {
        try {
            Alumno nuevoAlumno = alumnoService.crearAlumno(alumno);
            return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(nuevoAlumno));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    
    @GetMapping
    public ResponseEntity<List<AlumnoResponse>> listarAlumnos() {
        List<Alumno> alumnos = alumnoService.listarAlumnos();
        List<AlumnoResponse> response = alumnos.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> obtenerAlumnoPorId(@PathVariable Long id) {
        return alumnoService.obtenerAlumnoPorId(id)
                .map(alumno -> ResponseEntity.ok(toResponse(alumno)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<?> actualizarAlumno(@PathVariable Long id, @Valid @RequestBody Alumno alumno) {
        try {
            Alumno alumnoActualizado = alumnoService.actualizarAlumno(id, alumno);
            return ResponseEntity.ok(toResponse(alumnoActualizado));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    private AlumnoResponse toResponse(Alumno alumno) {
        return new AlumnoResponse(
                alumno.getId(),
                alumno.getNombre(),
                alumno.getApellido(),
                alumno.getEmail(),
                alumno.getFechaNacimiento()
        );
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminarAlumno(@PathVariable Long id) {
        try {
            alumnoService.eliminarAlumno(id);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}
