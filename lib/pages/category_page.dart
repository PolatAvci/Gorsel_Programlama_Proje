import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/pages/quiz_page.dart';
import 'package:gorsel_programlama_proje/pages/quizhomepage.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  void navigateToQuiz(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                QuizPage(category: category), // Kategori bilgisi ile geçiş
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = min(
      MediaQuery.of(context).size.width,
      500.0,
    ); // max 500 px
    final screenHeight = min(
      MediaQuery.of(context).size.height,
      900.0,
    ); // max 900 px

    final brainSize = screenWidth * 0.4;
    final iconSize = screenWidth * 0.2;
    final spacingFactor = 1.0;

    final center = Offset(screenWidth / 2, screenHeight * 0.4);
    final double spacing = brainSize / 2 * spacingFactor + iconSize / 2;

    final List<Map<String, dynamic>> categories = [
      {
        "name": "Tarih",
        "image": "assets/icons/tarih.png",
        "position": Offset(90, -spacing),
      },
      {
        "name": "Genel Kültür",
        "image": "assets/icons/genel_kültür.png",
        "position": Offset(-90, spacing),
      },
      {
        "name": "Spor",
        "image": "assets/icons/spor.png",
        "position": Offset(-spacing, -100),
      },
      {
        "name": "Bilim",
        "image": "assets/icons/bilim.png",
        "position": Offset(spacing, 100),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 73, 141, 168),
                const Color.fromARGB(255, 100, 8, 92),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "KATEGORİLER",
              style: TextStyle(
                color: Color(0xFFFFD700), // Koyu sarı
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black, // Siyah gölge
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFFD700)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 120, 199, 230),
                    const Color.fromARGB(255, 100, 8, 92),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    // Beyin görseli
                    Positioned(
                      left: center.dx - brainSize / 2,
                      top: center.dy - brainSize / 2,
                      child: Container(
                        width: brainSize,
                        height: brainSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/icons/beyin.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Kategoriler + metinleri
                    ...categories.map((category) {
                      final Offset pos = center + category['position'];
                      return Stack(
                        children: [
                          // Kategori ikonu
                          Positioned(
                            left: pos.dx - iconSize / 2,
                            top: pos.dy - iconSize / 2,
                            child: GestureDetector(
                              onTap:
                                  () => navigateToQuiz(
                                    context,
                                    category['name'] as String,
                                  ),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Image.asset(
                                      category['image'] as String,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Kategori adı metni
                          Positioned(
                            left: pos.dx - iconSize,
                            top: pos.dy + iconSize / 2 + 4,
                            width: iconSize * 2,
                            child: Center(
                              child: Text(
                                category['name'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700), // Koyu sarı
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black, // Siyah gölge
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
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
