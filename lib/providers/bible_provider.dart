import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_models.dart';

class BibleProvider extends ChangeNotifier {
  List<FavoriteVerse> _favorites = [];
  List<BibleNote> _notes = [];
  List<ReadingHistory> _history = [];
  List<ChatMessage> _chats = [];
  
  double _fontSize = 18.0;
  double _speechRate = 1.0;
  bool _isAudioOn = true;
  String _theme = "dark";

  // Getters
  List<FavoriteVerse> get favorites => _favorites;
  List<BibleNote> get notes => _notes;
  List<ReadingHistory> get history => _history;
  List<ChatMessage> get chats => _chats;
  double get fontSize => _fontSize;
  double get speechRate => _speechRate;
  bool get isAudioOn => _isAudioOn;
  String get theme => _theme;

  BibleProvider() {
    _loadFromPreferences();
  }

  // Load from local SharedPreferences persistence
  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // FontSize & Configuration
      _fontSize = prefs.getDouble('fontSize') ?? 18.0;
      _speechRate = prefs.getDouble('speechRate') ?? 1.0;
      _isAudioOn = prefs.getBool('isAudioOn') ?? true;
      _theme = prefs.getString('theme') ?? "dark";

      // Favorites
      final favsString = prefs.getString('favorites_bible_teme');
      if (favsString != null) {
        final List<dynamic> decoded = jsonDecode(favsString);
        _favorites = decoded.map((item) => FavoriteVerse.fromJson(item)).toList();
      }

      // Notes
      final notesString = prefs.getString('notes_bible_teme');
      if (notesString != null) {
        final List<dynamic> decoded = jsonDecode(notesString);
        _notes = decoded.map((item) => BibleNote.fromJson(item)).toList();
      }

      // History
      final histString = prefs.getString('history_bible_teme');
      if (histString != null) {
        final List<dynamic> decoded = jsonDecode(histString);
        _history = decoded.map((item) => ReadingHistory.fromJson(item)).toList();
      } else {
        // Starter logs
        _history = [
          ReadingHistory(bookId: 'sl', bookName: 'Salmos', chapter: 23, readAt: DateTime.now().toLocal().toString().substring(0,10)),
          ReadingHistory(bookId: 'mt', bookName: 'Mateus', chapter: 6, readAt: DateTime.now().toLocal().toString().substring(0,10)),
        ];
      }

