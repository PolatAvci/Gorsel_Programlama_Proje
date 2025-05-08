import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';
import 'package:gorsel_programlama_proje/models/game.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_page_body.dart';
import 'package:gorsel_programlama_proje/pages/game_over_body.dart';

class CohiceGamePage extends StatefulWidget {
  final String title;
  final String description;
  final int round;
  final String mode;
  final List<CardModel> cards;
  const CohiceGamePage({
    super.key,
    required this.title,
    required this.description,
    required this.round,
    required this.mode,
    required this.cards,
  });

  @override
  State<CohiceGamePage> createState() => _CohiceGamePageState();
}

class _CohiceGamePageState extends State<CohiceGamePage> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game(round: widget.round, cards: List.from(widget.cards));
    game.cards.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (game.isGameOver) {
              game.restart(); // geri dödüğümüzde kullanıcı tekrar oynamak isterse
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder:
                    (context) => Dialog(
                      child: GradientBorder(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              child: Text(
                                "Geri dönmek oyununuzu iptal edecektir. Emin misiniz?",
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: CustomButton(
                                    text: "Hayır",
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 30,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                CustomButton(
                                  text: "Evet",
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height: 30,
                                  onPressed: () {
                                    game.restart(); // geri dödüğümüzde kullanıcı tekrar oynamak isterse
                                    Navigator.pop(context); // dialog'u kapatır
                                    Navigator.pop(context); // geri döner
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:
          game.isGameOver
              ? GameOverBody(
                game: game,
                onRestart: () {
                  setState(() {});
                },
              )
              : ChoiceGamePageBody(
                game: game,
                mode: widget.mode,
                onGameUpdated: () {
                  setState(
                    () {},
                  ); // oyun bittiğinde bu sayfayı güncellemek için
                },
              ),
    );
  }
}
