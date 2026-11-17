import '../models/route_address_model.dart';
import '../models/user_model.dart';

/// CONTRATO ABSTRACTO DEL BACKEND
/// El equipo de backend solo deberá crear SupabaseTrackerRepository implementando esta interfaz.
abstract class TrackerRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();

  /// Búsqueda de direcciones / autocompletado de rutas
  Future<List<RouteAddressModel>> searchAddresses(String query);

  /// Guardar y leer la dirección asignada al usuario
  Future<void> saveUserAddress(String userId, RouteAddressModel address);
  Future<RouteAddressModel?> getUserAddress(String userId);
}
