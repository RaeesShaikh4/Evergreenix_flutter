import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rememberMeKey = 'remember_me';

  static SessionManager? _instance;
  static SessionManager get instance {
    _instance ??= SessionManager._();
    return _instance!;
  }

  SessionManager._();

  // In-memory fallback storage
  static final Map<String, dynamic> _memoryStorage = {};

  // Save authentication token
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      // Fallback to in-memory storage
      _memoryStorage[_tokenKey] = token;
      _memoryStorage[_isLoggedInKey] = true;
      print('Warning: Using in-memory storage for session: $e');
    }
  }

  // Get authentication token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      // Fallback to in-memory storage
      return _memoryStorage[_tokenKey] as String?;
    }
  }

  // Save user email
  Future<void> saveUserEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
    } catch (e) {
      _memoryStorage[_userEmailKey] = email;
      print('Warning: Using in-memory storage for user email: $e');
    }
  }

  // Get user email
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      return _memoryStorage[_userEmailKey] as String?;
    }
  }

  // Save remember me preference
  Future<void> saveRememberMe(bool rememberMe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, rememberMe);
    } catch (e) {
      _memoryStorage[_rememberMeKey] = rememberMe;
      print('Warning: Using in-memory storage for remember me: $e');
    }
  }

  // Get remember me preference
  Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      return _memoryStorage[_rememberMeKey] as bool? ?? false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return _memoryStorage[_isLoggedInKey] as bool? ?? false;
    }
  }

  // Clear all session data (logout)
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userEmailKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      // Clear in-memory storage
      _memoryStorage.remove(_tokenKey);
      _memoryStorage.remove(_userEmailKey);
      _memoryStorage[_isLoggedInKey] = false;
      print('Warning: Using in-memory storage for clear session: $e');
    }
    // Note: We don't clear remember_me preference to maintain user choice
  }

  // Complete logout (including remember me)
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_rememberMeKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      // Clear in-memory storage
      _memoryStorage.remove(_tokenKey);
      _memoryStorage.remove(_userEmailKey);
      _memoryStorage.remove(_rememberMeKey);
      _memoryStorage[_isLoggedInKey] = false;
      print('Warning: Using in-memory storage for logout: $e');
    }
  }

  // Get all session data
  Future<Map<String, dynamic>> getSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'token': prefs.getString(_tokenKey),
        'email': prefs.getString(_userEmailKey),
        'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
        'rememberMe': prefs.getBool(_rememberMeKey) ?? false,
      };
    } catch (e) {
      // Return in-memory storage data
      return {
        'token': _memoryStorage[_tokenKey],
        'email': _memoryStorage[_userEmailKey],
        'isLoggedIn': _memoryStorage[_isLoggedInKey] ?? false,
        'rememberMe': _memoryStorage[_rememberMeKey] ?? false,
      };
    }
  }
}
