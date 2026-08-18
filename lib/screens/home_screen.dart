import 'package:flutter/material.dart';
import '../models/castle.dart';

class HomeScreen extends StatelessWidget {
  final List<Castle> castles;
  final Set<String> visitedIds;

  const HomeScreen({
    super.key,
    required this.castles,
    required this.visitedIds,
  });

  @override
  Widget build(BuildContext context) {
    final castles100 = castles.where((c) => c.type == "100").toList();
    final castlesZoku100 = castles.where((c) => c.type == "続100").toList();

    final visited100 = castles100.where((c) => visitedIds.contains(c.id)).length;
    final visitedZoku100 = castlesZoku100.where((c) => visitedIds.contains(c.id)).length;

    final prefMap = <String, List<Castle>>{};
    for (final c in castles) {
      prefMap.putIfAbsent(c.prefecture, () => []).add(c);
    }
    final prefRows = prefMap.entries.map((e) {
      final total = e.value.length;
      final visited = e.value.where((c) => visitedIds.contains(c.id)).length;
      return (pref: e.key, visited: visited, total: total);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('🏯 登城記録')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('進捗率', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _progressRow('100名城', visited100, castles100.length),
          const SizedBox(height: 12),
          _progressRow('続100名城', visitedZoku100, castlesZoku100.length),
          const Divider(height: 32),
          Text('都道府県別 登城率', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...prefRows.map((row) {
            final rate = row.total > 0 ? row.visited / row.total : 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 90, child: Text(row.pref)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: rate,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${row.visited}/${row.total}'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _progressRow(String label, int visited, int total) {
    final rate = total > 0 ? visited / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label：$visited / $total（${(rate * 100).toStringAsFixed(1)}%）'),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: rate,
          minHeight: 12,
          backgroundColor: Colors.grey[300],
          color: Colors.red,
        ),
      ],
    );
  }
}
