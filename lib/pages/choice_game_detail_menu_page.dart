import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';
import 'package:gorsel_programlama_proje/components/zoom_dialog.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_page.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';

class ChoiceGameDetailMenuPage extends StatefulWidget {
  final List<CardModel> cards;
  final int round;
  final String title;
  final String description;
  final int gamePlayCount;
  final bool isGameOver;
  const ChoiceGameDetailMenuPage({
    super.key,
    required this.cards,
    required this.title,
    required this.description,
    required this.round,
    required this.gamePlayCount,
    this.isGameOver = false,
  });

  @override
  State<ChoiceGameDetailMenuPage> createState() =>
      _ChoiceGameDetailMenuPageState();
}

class _ChoiceGameDetailMenuPageState extends State<ChoiceGameDetailMenuPage> {
  String selectedGameMode = 'Klasik mod'; // Varsayılan mod

  void sortCardByWinRate() {
    widget.cards.sort(
      (a, b) =>
          ((widget.gamePlayCount == 0 ? 0 : b.winCount / widget.gamePlayCount) *
                  100)
              .compareTo(
                (widget.gamePlayCount == 0
                        ? 0
                        : a.winCount / widget.gamePlayCount) *
                    100,
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sortCardByWinRate();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: header(context),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cards.length,
                itemBuilder: (context, i) {
                  final winRate =
                      (widget.gamePlayCount == 0
                          ? 0
                          : widget.cards[i].winCount / widget.gamePlayCount) *
                      100;
                  return GestureDetector(
                    onTap: () {
                      ZoomDialog.show(
                        context: context,
                        image:
                            widget.cards[i].name == "Empty"
                                ? Image.asset("assets/icons/cross.png")
                                : Image.network(
                                  "${BaseUrl.imageBaseUrl}/${widget.cards[i].imagePath}",
                                ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GradientBorder(
                        padding: 0,
                        height: 100,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                "${BaseUrl.imageBaseUrl}/${widget.cards[i].imagePath}",
                                width: 120,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.cards[i].name,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(10),
                                      value: winRate / 100,
                                      backgroundColor: Colors.grey.shade300,
                                      color: Colors.blue,
                                      minHeight: 8,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Kazanma Oranı: %${winRate.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  GradientBorder header(BuildContext context) {
    return GradientBorder(
      padding: 10,
      child: Column(
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.displayLarge),
          SizedBox(height: 10),
          Text(widget.description),
          SizedBox(height: 10),
          if (!widget.isGameOver) ...[
            DropdownButton<String>(
              value: selectedGameMode,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGameMode = newValue!;
                });
              },
              items:
                  <String>[
                    'Klasik mod',
                    'Turnuva modu',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: "Oyna",
              width: MediaQuery.of(context).size.width * 0.2,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CohiceGamePage(
                          cards: widget.cards,
                          round: widget.round,
                          mode: selectedGameMode,
                          title: widget.title,
                          description: widget.description,
                          // ÖNEMLİ: Seçilen modu buraya taşıyabilirsin!
                          // choiceGameMode: selectedGameMode, gibi parametre eklemen gerekir.
                        ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}
