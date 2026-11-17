import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_address_model.dart';
import '../models/user_model.dart';
import 'tracker_repository.dart';

class LocalTrackerRepository implements TrackerRepository {
  static const String _usersKey = 'ct_users_db';
  static const String _sessionKey = 'ct_current_session';
  static const String _addressPrefix = 'ct_user_address_';

  // TODO: Reemplazar por consulta real a Supabase (PostGIS / tabla de rutas)
  final List<RouteAddressModel> _mockAddresses = [
    RouteAddressModel(
      id: 'addr_1',
      street: 'Carrera 15 # 85-32',
      zone: 'Chapinero, Bogotá',
      distanceKm: '2,4 km',
      estimatedMinutes: 12,
      scheduleInfo: 'Martes, Jueves y Sábado • 8:00 PM',
    ),
    RouteAddressModel(
      id: 'addr_2',
      street: 'Carrera 15 # 85-10',
      zone: 'Chapinero, Bogotá',
      distanceKm: '2,1 km',
      estimatedMinutes: 10,
      scheduleInfo: 'Martes, Jueves y Sábado • 8:00 PM',
    ),
    RouteAddressModel(
      id: 'addr_3',
      street: 'Carrera 15 # 85-90',
      zone: 'Chapinero, Bogotá',
      distanceKm: '2,8 km',
      estimatedMinutes: 15,
      scheduleInfo: 'Martes, Jueves y Sábado • 8:15 PM',
    ),
    RouteAddressModel(
      id: 'addr_4',
      street: 'Carrera 15 # 85-120',
      zone: 'Chapinero, Bogotá',
      distanceKm: '3,1 km',
      estimatedMinutes: 18,
      scheduleInfo: 'Martes, Jueves y Sábado • 8:20 PM',
    ),
    RouteAddressModel(
      id: 'addr_5',
      street: 'Calle 72 # 10-34',
      zone: 'Quinta Camacho, Bogotá',
      distanceKm: '1,5 km',
      estimatedMinutes: 8,
      scheduleInfo: 'Lunes, Miércoles y Viernes • 7:30 PM',
    ),
    RouteAddressModel(
      id: 'addr_6',
      street: 'Avenida Suba # 115-20',
      zone: 'Suba, Bogotá',
      distanceKm: '4,2 km',
      estimatedMinutes: 22,
      scheduleInfo: 'Lunes, Miércoles y Viernes • 9:00 PM',
    ),
  ];

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    final Map<String, dynamic> users = raw != null ? json.decode(raw) : {};

    final normalized = email.trim().toLowerCase();
    if (users.containsKey(normalized)) {
      throw Exception('Este correo ya está registrado');
    }

    final userMap = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name.trim(),
      'email': normalized,
      'password': password,
    };

    users[normalized] = userMap;
    await prefs.setString(_usersKey, json.encode(users));

    final user = UserModel.fromMap(userMap);
    await prefs.setString(_sessionKey, user.toJson());
    return user;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    final Map<String, dynamic> users = raw != null ? json.decode(raw) : {};

    final normalized = email.trim().toLowerCase();
    if (!users.containsKey(normalized) || users[normalized]['password'] != password) {
      throw Exception('Correo o contraseña incorrectos');
    }

    final user = UserModel.fromMap(users[normalized]);
    await prefs.setString(_sessionKey, user.toJson());
    return user;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_sessionKey);
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  @override
  Future<List<RouteAddressModel>> searchAddresses(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _mockAddresses.take(4).toList();

    final matches = _mockAddresses.where((a) =>
        a.street.toLowerCase().contains(q) || a.zone.toLowerCase().contains(q)).toList();

    if (matches.isEmpty) {
      return [
        RouteAddressModel(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          street: query.trim(),
          zone: 'Bogotá, Colombia',
          distanceKm: '2,4 km',
          estimatedMinutes: 12,
          scheduleInfo: 'Martes, Jueves y Sábado • 8:00 PM',
        )
      ];
    }
    return matches;
  }

  @override
  Future<void> saveUserAddress(String userId, RouteAddressModel address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_addressPrefix$userId', address.toJson());
  }

  @override
  Future<RouteAddressModel?> getUserAddress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_addressPrefix$userId');
    if (data == null) return null;
    return RouteAddressModel.fromJson(data);
  }
}
