class UserSession {
  final String nama;
  final String nim;
  final String? prodi;
  final String? email;
  final double? kehadiranPersen;
  final int? totalHadir;
  final int? totalIzin;
  final int? totalAlpha;
  final int? totalSks;

  const UserSession({
    required this.nama,
    required this.nim,
    this.prodi,
    this.email,
    this.kehadiranPersen,
    this.totalHadir,
    this.totalIzin,
    this.totalAlpha,
    this.totalSks,
  });

  String get initials {
    final parts = nama.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get displaySubtitle {
    final prodiText = prodi != null && prodi!.isNotEmpty ? ' · $prodi' : '';
    return 'NIM: $nim$prodiText';
  }

  UserSession copyWith({
    String? nama,
    String? nim,
    String? prodi,
    String? email,
    double? kehadiranPersen,
    int? totalHadir,
    int? totalIzin,
    int? totalAlpha,
    int? totalSks,
  }) {
    return UserSession(
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      email: email ?? this.email,
      kehadiranPersen: kehadiranPersen ?? this.kehadiranPersen,
      totalHadir: totalHadir ?? this.totalHadir,
      totalIzin: totalIzin ?? this.totalIzin,
      totalAlpha: totalAlpha ?? this.totalAlpha,
      totalSks: totalSks ?? this.totalSks,
    );
  }
}
