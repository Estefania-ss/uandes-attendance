# UANDES Attendance Backend

Backend Ruby on Rails para la gestión de eventos masivos de Admisión Universidad de los Andes.

## Descripción
Este sistema permite organizar, gestionar y optimizar eventos de admisión, como Ensayos PAES y jornadas "La Zapatilla". Incluye:
- Gestión de postulantes, eventos, asistencia y salas.
- Autenticación y roles (admisión, embajador).
- Endpoints RESTful para integración con frontend o apps móviles.

## Requisitos
- Ruby 3.x
- Rails 7.x u 8.x
- PostgreSQL
- Bundler

## Instalación
1. Clona el repositorio y entra a la carpeta backend:
   ```sh
   git clone <repo_url>
   cd uandes-attendance/backend
   ```
2. Instala las dependencias:
   ```sh
   bundle install
   ```
3. Configura la base de datos (ajusta `config/database.yml` si es necesario):
   ```sh
   rails db:create
   rails db:migrate
   ```

## Uso básico
- Inicia el servidor Rails:
  ```sh
  rails server
  ```
- Accede a la API en: `http://localhost:3000`

## Modelos principales
- **User**: Usuarios del sistema (admisión, embajador)
- **Event**: Eventos organizados
- **Applicant**: Postulantes inscritos
- **Attendance**: Registro de asistencia de postulantes a eventos
- **Room**: Salas disponibles para eventos
- **RoomAssignment**: Asignación de postulantes a salas

## Endpoints principales
- `/events` CRUD de eventos
- `/applicants` CRUD de postulantes
- `/attendances` CRUD de asistencias
- `/rooms` CRUD de salas
- `/room_assignments` CRUD de asignaciones de sala

## Autenticación
- El sistema utiliza [Devise](https://github.com/heartcombo/devise) para autenticación de usuarios.
- Los endpoints están protegidos y requieren login.


