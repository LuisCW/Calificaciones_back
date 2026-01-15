$baseUrl = "http://localhost:8081/api"

function Show-Menu {
    Write-Host "`n=== MENU DE GESTION ===" -ForegroundColor Cyan
    Write-Host "Alumno"
    Write-Host "1. Crear alumno"
    Write-Host "2. Listar alumnos"
    Write-Host "3. Consultar alumno por id"
    Write-Host "4. Actualizar alumno"
    Write-Host "5. Eliminar alumno"
    Write-Host ""
    Write-Host "Materia"
    Write-Host "6. Crear materia"
    Write-Host "7. Listar materias"
    Write-Host "8. Consultar materia por id"
    Write-Host "9. Actualizar materia"
    Write-Host "10. Eliminar materia"
    Write-Host ""
    Write-Host "Nota"
    Write-Host "11. Registrar/Actualizar nota"
    Write-Host "12. Listar notas por alumno"
    Write-Host "13. Salir"
    Write-Host ""
}

function Get-Alumnos {
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/alumnos" -Method Get
        return $response
    } catch {
        Write-Host "ERROR: No se pudieron obtener los alumnos" -ForegroundColor Red
        return @()
    }
}

function Get-Materias {
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/materias" -Method Get
        return $response
    } catch {
        Write-Host "ERROR: No se pudieron obtener las materias" -ForegroundColor Red
        return @()
    }
}

function Add-Alumno {
    Write-Host "`n--- AGREGAR ALUMNO ---" -ForegroundColor Yellow
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
        $response = Invoke-RestMethod -Uri "$baseUrl/alumnos" -Method Post -Body $body -ContentType "application/json"
        Write-Host "SUCCESS: Alumno agregado exitosamente con ID: $($response.id)" -ForegroundColor Green
    } catch {
        $errorMessage = $_.Exception.Message
        if ($_.ErrorDetails.Message) {
            $errorMessage = $_.ErrorDetails.Message
        }
        Write-Host "ERROR: No se pudo agregar el alumno - $errorMessage" -ForegroundColor Red
    }
}

function Get-AlumnoById {
    Write-Host "`n--- CONSULTAR ALUMNO POR ID ---" -ForegroundColor Yellow
    $id = Read-Host "ID del alumno"

    try {
        $alumno = Invoke-RestMethod -Uri "$baseUrl/alumnos/$id" -Method Get
        Write-Host "`nID: $($alumno.id)"
        Write-Host "  Nombre: $($alumno.nombre) $($alumno.apellido)"
        Write-Host "  Email: $($alumno.email)"
        Write-Host "  Fecha de nacimiento: $($alumno.fechaNacimiento)"
    } catch {
        Write-Host "ERROR: No se pudo obtener el alumno" -ForegroundColor Red
    }
}

function Update-Alumno {
    Write-Host "`n--- ACTUALIZAR ALUMNO ---" -ForegroundColor Yellow
    $id = Read-Host "ID del alumno"
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
        $response = Invoke-RestMethod -Uri "$baseUrl/alumnos/$id" -Method Put -Body $body -ContentType "application/json"
        Write-Host "SUCCESS: Alumno actualizado exitosamente" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: No se pudo actualizar el alumno" -ForegroundColor Red
    }
}

function Delete-Alumno {
    Write-Host "`n--- ELIMINAR ALUMNO ---" -ForegroundColor Yellow
    $id = Read-Host "ID del alumno"

    try {
        Invoke-RestMethod -Uri "$baseUrl/alumnos/$id" -Method Delete
        Write-Host "SUCCESS: Alumno eliminado exitosamente" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: No se pudo eliminar el alumno" -ForegroundColor Red
    }
}

function Add-Materia {
    Write-Host "`n--- AGREGAR MATERIA ---" -ForegroundColor Yellow
    $nombre = Read-Host "Nombre"
    $codigo = Read-Host "Codigo"
    $creditos = Read-Host "Creditos"

    $body = @{
        nombre = $nombre
        codigo = $codigo
        creditos = [int]$creditos
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/materias" -Method Post -Body $body -ContentType "application/json"
        Write-Host "SUCCESS: Materia agregada exitosamente con ID: $($response.id)" -ForegroundColor Green
    } catch {
        $errorMessage = $_.Exception.Message
        if ($_.ErrorDetails.Message) {
            $errorMessage = $_.ErrorDetails.Message
        }
        Write-Host "ERROR: No se pudo agregar la materia - $errorMessage" -ForegroundColor Red
    }
}

function Get-MateriaById {
    Write-Host "`n--- CONSULTAR MATERIA POR ID ---" -ForegroundColor Yellow
    $id = Read-Host "ID de la materia"

    try {
        $materia = Invoke-RestMethod -Uri "$baseUrl/materias/$id" -Method Get
        Write-Host "`nID: $($materia.id)"
        Write-Host "  Nombre: $($materia.nombre)"
        Write-Host "  Codigo: $($materia.codigo)"
        Write-Host "  Creditos: $($materia.creditos)"
    } catch {
        Write-Host "ERROR: No se pudo obtener la materia" -ForegroundColor Red
    }
}

function Update-Materia {
    Write-Host "`n--- ACTUALIZAR MATERIA ---" -ForegroundColor Yellow
    $id = Read-Host "ID de la materia"
    $nombre = Read-Host "Nombre"
    $codigo = Read-Host "Codigo"
    $creditos = Read-Host "Creditos"

    $body = @{
        nombre = $nombre
        codigo = $codigo
        creditos = [int]$creditos
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/materias/$id" -Method Put -Body $body -ContentType "application/json"
        Write-Host "SUCCESS: Materia actualizada exitosamente" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: No se pudo actualizar la materia" -ForegroundColor Red
    }
}

