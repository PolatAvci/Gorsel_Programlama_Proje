import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/pages/category_page.dart';
import 'package:gorsel_programlama_proje/pages/quizintropage.dart';
import 'package:gorsel_programlama_proje/services/score_service.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';
import 'package:lottie/lottie.dart';

class QuizHomePage extends StatefulWidget {
  final String category;
  const QuizHomePage({super.key, required this.category});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _highScore = 0;

  int get highScore => _highScore;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final userId = UserService.user?.id;
    if (userId != null) {
      try {
        final DatabaseService databaseService = DatabaseService();
        final scores = await databaseService.getScoresByUserId(userId);
        if (scores.isNotEmpty) {
          scores.sort((a, b) => b.scorePuan.compareTo(a.scorePuan));
          setState(() {
            _highScore = scores.first.scorePuan;
          });
        } else {
          setState(() {
            _highScore = 0;
          });
        }
      } catch (e) {
        print('En yüksek skor yüklenirken hata oluştu: $e');
        setState(() {
          _highScore = 0;
        });
      }
    } else {
      setState(() {
        _highScore = 0;
      });
    }
  }

  void updateHighScoreIfNeeded(int currentScore) async {
    if (currentScore > _highScore) {
      setState(() {
        _highScore = currentScore;
      });
      final DatabaseService databaseService = DatabaseService();
      await databaseService.saveScore(currentScore);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startQuiz() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 0), () {
          if (!context.mounted) return;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage()),
          );
        });
        return Center(
          child: Lottie.asset('assets/animations/loading.json', width: 150),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset('assets/animations/background.json', fit: BoxFit.cover),
          Positioned(
            top: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 138, 26, 130),
                      Color(0xFFBB49D1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 231, 235, 8),
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Seçtiğin Kategori İçin Kolları Sıva Bakalım!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 88, 6, 82),
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "🏆 En Yüksek Skor: $highScore",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.amberAccent,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Lottie.asset(
                    'assets/animations/quiz_start.json',
                    height: 200,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: startQuiz,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFC93C), Color(0xFFFF6F91)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            offset: Offset(4, 4),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.2),
                            offset: Offset(-4, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      child: Text(
                        "🎮 Oyuna Başla!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 88, 6, 82),
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                            Shadow(
                              offset: Offset(-1, -1),
                              blurRadius: 2,
                              color: Colors.white24,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
