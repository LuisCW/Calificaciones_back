import json
import os
import sys
from datetime import date
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

BASE_URL = os.getenv("BASE_URL", "http://localhost:8081/api")


def _request(method: str, path: str, payload: dict | None = None):
    url = f"{BASE_URL}{path}"
    data = None
    headers = {"Content-Type": "application/json"}

    if payload is not None:
        data = json.dumps(payload).encode("utf-8")

    req = Request(url, data=data, headers=headers, method=method)
    try:
        with urlopen(req, timeout=10) as resp:
            charset = resp.headers.get_content_charset() or "utf-8"
            body = resp.read().decode(charset, errors="replace")
            return json.loads(body) if body else None
    except HTTPError as exc:
        charset = exc.headers.get_content_charset() if exc.headers else "utf-8"
        detail = exc.read().decode(charset, errors="replace")
        raise RuntimeError(detail or f"HTTP {exc.code}") from exc
    except URLError as exc:
        raise RuntimeError("No se pudo conectar al backend") from exc


def show_menu():
    print("\n=== MENU DE GESTION ===")
    print("Alumno")
    print("1. Crear alumno")
    print("2. Listar alumnos")
    print("3. Consultar alumno por id")
    print("4. Actualizar alumno")
    print("5. Eliminar alumno")
    print("")
    print("Materia")
    print("6. Crear materia")
    print("7. Listar materias")
    print("8. Consultar materia por id")
    print("9. Actualizar materia")
    print("10. Eliminar materia")
    print("")
    print("Nota")
    print("11. Registrar/Actualizar nota")
    print("12. Listar notas por alumno")
    print("13. Salir")


def get_alumnos():
    return _request("GET", "/alumnos") or []


def get_materias():
    return _request("GET", "/materias") or []


def add_alumno():
    print("\n--- AGREGAR ALUMNO ---")
    nombre = input("Nombre: ").strip()
    apellido = input("Apellido: ").strip()
    email = input("Email: ").strip()
    fecha = input("Fecha de nacimiento (YYYY-MM-DD): ").strip()

    payload = {
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "fechaNacimiento": fecha,
    }

    resp = _request("POST", "/alumnos", payload)
    print(f"SUCCESS: Alumno agregado con ID: {resp.get('id')}")


def list_alumnos():
    print("\n--- LISTA DE ALUMNOS ---")
    alumnos = get_alumnos()
    if not alumnos:
        print("No hay alumnos registrados.")
        return
    for alumno in alumnos:
        print(f"\nID: {alumno.get('id')}")
        print(f"  Nombre: {alumno.get('nombre')} {alumno.get('apellido')}")
        print(f"  Email: {alumno.get('email')}")
        print(f"  Fecha de nacimiento: {alumno.get('fechaNacimiento')}")


def get_alumno_by_id():
    print("\n--- CONSULTAR ALUMNO POR ID ---")
    alumno_id = input("ID del alumno: ").strip()
    alumno = _request("GET", f"/alumnos/{alumno_id}")
    print(f"\nID: {alumno.get('id')}")
    print(f"  Nombre: {alumno.get('nombre')} {alumno.get('apellido')}")
    print(f"  Email: {alumno.get('email')}")
    print(f"  Fecha de nacimiento: {alumno.get('fechaNacimiento')}")


def update_alumno():
    print("\n--- ACTUALIZAR ALUMNO ---")
    alumno_id = input("ID del alumno: ").strip()
    nombre = input("Nombre: ").strip()
    apellido = input("Apellido: ").strip()
    email = input("Email: ").strip()
    fecha = input("Fecha de nacimiento (YYYY-MM-DD): ").strip()

    payload = {
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "fechaNacimiento": fecha,
    }

    _request("PUT", f"/alumnos/{alumno_id}", payload)
    print("SUCCESS: Alumno actualizado")


def delete_alumno():
    print("\n--- ELIMINAR ALUMNO ---")
    alumno_id = input("ID del alumno: ").strip()
    _request("DELETE", f"/alumnos/{alumno_id}")
    print("SUCCESS: Alumno eliminado")


def add_materia():
    print("\n--- AGREGAR MATERIA ---")
    nombre = input("Nombre: ").strip()
    codigo = input("Codigo: ").strip()
    creditos = input("Creditos: ").strip()

    payload = {
        "nombre": nombre,
        "codigo": codigo,
        "creditos": int(creditos),
    }

    resp = _request("POST", "/materias", payload)
    print(f"SUCCESS: Materia agregada con ID: {resp.get('id')}")


