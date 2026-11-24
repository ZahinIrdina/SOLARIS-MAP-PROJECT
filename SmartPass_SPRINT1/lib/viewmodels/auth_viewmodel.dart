import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';
import '../utils/auth_errors.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // --- REGISTER LOGIC ---
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String universityId,
    required String phone,
    required String selectedRole, // Passed from RoleSelectionPage
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // The service checks the ID against the students / lecturers tables.
      await _authService.registerUser(
        email: email,
        password: password,
        fullName: fullName,
        universityId: universityId,
        phone: phone,
        role: selectedRole,
      );

      // Sign out so user is cleanly logged out until they log in on the login screen
      await _authService.logout();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(friendlyAuthError(e));
      _setLoading(false);
      return false;
    }
  }

  // --- LOGIN LOGIC ---
  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _setError('Please enter your email and password.');
      return false;
    }
    _setLoading(true);
    _setError(null);
    try {
      await _authService.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(friendlyAuthError(e));
      _setLoading(false);
      return false;
    }
  }

  // --- LOGOUT LOGIC ---
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }


  // --- GET USER PROFILE (used by the invigilator dashboard's ProfilePage) ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    _setLoading(true);
    _setError(null);
    try {
      final profile = await _authService.getUserProfile();
      _setLoading(false);
      return profile;
    } catch (e) {
      _setError(friendlyAuthError(e));
      _setLoading(false);
      return null;
    }
  }

  // --- UPDATE USER PROFILE (used by the invigilator dashboard's EditProfilePage) ---
  Future<bool> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.updateUserProfile(fullName: fullName, phone: phone);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(friendlyAuthError(e));
      _setLoading(false);
      return false;
    }
  }

  // --- PASSWORD RESET LOGIC ---
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(friendlyAuthError(e));
      _setLoading(false);
      return false;
    }
  }
}
