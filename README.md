# CleanTracker - Frontend Flutter (Arquitectura Desacoplada para Supabase)

Implementación fiel de las pantallas de CleanTracker con paleta Menta (`#DDF7F6`), Crema (`#F6F6D5`) y Verde Bosque (`#183635`).

## Arquitectura lista para Backend (Supabase)
- **Contrato de Datos (`lib/data/repositories/tracker_repository.dart`)**: Define las operaciones exactas de autenticación, búsqueda de rutas y asignación de dirección.
- **Implementación Local (`lib/data/repositories/local_tracker_repository.dart`)**: Persiste sesión y dirección seleccionada en `SharedPreferences`.
- **Conexión con Supabase**: Crear `SupabaseTrackerRepository implements TrackerRepository` y cambiar la instancia en `lib/main.dart`. Las vistas no requieren ninguna modificación.
