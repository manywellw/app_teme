
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'models/bible_models.dart';

class BibleData {
  static List<dynamic>? _cachedBibleJson;

  static const Map<String, String> books = {
    'gn': 'Gênesis', 'ex': 'Êxodo', 'lv': 'Levítico', 'nm': 'Números', 'dt': 'Deuteronômio',
    'js': 'Josué', 'jz': 'Juízes', 'rt': 'Rute', '1sm': '1 Samuel', '2sm': '2 Samuel',
    '1rs': '1 Reis', '2rs': '2 Reis', '1cr': '1 Crônicas', '2cr': '2 Crônicas', 'ed': 'Esdras',
    'ne': 'Neemias', 'et': 'Ester', 'jo': 'Jó', 'sl': 'Salmos', 'pv': 'Provérbios',
    'ec': 'Eclesiastes', 'ct': 'Cantares', 'is': 'Isaías', 'jr': 'Jeremias', 'lm': 'Lamentações',
    'ez': 'Ezequiel', 'dn': 'Daniel', 'os': 'Oseias', 'jl': 'Joel', 'am': 'Amós',
    'ob': 'Obadias', 'jn': 'Jonas', 'mq': 'Miqueias', 'na': 'Naum', 'hc': 'Habacuque',
    'sf': 'Sofonias', 'ag': 'Ageu', 'zc': 'Zacarias', 'ml': 'Malaquias', 
    'mt': 'Mateus', 'mc': 'Marcos', 'lc': 'Lucas', 'joao': 'João', 'at': 'Atos', 'rm': 'Romanos',
    '1co': '1 Coríntios', '2co': '2 Coríntios', 'gl': 'Gálatas', 'ef': 'Efésios', 'fp': 'Filipenses',
    'cl': 'Colossenses', '1ts': '1 Tessalonicenses', '2ts': '2 Tessalonicenses', '1tm': '1 Timóteo', '2tm': '2 Timóteo',
    'tt': 'Tito', 'fm': 'Filemom', 'hb': 'Hebreus', 'tg': 'Tiago', '1pe': '1 Pedro',
    '2pe': '2 Pedro', '1jo': '1 João', '2jo': '2 João', '3jo': '3 João', 'jd': 'Judas',
    'ap': 'Apocalipse',
  };

  static const Map<String, int> chapterCounts = {
    'gn': 50, 'ex': 40, 'lv': 27, 'nm': 36, 'dt': 34, 'js': 24, 'jz': 21, 'rt': 4, '1sm': 31, '2sm': 24,
    '1rs': 22, '2rs': 25, '1cr': 29, '2cr': 36, 'ed': 10, 'ne': 13, 'et': 10, 'jo': 42, 'sl': 150, 'pv': 31,
    'ec': 12, 'ct': 8, 'is': 66, 'jr': 52, 'lm': 5, 'ez': 48, 'dn': 12, 'os': 14, 'jl': 3, 'am': 9,
    'ob': 1, 'jn': 4, 'mq': 7, 'na': 3, 'hc': 3, 'sf': 3, 'ag': 2, 'zc': 14, 'ml': 4, 'mt': 28,
    'mc': 16, 'lc': 24, 'joao': 21, 'at': 28, 'rm': 16, '1co': 16, '2co': 13, 'gl': 6, 'ef': 6, 'fp': 4,
    'cl': 4, '1ts': 5, '2ts': 3, '1tm': 6, '2tm': 4, 'tt': 3, 'fm': 1, 'hb': 13, 'tg': 5, '1pe': 5,
    '2pe': 3, '1jo': 5, '2jo': 1, '3jo': 1, 'jd': 1, 'ap': 22
  };

  static Future<List<dynamic>> _loadJsonFile() async {
    if (_cachedBibleJson != null) return _cachedBibleJson!;
    try {
      final String response = await rootBundle.loadString('assets/json/aa.json');
      _cachedBibleJson = json.decode(response) as List<dynamic>;
      return _cachedBibleJson!;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Verse>> getChapterVerses(String bookId, int chapter) async {
    final bibleData = await _loadJsonFile();
    if (bibleData.isEmpty) return [];

    String searchId = (bookId == 'joao') ? 'jo' : bookId;

    final bookJson = bibleData.firstWhere(
      (b) => b['abbrev'].toString().toLowerCase() == searchId.toLowerCase(),
      orElse: () => null,
    );

    if (bookJson == null) return [];
    
    List<dynamic> chapters = bookJson['chapters'];
    if (chapter < 1 || chapter > chapters.length) return [];
    
    List<dynamic> versesList = chapters[chapter - 1];
    return List.generate(versesList.length, (i) => Verse(
      bookId: bookId,
      bookName: books[bookId] ?? 'Livro',
      chapter: chapter,
      verse: i + 1,
      text: versesList[i].toString(),
    ));
  }

  // MÉTODO COM TRAVA DE SEGURANÇA PARA NÃO DAR RANGE ERROR
  static Future<Verse> getRandomVerse() async {
    final random = Random();
    List<String> keys = chapterCounts.keys.toList();
    
    // Tenta até 5 vezes encontrar um versículo real no JSON
    for (int i = 0; i < 5; i++) {
      String rBookId = keys[random.nextInt(keys.length)];
      int maxChapters = chapterCounts[rBookId] ?? 1;
      int rChapter = random.nextInt(maxChapters) + 1;
      
      List<Verse> verses = await getChapterVerses(rBookId, rChapter);
      
      if (verses.isNotEmpty) {
        return verses[random.nextInt(verses.length)];
      }
    }
    
    // FALLBACK: Se tudo falhar, retorna João 3:16 fixo para o app não fechar
    return Verse(
      bookId: 'joao',
      bookName: 'João',
      chapter: 3,
      verse: 16,
      text: 'Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.',
    );
  }
}