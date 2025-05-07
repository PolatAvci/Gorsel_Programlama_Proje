//import 'dart:html' as html;
//import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_card.dart';
import 'package:gorsel_programlama_proje/models/game_model.dart';
import 'package:gorsel_programlama_proje/pages/add_card_page.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_detail_menu_page.dart';
import 'package:gorsel_programlama_proje/pages/my_games_page.dart';
import 'package:gorsel_programlama_proje/services/game_service.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';

class ChoiceGameMenuPage extends StatefulWidget {
  const ChoiceGameMenuPage({super.key});

  @override
  State<ChoiceGameMenuPage> createState() => _ChoiceGameMenuPageState();
}

class _ChoiceGameMenuPageState extends State<ChoiceGameMenuPage> {
  List<GameModel> games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    //debugFetch("https://localhost:7176/images/cards/cem.jpeg");

    GameService.getGames().then((g) {
      setState(() {
        if (g != null) {
          games = g;
        } else {
          games = [];
        }
        isLoading = false;
      });
    });
  }

  /*
  Future<void> debugFetch(String url) async {
    try {
      final resp = await html.HttpRequest.request(
        url,
        responseType: 'arraybuffer',
      );
      print('Status: ${resp.status}'); // should be 200
      print('Content-Type: ${resp.getResponseHeader('content-type')}');
      final bytes = Uint8List.view(resp.response as ByteBuffer);
      print(
        'Header bytes: ${bytes.take(4).map((b) => b.toRadixString(16)).toList()}',
      );
    } catch (e) {
      print('Fetch error: $e');
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          UserService.user == null
              ? null
              : FloatingActionButton(
                elevation: 10,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.add),
                              title: Text('Oyun Oluştur'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCardPage(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.videogame_asset),
                              title: Text('Oyunlarım'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyGamesPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  );
                },
                child: Icon(Icons.add),
              ),
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
        child:
            isLoading && games.isEmpty
                ? Center(child: CircularProgressIndicator())
                : games.isEmpty
                ? Center(child: Text("Oyun bulunamadı!"))
                : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                        ),
                        itemCount: games.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.all(5),
                            child: CustomCard(
                              round: games[i].round,
                              headerImage: games[i].imagePath,
                              cards: games[i].cards,
                              title: games[i].name,
                              description: games[i].description,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChoiceGameDetailMenuPage(
                                          cards: games[i].cards,
                                          round: games[i].round,
                                          title: games[i].name,
                                          description: games[i].description,
                                          gamePlayCount: games[i].playCount,
                                        ),
                                  ),
                                );
                              },
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
}
