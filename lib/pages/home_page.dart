import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/components/slide_animation.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_menu_page.dart';
import 'package:gorsel_programlama_proje/pages/login_page.dart';
import 'package:gorsel_programlama_proje/pages/quizintropage.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          UserService.user == null
              ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ).then((_) {
                    setState(() {});
                  });
                },
                icon: Icon(Icons.person),
              )
              : IconButton(
                onPressed: () {
                  setState(() {
                    UserService.logout();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Başarıyla çıkış yapıldı"),
                      showCloseIcon: true,
                    ),
                  );
                },
                icon: Icon(Icons.exit_to_app),
              ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SlideAnimation(
                startOffsetX: 1.5,
                startOffsetY: -1.5,
                child: Box(
                  onpressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChoiceGameMenuPage(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/icons/Logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Image.asset("assets/icons/arrow.png", fit: BoxFit.contain),
            ),
            Expanded(
              flex: 4,
              child: SlideAnimation(
                startOffsetX: -1.5,
                startOffsetY: 1.5,
                child: Box(
                  onpressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizIntroPage()),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/icons/tanitim.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
