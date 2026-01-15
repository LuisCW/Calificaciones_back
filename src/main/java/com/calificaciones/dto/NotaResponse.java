package com.calificaciones.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotaResponse {
    private Long id;
    private Double valor;
    private LocalDate fechaRegistro;
    private Long alumnoId;
    private String alumnoNombre;
    private Long materiaId;
    private String materiaNombre;
}
