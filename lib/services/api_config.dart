class ApiConfig {
  static const String baseUrl =
      'https://outsider-remarry-janitor.ngrok-free.dev';

  static const Map<String, String> defaultHeaders = {
    'ngrok-skip-browser-warning': 'true',
    'Accept': 'text/html,application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  static const String loginPath = '/login';
  static const String logoutPath = '/logout';
  static const String mahasiswaDashboard = '/mahasiswa/dashboard';
  static const String mahasiswaMatakuliah = '/mahasiswa/list_matakuliah';
  static const String mahasiswaProfile = '/mahasiswa/profile';
  static const String mahasiswaScanQr = '/mahasiswa/scan_qr';
  static String mahasiswaScanToken(String token) => '/mahasiswa/scan/$token';
  static const String mahasiswaScanProcess = '/mahasiswa/scan/process';
static const String mahasiswaMatakuliahApi = '/mahasiswa/list_matakuliah/api';
  // PresensiController (jika route /absen terdaftar di web.php)
  static const String absenForm = '/absen';
  static const String absenStore = '/absen';

  static const String profileEdit = '/profile';
}