def list_materias():
    print("\n--- LISTA DE MATERIAS ---")
    materias = get_materias()
    if not materias:
        print("No hay materias registradas.")
        return
    for materia in materias:
        print(f"\nID: {materia.get('id')}")
        print(f"  Nombre: {materia.get('nombre')}")
        print(f"  Codigo: {materia.get('codigo')}")
        print(f"  Creditos: {materia.get('creditos')}")


def get_materia_by_id():
    print("\n--- CONSULTAR MATERIA POR ID ---")
    materia_id = input("ID de la materia: ").strip()
    materia = _request("GET", f"/materias/{materia_id}")
    print(f"\nID: {materia.get('id')}")
    print(f"  Nombre: {materia.get('nombre')}")
    print(f"  Codigo: {materia.get('codigo')}")
    print(f"  Creditos: {materia.get('creditos')}")


def update_materia():
    print("\n--- ACTUALIZAR MATERIA ---")
    materia_id = input("ID de la materia: ").strip()
    nombre = input("Nombre: ").strip()
    codigo = input("Codigo: ").strip()
    creditos = input("Creditos: ").strip()

    payload = {
        "nombre": nombre,
        "codigo": codigo,
        "creditos": int(creditos),
    }

    _request("PUT", f"/materias/{materia_id}", payload)
    print("SUCCESS: Materia actualizada")


def delete_materia():
    print("\n--- ELIMINAR MATERIA ---")
    materia_id = input("ID de la materia: ").strip()
    _request("DELETE", f"/materias/{materia_id}")
    print("SUCCESS: Materia eliminada")


def add_nota():
    print("\n--- REGISTRAR/ACTUALIZAR NOTA ---")
    alumnos = get_alumnos()
    if not alumnos:
        print("No hay alumnos registrados. Agrega un alumno primero.")
        return

    print("\nAlumnos disponibles:")
    for alumno in alumnos:
        print(f"  ID: {alumno.get('id')} - {alumno.get('nombre')} {alumno.get('apellido')}")
    alumno_id = input("\nID del alumno: ").strip()

    materias = get_materias()
    if not materias:
        print("No hay materias registradas. Agrega una materia primero.")
        return

    print("\nMaterias disponibles:")
    for materia in materias:
        print(f"  ID: {materia.get('id')} - {materia.get('nombre')} ({materia.get('codigo')})")
    materia_id = input("\nID de la materia: ").strip()
    valor = input("Calificacion (0.0 - 5.0): ").strip()

    payload = {
        "alumnoId": int(alumno_id),
        "materiaId": int(materia_id),
        "valor": float(valor),
        "fechaRegistro": date.today().isoformat(),
    }

    resp = _request("POST", "/notas", payload)
    print(f"SUCCESS: Nota registrada/actualizada con ID: {resp.get('id')}")


def list_notas_por_alumno():
    print("\n--- NOTAS POR ALUMNO ---")
    alumnos = get_alumnos()
    if not alumnos:
        print("No hay alumnos registrados.")
        return

    print("\nAlumnos disponibles:")
    for alumno in alumnos:
        print(f"  ID: {alumno.get('id')} - {alumno.get('nombre')} {alumno.get('apellido')}")
    alumno_id = input("\nID del alumno: ").strip()

    notas = _request("GET", f"/notas/alumno/{alumno_id}") or []
    if not notas:
        print("Este alumno no tiene notas registradas.")
        return

    print("\nNotas del alumno:")
    for nota in notas:
        print(f"\n  Materia: {nota.get('materiaNombre')}")
        print(f"  Calificacion: {nota.get('valor')}")
        print(f"  Fecha: {nota.get('fechaRegistro')}")


def main():
    actions = {
        "1": add_alumno,
        "2": list_alumnos,
        "3": get_alumno_by_id,
        "4": update_alumno,
        "5": delete_alumno,
        "6": add_materia,
        "7": list_materias,
        "8": get_materia_by_id,
        "9": update_materia,
        "10": delete_materia,
        "11": add_nota,
        "12": list_notas_por_alumno,
    }

    while True:
        show_menu()
        option = input("Selecciona una opcion (1-13): ").strip()
        if option == "13":
            print("\nHasta luego!")
            break
        action = actions.get(option)
        if not action:
            print("Opcion invalida. Intenta de nuevo.")
            continue
        try:
            action()
        except Exception as exc:
            print(f"ERROR: {exc}")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
