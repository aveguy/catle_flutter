import 'package:flutter/material.dart';
import 'models/castle.dart';
import 'services/castle_repository.dart';
import 'services/visited_store.dart';
import 'screens/home_screen.dart';
import 'screens/castle_list_screen.dart';

void main() {
  runApp(const CastleApp());
}

class CastleApp extends StatelessWidget {
  const CastleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '100名城・続100名城 登城記録',
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  List<Castle> _castles = [];
  Set<String> _visitedIds = {};
  bool _loading = true;

  final _repository = CastleRepository();
  final _visitedStore = VisitedStore();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final castles = await _repository.loadCastles();
    final visited = await _visitedStore.load();
    setState(() {
      _castles = castles;
      _visitedIds = visited;
      _loading = false;
    });
  }

  void _onToggle(String castleId, bool visited) {
    setState(() {
      if (visited) {
        _visitedIds.add(castleId);
      } else {
        _visitedIds.remove(castleId);
      }
    });
    _visitedStore.save(_visitedIds);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screens = [
      HomeScreen(castles: _castles, visitedIds: _visitedIds),
      CastleListScreen(
        typeKey: '100',
        title: '100名城',
        castles: _castles,
        visitedIds: _visitedIds,
        onToggle: _onToggle,
      ),
      CastleListScreen(
        typeKey: '続100',
        title: '続100名城',
        castles: _castles,
        visitedIds: _visitedIds,
        onToggle: _onToggle,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.castle), label: '100名城'),
          NavigationDestination(icon: Icon(Icons.castle_outlined), label: '続100名城'),
        ],
      ),
    );
  }
}
