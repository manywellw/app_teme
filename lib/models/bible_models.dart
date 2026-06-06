
class Verse {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  Verse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      bookId: json['bookId'] ?? '',
      bookName: json['bookName'] ?? '',
      chapter: json['chapter'] ?? 1,
      verse: json['verse'] ?? 1,
      text: json['text'] ?? '',
    );
  }
}

class FavoriteVerse {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
  final String? color;
  final String createdAt;

  FavoriteVerse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
    this.color,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'color': color,
      'createdAt': createdAt,
    };
  }

  factory FavoriteVerse.fromJson(Map<String, dynamic> json) {
    return FavoriteVerse(
      bookId: json['bookId'] ?? '',
      bookName: json['bookName'] ?? '',
      chapter: json['chapter'] ?? 1,
      verse: json['verse'] ?? 1,
      text: json['text'] ?? '',
      color: json['color'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class BibleNote {
  final String id;
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String verseText;
  String noteText;
  String createdAt;

  BibleNote({
    required this.id,
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.verseText,
    required this.noteText,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookName': bookName,
      'chapter': chapter,
      'verse': verse,
      'verseText': verseText,
      'noteText': noteText,
      'createdAt': createdAt,
    };
  }

  factory BibleNote.fromJson(Map<String, dynamic> json) {
    return BibleNote(
      id: json['id'] ?? '',
      bookId: json['bookId'] ?? '',
      bookName: json['bookName'] ?? '',
      chapter: json['chapter'] ?? 1,
      verse: json['verse'] ?? 1,
      verseText: json['verseText'] ?? '',
      noteText: json['noteText'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class ReadingHistory {
  final String bookId;
  final String bookName;
  final int chapter;
  final String readAt;

  ReadingHistory({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.readAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'chapter': chapter,
      'readAt': readAt,
    };
  }

  factory ReadingHistory.fromJson(Map<String, dynamic> json) {
    return ReadingHistory(
      bookId: json['bookId'] ?? '',
      bookName: json['bookName'] ?? '',
      chapter: json['chapter'] ?? 1,
      readAt: json['readAt'] ?? '',
    );
  }
}

class ChatMessage {
  final String id;
  final String role; // 'user' ou 'assistant'
  final String text;
  final String timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      role: json['role'] ?? 'user',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
