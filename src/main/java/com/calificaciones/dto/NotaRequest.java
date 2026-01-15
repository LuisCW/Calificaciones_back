package com.calificaciones.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotaRequest {
    
    @NotNull(message = "El valor de la nota es obligatorio")
    @DecimalMin(value = "0.0", message = "La nota debe ser mayor o igual a 0")
    @DecimalMax(value = "5.0", message = "La nota debe ser menor o igual a 5")
    private Double valor;
    
    @NotNull(message = "La fecha de registro es obligatoria")
    private LocalDate fechaRegistro;
    
    @NotNull(message = "El ID del alumno es obligatorio")
    private Long alumnoId;
    
    @NotNull(message = "El ID de la materia es obligatorio")
    private Long materiaId;
}
