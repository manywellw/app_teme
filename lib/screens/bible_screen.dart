// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/bible_provider.dart';
import '../bible_data.dart';
import '../models/bible_models.dart';

class BibleScreen extends StatefulWidget {
  final String? initialBookId;
  final int? initialChapter;

  const BibleScreen({super.key, this.initialBookId, this.initialChapter});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  late String _selectedBookId;
  late int _selectedChapter;
  Future<List<Verse>>? _versesFuture;
  final FlutterTts _tts = FlutterTts();
  
  bool _isPlayingAll = false;
  int? _activeVerse; 
  int _currentReadingIndex = 0; 
  List<Verse> _cachedVerses = []; 

  final Set<Verse> _selection = {};
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applyIncomingNavigation();
    _initVoice();
    _logHistory();
  }

  void _applyIncomingNavigation() {
    String id = widget.initialBookId ?? 'mt';
    if (!BibleData.books.containsKey(id)) {
      id = (id == 'joa') ? 'joao' : 'mt';
    }
    
    _selectedBookId = id;
    int max = BibleData.chapterCounts[_selectedBookId] ?? 1;
    _selectedChapter = widget.initialChapter ?? 6;
    if (_selectedChapter > max) _selectedChapter = 1;
    
    _load();
  }

  void _load() {
    setState(() {
      _versesFuture = BibleData.getChapterVerses(_selectedBookId, _selectedChapter);
    });
  }

  void _logHistory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String name = BibleData.books[_selectedBookId] ?? 'Livro';
      Provider.of<BibleProvider>(context, listen: false)
          .addHistory(_selectedBookId, name, _selectedChapter);
    });
  }

  @override
  void didUpdateWidget(BibleScreen old) {
    super.didUpdateWidget(old);
    if (widget.initialBookId != null && (widget.initialBookId != old.initialBookId || widget.initialChapter != old.initialChapter)) {
      _applyIncomingNavigation();
      _logHistory();
    }
  }

  void _initVoice() async {
    await _tts.setLanguage("pt-BR");
    _tts.setCompletionHandler(() {
      if (_isPlayingAll) {
        _readNextInSequence();
      } else {
        setState(() => _activeVerse = null);
      }
    });
  }

  void _readNextInSequence() async {
    _currentReadingIndex++;
    if (_currentReadingIndex < _cachedVerses.length) {
      final v = _cachedVerses[_currentReadingIndex];
      setState(() => _activeVerse = v.verse);
      await _tts.speak("Versículo ${v.verse}. ${v.text}");
    } else {
      setState(() {
        _isPlayingAll = false;
        _activeVerse = null;
        _currentReadingIndex = 0;
      });
    }
  }

  // --- BOTÃO GRANDE (TOPO) ---
  Future<void> _speakChapter(double rate) async {
    if (_isPlayingAll) { 
      await _tts.stop(); 
      setState(() => _isPlayingAll = false); 
      return; 
    }
    
    final list = await _versesFuture;
    if (list == null || list.isEmpty) return;
    
    _cachedVerses = list;
    _currentReadingIndex = 0;
    
    setState(() {
      _isPlayingAll = true;
      _activeVerse = _cachedVerses[0].verse;
    });
    
    final String bookName = BibleData.books[_selectedBookId] ?? '';
    await _tts.setSpeechRate(rate * 0.5);
    
    // Anuncia Livro e Capítulo apenas no início da leitura geral
    await _tts.speak("$bookName, Capítulo $_selectedChapter. Versículo ${_cachedVerses[0].verse}. ${_cachedVerses[0].text}");
  }

  // --- BOTÃO PEQUENO (INDIVIDUAL) ---
  Future<void> _toggleSingleVerse(Verse v, double rate) async {
    if (_activeVerse == v.verse) {
      await _tts.stop();
      setState(() => _activeVerse = null);
    } else {
      await _tts.stop();
      setState(() {
        _isPlayingAll = false;
        _activeVerse = v.verse;
      });
      await _tts.setSpeechRate(rate * 0.5);
      await _tts.speak("${v.bookName}, capítulo ${v.chapter}, versículo ${v.verse}. ${v.text}");
    }
  }

  void _openNoteCreatorDialog(Verse verse, BibleProvider provider) {
    final preNote = provider.notes.firstWhere(
      (n) => n.bookId == verse.bookId && n.chapter == verse.chapter && n.verse == verse.verse,
      orElse: () => BibleNote(id: '', bookId: '', bookName: '', chapter: 0, verse: 0, verseText: '', noteText: '', createdAt: ''),
    );
    _noteController.text = preNote.noteText;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161A30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Anotação — ${verse.bookName} ${verse.chapter}:${verse.verse}',
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${verse.text}"',
              style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escreva sua reflexão ou estudo aqui...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF0B0E20),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF818CF8)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [ 
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.saveNote(verse, _noteController.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anotação guardada com sucesso!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            child: const Text('Salvar Nota', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BibleProvider>(context);
    int maxChapters = BibleData.chapterCounts[_selectedBookId] ?? 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D1D),
      bottomNavigationBar: _selection.isNotEmpty ? BottomAppBar(color: const Color(0xFF161A30), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () { for(var v in _selection) prov.toggleFavorite(v, colorCode: 'red'); setState(()=> _selection.clear()); }),
        IconButton(icon: const Icon(Icons.share, color: Colors.blue), onPressed: () { Share.share(_selection.map((v)=> "${v.verse}. ${v.text}").join("\n")); setState(()=> _selection.clear()); }),
        IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => setState(()=> _selection.clear())),
      ])) : null,
      body: SafeArea(
        child: Column(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), color: const Color(0xFF101426), child: Row(children: [
            Expanded(child: DropdownButton<String>(
              isExpanded: true, underline: const SizedBox(), dropdownColor: const Color(0xFF101426),
              value: _selectedBookId,
              items: BibleData.books.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)))).toList(),
              onChanged: (v) { if(v!=null) setState((){ _selectedBookId=v; _selectedChapter=1; _load(); _logHistory(); }); },
            )),
            const SizedBox(width: 10),
            Expanded(child: DropdownButton<int>(
              isExpanded: true, underline: const SizedBox(), dropdownColor: const Color(0xFF101426),
              value: _selectedChapter,
              items: List.generate(maxChapters, (i) => DropdownMenuItem(value: i + 1, child: Text('Capítulo ${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 14)))),
              onChanged: (v) { if(v!=null) setState((){ _selectedChapter=v; _load(); _logHistory(); }); },
            )),
            IconButton(
              icon: Icon(_isPlayingAll ? Icons.pause_circle : Icons.play_circle, color: const Color(0xFF6366F1), size: 32), 
              onPressed: () => _speakChapter(prov.speechRate)
            ),
          ])),
          
          Expanded(child: FutureBuilder<List<Verse>>(future: _versesFuture, builder: (context, snap){
            if(!snap.hasData) return const Center(child: CircularProgressIndicator());
            final verses = snap.data!;
            return ListView.builder(itemCount: verses.length, itemBuilder: (context, i){
              final v = verses[i];
              bool isFav = prov.isFavorite(v.bookId, v.chapter, v.verse);
              bool isSel = _selection.contains(v);
              bool isRead = _activeVerse == v.verse; 
              
              return GestureDetector(
                onLongPress: () => setState(()=> _selection.add(v)),
                onTap: _selection.isNotEmpty ? () => setState(()=> _selection.contains(v) ? _selection.remove(v) : _selection.add(v)) : null,
                child: Container(
                  margin: const EdgeInsets.all(10), 
                  padding: const EdgeInsets.all(15), 
                  decoration: BoxDecoration(
                    color: isFav ? Colors.red.withValues(alpha: 0.1) : const Color(0xFF121630), 
                    borderRadius: BorderRadius.circular(15), 
                    border: Border.all(
                      color: isRead ? Colors.orange : (isSel ? Colors.blue : Colors.transparent), 
                      width: 2.0 
                    )
                  ), 
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("${v.verse}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                      if(_selection.isEmpty) Row(children: [
                        IconButton(
                          icon: Icon(isRead ? Icons.stop_circle : Icons.volume_up, size: 18, color: isRead ? Colors.orange : Colors.blue), 
                          onPressed: () => _toggleSingleVerse(v, prov.speechRate)
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_note, size: 18, color: Colors.grey), 
                          onPressed: () => _openNoteCreatorDialog(v, prov),
                        ),
                        IconButton(icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 18, color: isFav ? Colors.red : Colors.grey), onPressed: () => prov.toggleFavorite(v, colorCode: 'red')),
                        IconButton(icon: const Icon(Icons.share, size: 18, color: Colors.grey), onPressed: () => Share.share("${v.verse}. ${v.text}\n— ${v.bookName} ${v.chapter}")),
                      ])
                    ]),
                    const SizedBox(height: 10),
                    Text(v.text, style: GoogleFonts.merriweather(color: Colors.white.withValues(alpha: 0.9), fontSize: 17, height: 1.6)),
                  ])),
              );
            });
          })),
        ]),
      ),
    );
  }
}