import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final int id; // Yeni eklenen ID alanı
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;

  final int difficulty;

  Question({
    required this.id, // Constructor'a ID'yi ekleyin
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      questionText: json['questionText'] ?? '',
      options: [
        json['optionA'] ?? '',
        json['optionB'] ?? '',
        json['optionC'] ?? '',
        json['optionD'] ?? '',
      ],
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      category: json['category'] ?? '',
      difficulty:
          json['difficulty'], // Backend'den geliyorsa bu şekilde alabilirsiniz
    );
  }
}

// API'den soruları almak için fonksiyon (Kategoriye göre filtreleme eklendi)
Future<List<Question>> fetchQuestions(String category) async {
  final response = await http.get(
    Uri.parse('http://localhost:5251/api/questions/by-category/$category'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Question.fromJson(json)).toList();
  } else {
    print('API İstek Hatası: ${response.statusCode}');
    print('API Cevabı: ${response.body}');
    throw Exception('Failed to load questions');
  }
}
