# Script interactivo para insertar datos en la base de datos
$baseUrl = "http://localhost:8081/api"

function Show-Menu {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "   SISTEMA DE CALIFICACIONES" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "1. Agregar Alumno"
    Write-Host "2. Agregar Materia"
    Write-Host "3. Agregar Nota"
    Write-Host "4. Ver todos los Alumnos"
    Write-Host "5. Ver todas las Materias"
    Write-Host "6. Ver todas las Notas"
    Write-Host "7. Salir"
    Write-Host "========================================" -ForegroundColor Cyan
}

function Add-Alumno {
    Write-Host "`n--- AGREGAR ALUMNO ---" -ForegroundColor Green
    $nombre = Read-Host "Nombre"
    $apellido = Read-Host "Apellido"
    $email = Read-Host "Email"
    $fechaNacimiento = Read-Host "Fecha de nacimiento (YYYY-MM-DD)"
    
    $body = @{
        nombre = $nombre
        apellido = $apellido
        email = $email
        fechaNacimiento = $fechaNacimiento
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/alumnos" -Method POST -ContentType "application/json" -Body $body
        Write-Host "`n✓ Alumno agregado exitosamente!" -ForegroundColor Green
        Write-Host "ID: $($response.id)"
        Write-Host "Nombre completo: $($response.nombre) $($response.apellido)"
        Write-Host "Email: $($response.email)"
    } catch {
        Write-Host "`n✗ Error al agregar alumno: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Add-Materia {
    Write-Host "`n--- AGREGAR MATERIA ---" -ForegroundColor Green
    $nombre = Read-Host "Nombre de la materia"
    $codigo = Read-Host "Código de la materia"
    $creditos = Read-Host "Créditos (número entero)"
    
    $body = @{
        nombre = $nombre
        codigo = $codigo
        creditos = [int]$creditos
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/materias" -Method POST -ContentType "application/json" -Body $body
        Write-Host "`n✓ Materia agregada exitosamente!" -ForegroundColor Green
        Write-Host "ID: $($response.id)"
        Write-Host "Nombre: $($response.nombre)"
        Write-Host "Código: $($response.codigo)"
        Write-Host "Créditos: $($response.creditos)"
    } catch {
        Write-Host "`n✗ Error al agregar materia: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Add-Nota {
    Write-Host "`n--- AGREGAR NOTA ---" -ForegroundColor Green
    
    # Mostrar alumnos disponibles
    try {
        $alumnos = Invoke-RestMethod -Uri "$baseUrl/alumnos" -Method GET
        Write-Host "`nAlumnos disponibles:" -ForegroundColor Yellow
        foreach ($alumno in $alumnos) {
            Write-Host "  ID: $($alumno.id) - $($alumno.nombre) $($alumno.apellido)"
        }
    } catch {
        Write-Host "Error al obtener alumnos" -ForegroundColor Red
    }
    
    $alumnoId = Read-Host "`nID del alumno"
    
    # Mostrar materias disponibles
    try {
        $materias = Invoke-RestMethod -Uri "$baseUrl/materias" -Method GET
        Write-Host "`nMaterias disponibles:" -ForegroundColor Yellow
        foreach ($materia in $materias) {
            Write-Host "  ID: $($materia.id) - $($materia.nombre) ($($materia.codigo))"
        }
    } catch {
        Write-Host "Error al obtener materias" -ForegroundColor Red
    }
    
    $materiaId = Read-Host "`nID de la materia"
    $valor = Read-Host "Calificación (0.0 - 5.0)"
    
    $body = @{
        alumnoId = [int]$alumnoId
        materiaId = [int]$materiaId
        valor = [double]$valor
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/notas" -Method POST -ContentType "application/json" -Body $body
        Write-Host "`n✓ Nota agregada exitosamente!" -ForegroundColor Green
        Write-Host "ID: $($response.id)"
        Write-Host "Calificación: $($response.valor)"
        Write-Host "Fecha: $($response.fechaRegistro)"
    } catch {
        Write-Host "`n✗ Error al agregar nota: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-Alumnos {
    Write-Host "`n--- LISTA DE ALUMNOS ---" -ForegroundColor Yellow
    try {
        $alumnos = Invoke-RestMethod -Uri "$baseUrl/alumnos" -Method GET
        if ($alumnos.Count -eq 0) {
            Write-Host "No hay alumnos registrados" -ForegroundColor Gray
        } else {
            foreach ($alumno in $alumnos) {
                Write-Host "`nID: $($alumno.id)" -ForegroundColor Cyan
                Write-Host "Nombre: $($alumno.nombre) $($alumno.apellido)"
                Write-Host "Email: $($alumno.email)"
                Write-Host "Fecha de nacimiento: $($alumno.fechaNacimiento)"
            }
            Write-Host "`nTotal: $($alumnos.Count) alumno(s)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Error al obtener alumnos: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-Materias {
    Write-Host "`n--- LISTA DE MATERIAS ---" -ForegroundColor Yellow
    try {
        $materias = Invoke-RestMethod -Uri "$baseUrl/materias" -Method GET
        if ($materias.Count -eq 0) {
            Write-Host "No hay materias registradas" -ForegroundColor Gray
        } else {
            foreach ($materia in $materias) {
                Write-Host "`nID: $($materia.id)" -ForegroundColor Cyan
                Write-Host "Nombre: $($materia.nombre)"
                Write-Host "Código: $($materia.codigo)"
                Write-Host "Créditos: $($materia.creditos)"
            }
            Write-Host "`nTotal: $($materias.Count) materia(s)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Error al obtener materias: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-Notas {
    Write-Host "`n--- LISTA DE NOTAS ---" -ForegroundColor Yellow
    try {
        $notas = Invoke-RestMethod -Uri "$baseUrl/notas" -Method GET
        if ($notas.Count -eq 0) {
            Write-Host "No hay notas registradas" -ForegroundColor Gray
        } else {
            foreach ($nota in $notas) {
                Write-Host "`nID: $($nota.id)" -ForegroundColor Cyan
                Write-Host "Alumno: $($nota.alumno.nombre) $($nota.alumno.apellido)"
                Write-Host "Materia: $($nota.materia.nombre) ($($nota.materia.codigo))"
                Write-Host "Calificación: $($nota.valor)" -ForegroundColor $(if ($nota.valor -ge 3.0) { "Green" } else { "Red" })
                Write-Host "Fecha: $($nota.fechaRegistro)"
            }
            Write-Host "`nTotal: $($notas.Count) nota(s)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Error al obtener notas: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Verificar si el servidor está corriendo
try {
    Invoke-RestMethod -Uri "$baseUrl/alumnos" -Method GET -ErrorAction Stop | Out-Null
    Write-Host "✓ Servidor conectado exitosamente en $baseUrl" -ForegroundColor Green
} catch {
    Write-Host "✗ No se puede conectar al servidor en $baseUrl" -ForegroundColor Red
    Write-Host "Asegúrate de que el servidor Spring Boot esté corriendo en el puerto 8081" -ForegroundColor Yellow
    exit
}

# Menú principal
do {
    Show-Menu
    $opcion = Read-Host "`nSelecciona una opción (1-7)"
    
    switch ($opcion) {
        "1" { Add-Alumno }
        "2" { Add-Materia }
        "3" { Add-Nota }
        "4" { Show-Alumnos }
        "5" { Show-Materias }
        "6" { Show-Notas }
        "7" { 
            Write-Host "`n¡Hasta luego!" -ForegroundColor Cyan
            break
        }
        default { Write-Host "`nOpción no válida. Intenta de nuevo." -ForegroundColor Red }
    }
    
    if ($opcion -ne "7") {
        Read-Host "`nPresiona Enter para continuar" | Out-Null
    }
    
} while ($opcion -ne "7")
