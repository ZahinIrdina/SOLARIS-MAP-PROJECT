import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';

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

  // --- ROLE DETECTION LOGIC from nas ---
  String? detectRole(String id) {
    id = id.trim().toUpperCase();
    // Invigilator: exactly 5 digits
    if (RegExp(r'^\d{5}$').hasMatch(id)) return 'invigilator';
    // Student: A + 2 digits + 2 letters + 4 digits (e.g., A24CS5029)
    if (RegExp(r'^A\d{2}[A-Z]{2}\d{4}$').hasMatch(id)) return 'student';
    return null;
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
      // 1. Detect actual role from ID
      final detectedRole = detectRole(universityId);

      if (detectedRole == null) {
        _setError('Invalid University ID format.');
        _setLoading(false);
        return false;
      }

      // 2. Verify selected role matches detected role
      if (selectedRole.toLowerCase() != detectedRole) {
        _setError('Your selected role does not match your University ID!');
        _setLoading(false);
        return false;
      }

      // 3. Create Account via Service
      await _authService.registerUser(
        email: email,
        password: password,
        fullName: fullName,
        universityId: universityId.toUpperCase(),
        phone: phone,
        role: detectedRole,
      );

      // Sign out so user is cleanly logged out until they log in on the login screen
      await _authService.logout();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll("Exception: ", ""));
      _setLoading(false);
      return false;
    }
  }

  // --- LOGIN LOGIC ---
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll("Exception: ", ""));
      _setLoading(false);
      return false;
    }
  }

  // --- LOGOUT LOGIC ---
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }


  // --- GET USER PROFILE ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    _setLoading(true);
    _setError(null);

    try {
      final profile = await _authService.getUserProfile();
      _setLoading(false);
      return profile;
    } catch (e) {
      _setError(e.toString().replaceAll("Exception: ", ""));
      _setLoading(false);
      return null;
    }
  }

  // --- UPDATE USER PROFILE ---
  Future<bool> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.updateUserProfile(
        fullName: fullName,
        phone: phone,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll("Exception: ", ""));
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
      _setError(e.toString().replaceAll("Exception: ", ""));
      _setLoading(false);
      return false;
    }
  }
}