      // AI Chats
      final chatsString = prefs.getString('chat_bible_teme');
      if (chatsString != null) {
        final List<dynamic> decoded = jsonDecode(chatsString);
        _chats = decoded.map((item) => ChatMessage.fromJson(item)).toList();
      } else {
        _chats = [
          ChatMessage(
            id: "welcome",
            role: "assistant",
            text: "Olá! Que a paz do Senhor Jesus esteja com você.\n\nEu sou o **TEME AI Assistant**, seu conselheiro teológico dedicado. Posso lhe auxiliar a decifrar trechos complexos das Escrituras Sagradas seguindo a versão **Almeida Atualizada (AA)**, propor versículos para reflexão, sugerir orações de consolo ou explicar o profundo significado do lema **TEME (Trabalho, Evangélico, Missão, Eterna)**!\n\nDigite sua dúvida teológica abaixo. Como posso lhe auxiliar em sua caminhada espiritual e estudo de hoje?",
            timestamp: DateTime.now().toLocal().toString().substring(11,16),
          )
        ];
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao carregar dados do SharedPreferences: $e");
    }
  }

  // Preferences saving methods
  Future<void> updateFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  Future<void> updateSpeechRate(double rate) async {
    _speechRate = rate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('speechRate', rate);
    notifyListeners();
  }

  Future<void> toggleAudio(bool status) async {
    _isAudioOn = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAudioOn', status);
    notifyListeners();
  }

  // Favorites logic flow
  bool isFavorite(String bookId, int cap, int ver) {
    return _favorites.any((f) => f.bookId == bookId && f.chapter == cap && f.verse == ver);
  }

  String? getFavoriteColor(String bookId, int cap, int ver) {
    try {
      return _favorites.firstWhere((f) => f.bookId == bookId && f.chapter == cap && f.verse == ver).color;
    } catch (_) {
      return null;
    }
  }

  Future<void> toggleFavorite(Verse verse, {String? colorCode}) async {
    final idx = _favorites.indexWhere((f) => f.bookId == verse.bookId && f.chapter == verse.chapter && f.verse == verse.verse);
    
    if (idx != -1) {
      if (_favorites[idx].color == colorCode) {
        _favorites.removeAt(idx);
      } else {
        _favorites[idx] = FavoriteVerse(
          bookId: verse.bookId,
          bookName: verse.bookName,
          chapter: verse.chapter,
          verse: verse.verse,
          text: verse.text,
          color: colorCode ?? "amber",
          createdAt: DateTime.now().toString().substring(0, 10),
        );
      }
    } else {
      _favorites.add(FavoriteVerse(
        bookId: verse.bookId,
        bookName: verse.bookName,
        chapter: verse.chapter,
        verse: verse.verse,
        text: verse.text,
        color: colorCode ?? "amber",
        createdAt: DateTime.now().toString().substring(0, 10),
      ));
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites_bible_teme', jsonEncode(_favorites.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  Future<void> removeFavorite(String bookId, int chapter, int verse) async {
    _favorites.removeWhere((f) => f.bookId == bookId && f.chapter == chapter && f.verse == verse);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites_bible_teme', jsonEncode(_favorites.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  // Notes logical flow
  Future<void> saveNote(Verse verse, String text) async {
    final idx = _notes.indexWhere((n) => n.bookId == verse.bookId && n.chapter == verse.chapter && n.verse == verse.verse);
    final stamp = '${DateTime.now().toLocal().toString().substring(0,10)} ${DateTime.now().toLocal().toString().substring(11,16)}';
    
    if (idx != -1) {
      _notes[idx].noteText = text;
      _notes[idx].createdAt = stamp;
    } else {
      _notes.add(BibleNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bookId: verse.bookId,
        bookName: verse.bookName,
        chapter: verse.chapter,
        verse: verse.verse,
        verseText: verse.text,
        noteText: text,
        createdAt: stamp,
      ));
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes_bible_teme', jsonEncode(_notes.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  Future<void> removeNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes_bible_teme', jsonEncode(_notes.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  // Reading history logical flow
  Future<void> addHistory(String bookId, String bookName, int chapter) async {
    final stamp = DateTime.now().toLocal().toString().substring(0, 10);
    _history.removeWhere((h) => h.bookId == bookId && h.chapter == chapter);
    _history.insert(0, ReadingHistory(bookId: bookId, bookName: bookName, chapter: chapter, readAt: stamp));
    
    if (_history.length > 15) {
      _history = _history.sublist(0, 15);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('history_bible_teme', jsonEncode(_history.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  // Chat memory logical flow
  Future<void> addChatMessage(ChatMessage msg) async {
    _chats.add(msg);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_bible_teme', jsonEncode(_chats.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  Future<void> clearChatHistory() async {
    _chats = [
      ChatMessage(
        id: "cleared",
        role: "assistant",
        text: "Histórico de conversa limpo! Como posso te ajudar na reflexão bíblica hoje?",
        timestamp: DateTime.now().toLocal().toString().substring(11, 16),
      )
    ];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_bible_teme', jsonEncode(_chats.map((x) => x.toJson()).toList()));
    notifyListeners();
  }

  // RESET ALL DATA
  Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _favorites = [];
    _notes = [];
    _history = [];
    _chats = [
      ChatMessage(
        id: "reset",
        role: "assistant",
        text: "Todos os dados locais foram limpados. Como posso te auxiliar em seu estudo de hoje?",
        timestamp: DateTime.now().toLocal().toString().substring(11, 16),
      )
    ];
    _fontSize = 18.0;
    _speechRate = 1.0;
    _isAudioOn = true;
    _theme = "dark";

    notifyListeners();
  }
}