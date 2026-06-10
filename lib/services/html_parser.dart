import 'package:html/parser.dart' as html_parser;

import '../models/matakuliah.dart';
import '../models/user_session.dart';

class HtmlParser {
  static String? extractCsrfToken(String html) {
    final doc = html_parser.parse(html);

    final meta = doc.querySelector('meta[name="csrf-token"]');
    if (meta != null) {
      final content = meta.attributes['content'];
      if (content != null && content.isNotEmpty) return content;
    }

    final input = doc.querySelector('input[name="_token"]');
    if (input != null) {
      final value = input.attributes['value'];
      if (value != null && value.isNotEmpty) return value;
    }

    return null;
  }

  static UserSession parseUserFromHtml(String html, {UserSession? fallback}) {
    final doc = html_parser.parse(html);
    final text = doc.body?.text ?? html;

    String nama = fallback?.nama ?? 'Mahasiswa';
    String nim = fallback?.nim ?? '-';
    String? prodi = fallback?.prodi;
    String? email;

    final nimMatch = RegExp(
      r'NIM\s*[:：]?\s*([A-Za-z0-9]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (nimMatch != null) nim = nimMatch.group(1)!.trim();

    final namaPatterns = [
      RegExp(r'Selamat\s+Datang,?\s*([^\n\r|]+)', caseSensitive: false),
      RegExp(r'Nama\s*[:：]?\s*([^\n\r|]+)', caseSensitive: false),
    ];
    for (final pattern in namaPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = match.group(1)!.trim();
        if (value.isNotEmpty && !value.toLowerCase().contains('nim')) {
          nama = value;
          break;
        }
      }
    }

    final prodiMatch = RegExp(
      r'(?:Prodi|Program Studi|Jurusan)\s*[:：]?\s*([^\n\r|]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (prodiMatch != null) prodi = prodiMatch.group(1)!.trim();

    final emailMatch = RegExp(
      r'[\w.+-]+@[\w.-]+\.\w+',
    ).firstMatch(text);
    if (emailMatch != null) email = emailMatch.group(0);

    double? kehadiranPersen;
    final persenMatch = RegExp(r'(\d{1,3})\s*%').firstMatch(text);
    if (persenMatch != null) {
      kehadiranPersen = double.tryParse(persenMatch.group(1)!);
    }

    int? parseCount(String label) {
      final match = RegExp(
        '$label\\s*[:：]?\\s*(\\d+)',
        caseSensitive: false,
      ).firstMatch(text);
      return match != null ? int.tryParse(match.group(1)!) : null;
    }

    return UserSession(
      nama: nama,
      nim: nim,
      prodi: prodi,
      email: email,
      kehadiranPersen: kehadiranPersen ?? fallback?.kehadiranPersen,
      totalHadir: parseCount('Hadir') ?? fallback?.totalHadir,
      totalIzin: parseCount('Izin') ?? fallback?.totalIzin,
      totalAlpha: parseCount('Alpha') ?? fallback?.totalAlpha,
      totalSks: parseCount('SKS') ?? fallback?.totalSks,
    );
  }

  static List<Matakuliah> parseMatakuliahList(String html) {
    final doc = html_parser.parse(html);
    final tables = doc.querySelectorAll('table');
    final results = <Matakuliah>[];

    for (final table in tables) {
      final rows = table.querySelectorAll('tr');
      for (final row in rows.skip(1)) {
        final cells = row.querySelectorAll('td, th');
        if (cells.length < 3) continue;

        final values = cells.map((c) => c.text.trim()).toList();
        if (values.every((v) => v.isEmpty)) continue;

        final kode = _cell(values, 0);
        final nama = _cell(values, 1);
        if (nama.isEmpty) continue;

        results.add(
          Matakuliah(
            kode: kode.isNotEmpty ? kode : 'MK${results.length + 1}',
            nama: nama,
            kelas: _findValue(values, ['kelas']) ?? _cell(values, 2),
            sks: int.tryParse(_findValue(values, ['sks']) ?? _cell(values, 3)) ?? 3,
            dosen: _findValue(values, ['dosen']) ?? _cell(values, 4),
            hari: _findValue(values, ['hari']) ?? _cell(values, 5),
            jam: _findValue(values, ['jam', 'waktu']) ?? _cell(values, 6),
            ruang: _findValue(values, ['ruang', 'room']) ?? _cell(values, 7),
            hadir: int.tryParse(_findValue(values, ['hadir']) ?? '') ?? 0,
            izin: int.tryParse(_findValue(values, ['izin']) ?? '') ?? 0,
            alpha: int.tryParse(_findValue(values, ['alpha', 'alfa']) ?? '') ?? 0,
            total: int.tryParse(_findValue(values, ['total']) ?? '') ?? 0,
          ),
        );
      }
    }

    if (results.isNotEmpty) return results;

    // Fallback: card/list layout
    final cards = doc.querySelectorAll('[class*="matakuliah"], [class*="mk-card"], .card');
    for (final card in cards) {
      final text = card.text.trim();
      if (text.length < 5) continue;
      final kodeMatch = RegExp(r'\b[A-Z]{2,}\d{2,}\b').firstMatch(text);
      results.add(
        Matakuliah(
          kode: kodeMatch?.group(0) ?? 'MK${results.length + 1}',
          nama: text.split('\n').first.trim(),
          kelas: '-',
          sks: 3,
          dosen: '-',
          hari: '-',
          jam: '-',
          ruang: '-',
        ),
      );
    }

    return results;
  }

  static String _cell(List<String> values, int index) {
    if (index >= values.length) return '';
    return values[index].trim();
  }

  static String? _findValue(List<String> values, List<String> keywords) {
    for (final value in values) {
      final lower = value.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword)) {
          final parts = value.split(':');
          if (parts.length > 1) return parts.sublist(1).join(':').trim();
        }
      }
    }
    return null;
  }
}
