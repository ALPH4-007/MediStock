import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Call this once at app startup, before relying on isLoggedIn.
  Future<void> loadLoginState() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await _authService.getLoginState();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    await _authService.saveLoginState(true);
    _isLoggedIn = true;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.clearSession();
    _isLoggedIn = false;

    _isLoading = false;
    notifyListeners();
  }
}
