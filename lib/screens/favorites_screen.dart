import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/bible_provider.dart';
import '../models/bible_models.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String, int) onNavigateToChapter;

  const FavoritesScreen({
    super.key,
    required this.onNavigateToChapter,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _shareVerse(FavoriteVerse verse) {
    final text = '"${verse.text}"\n\n— ${verse.bookName} ${verse.chapter}:${verse.verse} (Bíblia TEME - ARC)';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BibleProvider>(context);
    final favs = provider.favorites;
    final notes = provider.notes;
    
    final borderStyle = Border.all(color: Colors.blueGrey[800] ?? const Color(0xFF263238));

    return Column(
      children: [
        // Tab indicator header bar
        Container(
          color: const Color(0xFF101426),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF6366F1),
            labelColor: const Color(0xFF6366F1),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            tabs: [
              Tab(text: 'Marcadores (${favs.length})'),
              Tab(text: 'Notas Pessoais (${notes.length})'),
            ],
          ),
        ),

        // Tabs View Body
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 1. Favorites Bookmarks List View
              favs.isEmpty
                  ? _buildEmptyState(Icons.bookmark_added_outlined, 'Nenhum marcador salvo', 'Toque no ícone de salvar em qualquer versículo enquanto lê para destacá-lo!')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: favs.length,
                      itemBuilder: (context, index) {
                        final fav = favs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121630),
                            borderRadius: BorderRadius.circular(16),
                            border: borderStyle,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${fav.bookName} ${fav.chapter}:${fav.verse}',
                                          style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const Text(
                                          'Almeida Revista e Corrigida',
                                          style: TextStyle(color: Colors.grey, fontSize: 9, fontFamily: 'monospace'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward, size: 22, color: Colors.blueAccent),
                                        onPressed: () => widget.onNavigateToChapter(fav.bookId, fav.chapter),
                                        tooltip: 'Ler na Bíblia',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.share, size: 20, color: Colors.grey),
                                        onPressed: () => _shareVerse(fav),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 22, color: Colors.redAccent),
                                        onPressed: () => provider.removeFavorite(fav.bookId, fav.chapter, fav.verse),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white10),
                              const SizedBox(height: 6),
                              Text(
                                '"${fav.text}"',
                                style: GoogleFonts.merriweather(
                                  color: Colors.blueGrey[200] ?? Colors.grey,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

              // 2. Handwritten Notes List View
              notes.isEmpty
                  ? _buildEmptyState(Icons.edit_note_outlined, 'Nenhuma anotação pessoal', 'Toque no lápis de qualquer versículo na Bíblia para guardar reflexões e estudos!')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121630),
                            borderRadius: BorderRadius.circular(16),
                            border: borderStyle,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${note.bookName} ${note.chapter}:${note.verse}',
                                          style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        Text('Nota guardada em ${note.createdAt}', style: const TextStyle(color: Colors.grey, fontSize: 9)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.book, size: 22, color: Colors.blueAccent),
                                        onPressed: () => widget.onNavigateToChapter(note.bookId, note.chapter),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 22, color: Colors.redAccent),
                                        onPressed: () => provider.removeNote(note.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"${note.verseText}"',
                                style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 11),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0B0E20),
                                  border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  note.noteText,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String description) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF121630),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}