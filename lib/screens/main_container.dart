import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bible_screen.dart';
import 'assistant_screen.dart';
import 'favorites_screen.dart';
import 'support_screen.dart';
import 'settings_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  
  // Controle direto para navegar para capítulos específicos
  String? _navBookId;
  int? _navChapter;

  void navigateToBibleChapter(String bookId, int chapter) {
    setState(() {
      _navBookId = bookId;
      _navChapter = chapter;
      _currentIndex = 1; // Index da aba Bíblia
    });
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      if (index != 1) {
        _navBookId = null;
        _navChapter = null;
      }
    });
  }

  // Widget auxiliar para criar as letras coloridas do TEME
  Widget _buildTemeLogo() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _colorChar('T', const Color(0xFFFACC15)), // Amarelo
          _colorChar('E', const Color(0xFFE11D48)), // Vermelho
          _colorChar('M', const Color(0xFF2563EB)), // Azul
          _colorChar('E', const Color(0xFF22C55E)), // Verde
        ],
      ),
    );
  }

  Widget _colorChar(String char, Color color) {
    return Text(
      char,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        letterSpacing: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToChapter: navigateToBibleChapter,
        onNavigateToTab: changeTab,
      ),
      BibleScreen(
        initialBookId: _navBookId,
        initialChapter: _navChapter,
      ),
      const AssistantScreen(),
      FavoritesScreen(
        onNavigateToChapter: navigateToBibleChapter,
      ),
      const SupportScreen(),
      const SettingsScreen(),
    ];

    final List<String> titles = [
      'Bíblia TEME',
      'Bíblia Sagrada',
      'TEME AI Assistant',
      'Favoritos & Notas',
      'Apoiar Projeto',
      'Configurações',
    ];

    bool isLargeScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D1D),
      appBar: AppBar(
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF101426),
        elevation: 4,
        actions: [
          // Selo AA em Verde
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Chip(
              label: const Text(
                'AA',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFF22C55E).withValues(alpha: 0.12),
              side: BorderSide(color: const Color(0xFF22C55E).withValues(alpha: 0.2)),
              visualDensity: VisualDensity.compact,
            ),
          ),
          
          // Logo TEME Colorido (Substituindo o OFFLINE)
          _buildTemeLogo(),
        ],
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: changeTab,
              backgroundColor: const Color(0xFF101426),
              unselectedIconTheme: const IconThemeData(color: Colors.blueGrey),
              selectedIconTheme: const IconThemeData(color: Color(0xFF6366F1)),
              unselectedLabelTextStyle: const TextStyle(color: Colors.blueGrey, fontSize: 11),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Início'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: Text('Bíblia'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: Text('Assistente'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_outline),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('Marcadores'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.volunteer_activism_outlined),
                  selectedIcon: Icon(Icons.volunteer_activism),
                  label: Text('Apoio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Ajustes'),
                ),
              ],
            ),
          
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: screens[_currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isLargeScreen
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: changeTab,
              backgroundColor: const Color(0xFF101426),
              selectedItemColor: const Color(0xFF6366F1),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 11,
              unselectedFontSize: 10,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book_outlined),
                  activeIcon: Icon(Icons.book),
                  label: 'Bíblia',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome_outlined),
                  activeIcon: Icon(Icons.auto_awesome),
                  label: 'TEME AI',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  activeIcon: Icon(Icons.favorite),
                  label: 'Salvos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Config',
                ),
              ],
            )
          : null,
    );
  }
}