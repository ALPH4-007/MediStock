import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = true;

  String _name = '';
  String _role = '';
  String _pharmacy = '';
  bool _notificationsEnabled = true;

  AuthProvider() {
    _init();
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String get name => _name;
  String get role => _role;
  String get pharmacy => _pharmacy;
  bool get notificationsEnabled => _notificationsEnabled;

  bool get hasProfile => _name.trim().isNotEmpty;

  void _init() {
    _authService.userStream.listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadProfile();
      } else {
        _clearUserData();
      }
      _isLoading = false;
      notifyListeners();
    });
    _loadNotificationsPreference();
  }

  void _clearUserData() {
    _name = '';
    _role = '';
    _pharmacy = '';
  }

  Future<void> _loadProfile() async {
    final profile = await _authService.getProfile();
    _name = profile['name'] ?? '';
    _role = profile['role'] ?? '';
    _pharmacy = profile['pharmacy'] ?? '';
    notifyListeners();
  }

  Future<void> _loadNotificationsPreference() async {
    _notificationsEnabled = await _authService.getNotificationsEnabled();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.login(email, password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.register(email, password);
      await _authService.saveProfile(
        name: name,
        role: 'Pharmacist',
        pharmacy: 'My Pharmacy',
      );
      await _loadProfile();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _authService.logout();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required String role,
    required String pharmacy,
  }) async {
    await _authService.saveProfile(name: name, role: role, pharmacy: pharmacy);
    _name = name;
    _role = role;
    _pharmacy = pharmacy;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _authService.saveNotificationsEnabled(value);
    _notificationsEnabled = value;
    notifyListeners();
  }
}
