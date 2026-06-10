import 'api_config.dart';
import 'api_service.dart';
import 'html_parser.dart';
import 'mahasiswa_service.dart';
import 'session_manager.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _api = ApiService.instance;
  final _session = SessionManager.instance;

  Future<void> login(String username, String password) async {
    await _api.init();
    await _api.refreshCsrf();

    final response = await _api.post(
      ApiConfig.loginPath,
      data: {
        'email': username,
        'username': username,
        'nim': username,
        'password': password,
        'remember': 'on',
      },
    );

    if (_api.isRedirectToDosen(response)) {
      await _api.clearSession();
      throw const AuthException(
        'Akun dosen tidak dapat digunakan di aplikasi mahasiswa.',
      );
    }

    final isLoginSuccess = _api.isRedirectToMahasiswa(response) ||
        response.statusCode == 302 ||
        (response.statusCode == 200 &&
            !(response.data?.toString() ?? '').contains('These credentials'));

    if (!isLoginSuccess) {
      throw const AuthException('Username atau password salah. Coba lagi.');
    }

    await MahasiswaService.instance.loadSessionData(
      nimFallback: username,
    );
    _session.isLoggedIn = true;
  }

  Future<void> logout() async {
    try {
      await _api.refreshCsrf(path: ApiConfig.mahasiswaDashboard);
      await _api.post(ApiConfig.logoutPath);
    } catch (_) {
      // Ignore logout errors, still clear local session.
    } finally {
      await _api.clearSession();
      _session.clear();
    }
  }

  Future<bool> tryRestoreSession() async {
    try {
      await _api.init();
      final response = await _api.get(ApiConfig.mahasiswaDashboard);
      final html = response.data?.toString() ?? '';

      if (response.statusCode == 302) {
        final location = response.headers.value('location') ?? '';
        if (location.contains('login')) return false;
      }

      if (!_api.isSuccessfulGet(response)) return false;
      if (html.contains('login') && html.contains('password')) return false;

      final user = HtmlParser.parseUserFromHtml(html);
      _session.setUser(user);
      _session.isLoggedIn = true;
      await MahasiswaService.instance.loadMatakuliah();
      return true;
    } catch (_) {
      return false;
    }
  }
}
