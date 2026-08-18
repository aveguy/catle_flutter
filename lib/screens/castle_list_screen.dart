import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/castle.dart';

class CastleListScreen extends StatefulWidget {
  final String typeKey;
  final String title;
  final List<Castle> castles;
  final Set<String> visitedIds;
  final void Function(String castleId, bool visited) onToggle;

  const CastleListScreen({
    super.key,
    required this.typeKey,
    required this.title,
    required this.castles,
    required this.visitedIds,
    required this.onToggle,
  });

  @override
  State<CastleListScreen> createState() => _CastleListScreenState();
}

class _CastleListScreenState extends State<CastleListScreen> {
  String selectedPref = 'すべて';

  static const prefOrder = [
    '北海道', '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県',
    '茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県',
    '新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県',
    '岐阜県', '静岡県', '愛知県', '三重県',
    '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県',
    '鳥取県', '島根県', '岡山県', '広島県', '山口県',
    '徳島県', '香川県', '愛媛県', '高知県',
    '福岡県', '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県', '鹿児島県',
    '沖縄県',
  ];

  Future<void> _openInGoogleMaps(Castle c) async {
    if (c.lat == null || c.lon == null) return;
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${c.lat},${c.lon}',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final sub = widget.castles.where((c) => c.type == widget.typeKey).toList();
    final existingPrefs = sub.map((c) => c.prefecture).toSet();
    final prefOptions = ['すべて', ...prefOrder.where(existingPrefs.contains)];

    final visitedCount = sub.where((c) => widget.visitedIds.contains(c.id)).length;
    final rate = sub.isNotEmpty ? visitedCount / sub.length : 0.0;

    final filtered = selectedPref == 'すべて'
        ? sub
        : sub.where((c) => c.prefecture == selectedPref).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$visitedCount / ${sub.length}（${(rate * 100).toStringAsFixed(1)}%）',
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: rate,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedPref,
                  isExpanded: true,
                  items: prefOptions
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => selectedPref = v);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final c = filtered[index];
                final checked = widget.visitedIds.contains(c.id);
                return CheckboxListTile(
                  value: checked,
                  title: Text(c.name),
                  subtitle: Text(c.prefecture),
                  secondary: (c.lat != null && c.lon != null)
                      ? IconButton(
                          icon: const Icon(Icons.map_outlined),
                          onPressed: () => _openInGoogleMaps(c),
                        )
                      : null,
                  onChanged: (v) {
                    widget.onToggle(c.id, v ?? false);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
