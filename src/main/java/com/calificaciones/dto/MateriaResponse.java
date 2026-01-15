package com.calificaciones.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MateriaResponse {
    private Long id;
    private String nombre;
    private String codigo;
    private Integer creditos;
}
