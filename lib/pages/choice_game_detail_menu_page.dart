import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_page.dart';

class ChoiceGameDetailMenuPage extends StatelessWidget {
  final List<CardModel> cards;
  final int round;
  final String title;
  final String description;
  final bool isGameOver;
  const ChoiceGameDetailMenuPage({
    super.key,
    required this.cards,
    required this.title,
    required this.description,
    required this.round,
    this.isGameOver = false,
  });

  @override
  Widget build(BuildContext context) {
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
                itemCount: cards.length,
                itemBuilder: (context, i) {
                  return Padding(
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
                              cards[i].imagePath,
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
                                  cards[i].name,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: LinearProgressIndicator(
                                    value: 0.6, // Örnek olarak %60 dolu
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.blue,
                                    minHeight: 8,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "%60",
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
          Text(title, style: Theme.of(context).textTheme.displayLarge),
          Text(description),
          isGameOver
              ? SizedBox()
              : CustomButton(
                text: "Oyna",
                width: MediaQuery.of(context).size.width * 0.2,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CohiceGamePage(
                            cards: cards,
                            round: round,
                            title: title,
                            description: description,
                          ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
