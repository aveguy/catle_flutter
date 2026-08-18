import 'package:shared_preferences/shared_preferences.dart';

class VisitedStore {
  static const _key = 'visited_ids';

  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  Future<void> save(Set<String> visitedIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, visitedIds.toList());
  }
}
