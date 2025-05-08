import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/pages/information_quiz_intro.dart';
import 'package:gorsel_programlama_proje/pages/quizhomepage.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';
import 'package:lottie/lottie.dart';

class QuizIntroPage extends StatefulWidget {
  const QuizIntroPage({super.key});

  @override
  State<QuizIntroPage> createState() => _QuizIntroPageState();
}

class _QuizIntroPageState extends State<QuizIntroPage> {
  bool _showSpeechBubble = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        _showSpeechBubble = true;
      });
    });
  }

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizHomePage(category: "bilim"),
      ),
    );
  }

  void navigateToInformationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InformationQuizIntro()),
    );
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset('assets/animations/background.json', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "Bilgi Yarışmasına Hoş Geldin ${UserService.user?.username ?? 'Misafir'}!",
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
                    const SizedBox(height: 8),
                    Lottie.asset('assets/animations/intro.json', height: 300),
                    const SizedBox(height: 8),
                    if (_showSpeechBubble)
                      GestureDetector(
                        onTap: () => navigateToInformationPage(context),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00FFAB), Color(0xFF58CFFB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: Offset(4, 4),
                                blurRadius: 12,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.3),
                                offset: Offset(-4, -4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.question_mark_rounded,
                                  color: const Color.fromARGB(255, 236, 221, 3),
                                  size: 26,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Nedir bu yarışma?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(255, 88, 6, 82),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                        offset: Offset(1.5, 1.5),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => navigateToHome(context),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00FFAB), Color(0xFF58CFFB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: Offset(4, 4),
                              blurRadius: 12,
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              offset: Offset(-4, -4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 36.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: const Color.fromARGB(255, 213, 228, 4),
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Hazırım! Başlayalım",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 88, 6, 82),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => navigateToLoginPage(context),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00FFAB), Color(0xFF58CFFB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: Offset(4, 4),
                              blurRadius: 12,
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              offset: Offset(-4, -4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 36.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.redAccent,
                                size: 26,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Çıkış Yap",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 88, 6, 82),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
