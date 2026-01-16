# Calificaciones - Instrucciones

Repositorio: https://github.com/LuisCW/Calificaciones_back

Estos comandos no solo permiten ejecutar correctamente el back-end y el db sino también interactuar con este antes de comprobarlo en el front-end

## Requisitos
- Docker Desktop

## Datos de prueba (.dump)
- Archivo incluido: [db-dumps/grades.dump](db-dumps/grades.dump)

**Restaurar dump:**
1) `git clone https://github.com/LuisCW/Calificaciones_back`
2) `cd Calificaciones_back`
3) `docker cp db-dumps/grades.dump calificaciones-postgres:/tmp/grades.dump`
4) `docker exec -e PGPASSWORD=Abcdefghij123 -t calificaciones-postgres pg_restore -U postgres -d grades -c /tmp/grades.dump`

---

## Opción 1: Docker Hub (sin descargar código)
Usa [docker-compose.hub.yml](docker-compose.hub.yml) 

**Comandos:**
1) `curl -o docker-compose.hub.yml https://raw.githubusercontent.com/LuisCW/Calificaciones_back/main/docker-compose.hub.yml`
2) `docker compose -f docker-compose.hub.yml up -d`
3) `docker exec -it calificaciones-backend python3 /app/cli_menu.py`

**Resultado:**
- API: http://localhost:8081/api

---

## Opción 2: Desde GitHub (repo completo)
**Comandos:**
1) `git clone https://github.com/LuisCW/Calificaciones_back`
2) `cd Calificaciones_back`
3) `docker compose up -d --build`
4) `docker exec -it calificaciones-backend python3 /app/cli_menu.py`

**Resultado:**
- API: http://localhost:8081/api

---

## Opción 3: Localhost (sin Docker para backend)
**Comandos:**
1) `git clone https://github.com/LuisCW/Calificaciones_back`
2) `cd Calificaciones_back`
3) `docker compose up -d postgres`
4) `mvn spring-boot:run`
5) `./run` (menú en Windows)

**Resultado:**
- API: http://localhost:8081/api

---

## Detener
`docker compose down`

Si al momento de iniciar hay error al cargar el backend revisar en logs en docker desktop ha que termine de iniciar el servidor backend (tarda de 10-20 segundos)