function Delete-Materia {
    Write-Host "`n--- ELIMINAR MATERIA ---" -ForegroundColor Yellow
    $id = Read-Host "ID de la materia"

    try {
        Invoke-RestMethod -Uri "$baseUrl/materias/$id" -Method Delete
        Write-Host "SUCCESS: Materia eliminada exitosamente" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: No se pudo eliminar la materia" -ForegroundColor Red
    }
}

function Add-Nota {
    Write-Host "`n--- REGISTRAR/ACTUALIZAR NOTA ---" -ForegroundColor Yellow

    $alumnos = Get-Alumnos
    if ($alumnos.Count -eq 0) {
        Write-Host "No hay alumnos registrados. Agrega un alumno primero." -ForegroundColor Red
        return
    }

    Write-Host "`nAlumnos disponibles:"
    foreach ($alumno in $alumnos) {
        Write-Host "  ID: $($alumno.id) - $($alumno.nombre) $($alumno.apellido)"
    }
    $alumnoId = Read-Host "`nID del alumno"

    $materias = Get-Materias
    if ($materias.Count -eq 0) {
        Write-Host "No hay materias registradas. Agrega una materia primero." -ForegroundColor Red
        return
    }

    Write-Host "`nMaterias disponibles:"
    foreach ($materia in $materias) {
        Write-Host "  ID: $($materia.id) - $($materia.nombre) ($($materia.codigo))"
    }
    $materiaId = Read-Host "`nID de la materia"
    $valor = Read-Host "Calificacion (0.0 - 5.0)"
    
    $fechaActual = (Get-Date).ToString("yyyy-MM-dd")

    $body = @{
        alumnoId = [int]$alumnoId
        materiaId = [int]$materiaId
        valor = [double]$valor
        fechaRegistro = $fechaActual
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/notas" -Method Post -Body $body -ContentType "application/json"
        Write-Host "SUCCESS: Nota registrada/actualizada con ID: $($response.id)" -ForegroundColor Green
    } catch {
        $errorMessage = $_.Exception.Message
        if ($_.ErrorDetails.Message) {
            $errorMessage = $_.ErrorDetails.Message
        }
        Write-Host "ERROR: No se pudo registrar la nota - $errorMessage" -ForegroundColor Red
    }
}

function List-Alumnos {
    Write-Host "`n--- LISTA DE ALUMNOS ---" -ForegroundColor Yellow
    $alumnos = Get-Alumnos
    
    if ($alumnos.Count -eq 0) {
        Write-Host "No hay alumnos registrados." -ForegroundColor Red
        return
    }

    foreach ($alumno in $alumnos) {
        Write-Host "`nID: $($alumno.id)"
        Write-Host "  Nombre: $($alumno.nombre) $($alumno.apellido)"
        Write-Host "  Email: $($alumno.email)"
        Write-Host "  Fecha de nacimiento: $($alumno.fechaNacimiento)"
    }
}

function List-Materias {
    Write-Host "`n--- LISTA DE MATERIAS ---" -ForegroundColor Yellow
    $materias = Get-Materias
    
    if ($materias.Count -eq 0) {
        Write-Host "No hay materias registradas." -ForegroundColor Red
        return
    }

    foreach ($materia in $materias) {
        Write-Host "`nID: $($materia.id)"
        Write-Host "  Nombre: $($materia.nombre)"
        Write-Host "  Codigo: $($materia.codigo)"
        Write-Host "  Creditos: $($materia.creditos)"
    }
}

function List-NotasPorAlumno {
    Write-Host "`n--- NOTAS POR ALUMNO ---" -ForegroundColor Yellow
    
    $alumnos = Get-Alumnos
    if ($alumnos.Count -eq 0) {
        Write-Host "No hay alumnos registrados." -ForegroundColor Red
        return
    }

    Write-Host "`nAlumnos disponibles:"
    foreach ($alumno in $alumnos) {
        Write-Host "  ID: $($alumno.id) - $($alumno.nombre) $($alumno.apellido)"
    }
    $alumnoId = Read-Host "`nID del alumno"

    try {
        $notas = Invoke-RestMethod -Uri "$baseUrl/notas/alumno/$alumnoId" -Method Get
        
        if ($notas.Count -eq 0) {
            Write-Host "Este alumno no tiene notas registradas." -ForegroundColor Red
            return
        }

        Write-Host "`nNotas del alumno:"
        foreach ($nota in $notas) {
            Write-Host "`n  Materia: $($nota.materiaNombre)"
            Write-Host "  Calificacion: $($nota.valor)"
            Write-Host "  Fecha: $($nota.fechaRegistro)"
        }
    } catch {
        Write-Host "ERROR: No se pudieron obtener las notas" -ForegroundColor Red
    }
}

# Menu principal
do {
    Show-Menu
    $opcion = Read-Host "Selecciona una opcion (1-13)"
    
    switch ($opcion) {
        "1" { Add-Alumno }
        "2" { List-Alumnos }
        "3" { Get-AlumnoById }
        "4" { Update-Alumno }
        "5" { Delete-Alumno }
        "6" { Add-Materia }
        "7" { List-Materias }
        "8" { Get-MateriaById }
        "9" { Update-Materia }
        "10" { Delete-Materia }
        "11" { Add-Nota }
        "12" { List-NotasPorAlumno }
        "13" { 
            Write-Host "`nHasta luego!" -ForegroundColor Green
            break 
        }
        default { Write-Host "Opcion invalida. Intenta de nuevo." -ForegroundColor Red }
    }
} while ($opcion -ne "13")
