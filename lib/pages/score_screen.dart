import 'package:fl_score_bar/fl_score_bar.dart';
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/user.dart';
import 'package:gorsel_programlama_proje/pages/home_page.dart';
import 'package:gorsel_programlama_proje/pages/login_page.dart'; // Yeni import
import 'package:gorsel_programlama_proje/pages/score_history_page.dart';
import 'package:gorsel_programlama_proje/services/score_service.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';
import 'package:lottie/lottie.dart';

class ScoreList {
  static List<ScoreItem> list = [];
}

class ScoreItem {
  final int score;

  ScoreItem(this.score);
}

class ScoreScreen extends StatefulWidget {
  final int score;
  final int totalScore; // Yeni değişken
  final int? userId; // Yeni değişken

  // Varsayılan score 0 olarak güncellendi ve totalScore eklendi
  const ScoreScreen({
    super.key,
    this.score = 0,
    this.totalScore = 100,
    this.userId,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final DatabaseService _databaseService = DatabaseService(); // Yeni nesne

  double get progress =>
      widget.score / widget.totalScore; // totalScore kullanılıyor

  Color get barColor {
    if (progress >= 0.8) return Colors.greenAccent;
    if (progress >= 0.5) return Colors.amberAccent;
    return Colors.redAccent;
  }

  String get feedback {
    if (progress >= 0.5) return "Mükemmel!";
    if (progress >= 0.3) return "İyi iş çıkardın!";
    return "Daha iyisini yapabilirsin!";
  }

  // En yüksek skoru hesapla
  int get highScore {
    // ScoreList.list'den en yüksek skoru alıyoruz
    if (ScoreList.list.isEmpty) return 0;
    return ScoreList.list.map((e) => e.score).reduce((a, b) => a > b ? a : b);
  }

  @override
  void initState() {
    super.initState();
    _databaseService.saveScore(widget.score); // Skor kaydediliyor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Skor otomatik olarak kaydedildi!')),
      );
    });
    ScoreList.list.add(ScoreItem(widget.score));
  }

  @override
  Widget build(BuildContext context) {
    final User? user = UserService.user;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/background.json',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Lottie.asset(
                          'assets/animations/congrats.json',
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        ShaderMask(
                          shaderCallback:
                              (bounds) => const LinearGradient(
                                colors: [Colors.pinkAccent, Colors.amberAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                          child: const Text(
                            "Tebrikler!",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(2, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        IconScoreBar(
                          scoreIcon: Icons.star_rounded,
                          iconColor: Colors.yellow,
                          score: (widget.score / (widget.totalScore / 5)).clamp(
                            0,
                            5,
                          ),
                          maxScore: 5,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${widget.score} / ${widget.totalScore}',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "En yüksek skor: $highScore",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          feedback,
                          style: TextStyle(
                            color: barColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildGradientButton(
                          text: "Tekrar Dene",
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                        _buildGradientButton(
                          text: "Skor Tablosu",
                          onTap: () {
                            if (user?.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ScoreHistoryPage(userId: user!.id),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kullanıcı bilgisi alınamadı.'),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          },
                        ),
                        _buildGradientButton(
                          text: "Ana sayfaya dön",
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Colors.orangeAccent, Colors.amber],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber,
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
