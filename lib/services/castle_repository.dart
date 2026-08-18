import 'package:flutter/services.dart' show rootBundle;
import '../models/castle.dart';

class CastleRepository {
  Future<List<Castle>> loadCastles() async {
    final raw = await rootBundle.loadString('assets/castles.csv');
    final lines = raw.split('\n').where((l) => l.trim().isNotEmpty).toList();

    final dataLines = lines.skip(1);

    final castles = <Castle>[];
    for (final line in dataLines) {
      final cols = line.split(',');
      if (cols.length < 4) continue;

      final id = cols[0].trim();
      final name = cols[1].trim();
      final type = cols[2].trim();
      final prefecture = cols[3].trim();
      final lat = cols.length > 4 ? double.tryParse(cols[4].trim()) : null;
      final lon = cols.length > 5 ? double.tryParse(cols[5].trim()) : null;

      castles.add(Castle(
        id: id,
        name: name,
        type: type,
        prefecture: prefecture,
        lat: lat,
        lon: lon,
      ));
    }
    return castles;
  }
}
