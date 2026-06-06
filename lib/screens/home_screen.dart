
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/bible_provider.dart';
import '../bible_data.dart';
import '../models/bible_models.dart';

class HomeScreen extends StatefulWidget {
  final Function(String, int) onNavigateToChapter;
  final Function(int) onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToChapter, required this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Verse? _currentVerse; // Variável direta em vez de Future
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialVerse();
  }

  // Carrega o primeiro versículo
  Future<void> _loadInitialVerse() async {
    final v = await BibleData.getRandomVerse();
    if (mounted) setState(() => _currentVerse = v);
  }

  // FUNÇÃO DE REFRESH CORRIGIDA: Sem piscar e sem erro de Future
  Future<void> _refreshVerse() async {
    setState(() => _isLoading = true); // Mostra o spinner apenas no ícone
    final newVerse = await BibleData.getRandomVerse();
    if (mounted) {
      setState(() {
        _currentVerse = newVerse;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BibleProvider>(context);
    final history = provider.history;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Graça e Paz! 👋', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('Seja bem-vindo de volta à palavra de Deus.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),

          // Card do Versículo do Dia (Sem FutureBuilder para evitar flicker)
          if (_currentVerse == null)
            const Center(child: CircularProgressIndicator())
          else
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E1E38), Color(0xFF14142B)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD97706).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.star, color: Color(0xFFD97706), size: 18),
                    const SizedBox(width: 8),
                    Text('VERSÍCULO DO DIA', style: GoogleFonts.inter(color: const Color(0xFFD97706), fontWeight: FontWeight.w800, fontSize: 11)),
                    const Spacer(),
                    // Ícone de refresh com feedback de carregamento
                    _isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber))
                      : IconButton(icon: const Icon(Icons.refresh, size: 16, color: Colors.grey), onPressed: _refreshVerse),
                  ]),
                  const SizedBox(height: 8),
                  Text('"${_currentVerse!.text}"', style: GoogleFonts.merriweather(color: Colors.blueGrey[100], fontSize: 14, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('— ${_currentVerse!.bookName} ${_currentVerse!.chapter}:${_currentVerse!.verse} (AA)', style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold, fontSize: 11)),
                      ElevatedButton.icon(
                        onPressed: () => widget.onNavigateToChapter(_currentVerse!.bookId, _currentVerse!.chapter),
                        icon: const Icon(Icons.menu_book, size: 14, color: Colors.white),
                        label: const Text('Ler Capítulo', style: TextStyle(fontSize: 11, color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      )
                    ],
                  )
                ],
              ),
            ),
          
          const SizedBox(height: 24),
          const Text('Seções Principais', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: 2.2, crossAxisSpacing: 10, mainAxisSpacing: 10,
            children: [
              _shortcut('Mateus 6', 'Sermão do Monte', Colors.redAccent, () => widget.onNavigateToChapter('mt', 6)),
              _shortcut('Provérbios 9', 'Sabedoria', Colors.green, () => widget.onNavigateToChapter('pv', 9)),
              _shortcut('Salmos 23', 'Bom Pastor', Colors.amber, () => widget.onNavigateToChapter('sl', 23)),
              _shortcut('João 1', 'Verbo Divino', Colors.indigoAccent, () => widget.onNavigateToChapter('joao', 1)), // ID CORRIGIDO
            ],
          ),
          const SizedBox(height: 24),
          const Text('Histórico de Leitura Recente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey)),
          const SizedBox(height: 10),
          if (history.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Nenhum capítulo lido recentemente.', style: TextStyle(color: Colors.grey, fontSize: 12))))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length > 3 ? 3 : history.length,
              itemBuilder: (context, index) {
                final h = history[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: const Color(0xFF121630), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Color(0xFF6366F1)),
                    title: Text('${h.bookName} Capítulo ${h.chapter}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('Lido em ${h.readAt}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    trailing: const Icon(Icons.arrow_forward, color: Color(0xFF818CF8)),
                    onTap: () => widget.onNavigateToChapter(h.bookId, h.chapter),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _shortcut(String t, String s, Color c, VoidCallback o) {
    return InkWell(
      onTap: o, borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF121630), border: Border.all(color: Colors.white10), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(width: 4, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)), Text(s, style: const TextStyle(color: Colors.grey, fontSize: 9), overflow: TextOverflow.ellipsis)]))
        ]),
      ),
    );
  }
}