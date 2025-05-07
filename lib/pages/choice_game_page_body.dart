import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/components/slide_animation.dart';
import 'package:gorsel_programlama_proje/components/zoom_dialog.dart';
import 'package:gorsel_programlama_proje/models/game.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';
import 'package:lottie/lottie.dart';

class ChoiceGamePageBody extends StatefulWidget {
  final Game game;
  final VoidCallback onGameUpdated;
  const ChoiceGamePageBody({
    super.key,
    required this.game,
    required this.onGameUpdated,
  });

  @override
  State<ChoiceGamePageBody> createState() => _ChoiceGamePageBodyState();
}

class _ChoiceGamePageBodyState extends State<ChoiceGamePageBody>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool showAnimation = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showAnimation = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Column(
            children: [
              Text("${widget.game.currentRound} / ${widget.game.round}"),
              SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: SlideAnimation(
                  startOffsetX: 1.5,
                  startOffsetY: -1.5,
                  child: Box(
                    onpressed: () {
                      widget.game.selectFirstCard();
                      setState(() {
                        widget.game.updateCurrentRound();
                      });
                      widget.onGameUpdated();
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                widget.game.cards[0].name == "Empty"
                                    ? Image.asset("assets/icons/cross.png")
                                    : Image.network(
                                      "${BaseUrl.imageBaseUrl}/${widget.game.cards[0].imagePath}",
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withAlpha(180),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 30,
                            child: Center(
                              child: Text(widget.game.cards[0].name),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: zoomButton(context, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Image.asset("assets/icons/vs.png", fit: BoxFit.contain),
              ),
              Expanded(
                flex: 4,
                child: SlideAnimation(
                  startOffsetX: -1.5,
                  startOffsetY: 1.5,
                  child: Box(
                    onpressed: () {
                      widget.game.selectSecondCard();
                      setState(() {
                        widget.game.updateCurrentRound();
                      });
                      widget.onGameUpdated();
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                widget.game.cards[1].name == "Empty"
                                    ? Image.asset("assets/icons/cross.png")
                                    : Image.network(
                                      "${BaseUrl.imageBaseUrl}/${widget.game.cards[1].imagePath}",
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(180),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 30,
                            child: Center(
                              child: Text(widget.game.cards[1].name),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: zoomButton(context, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Lottie animasyonu tam VS logosunun üstüne gelsin
          showAnimation
              ? animation(widget.game.cards[0].name, widget.game.cards[1].name)
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  GestureDetector zoomButton(BuildContext context, int i) {
    return GestureDetector(
      onTap: () {
        ZoomDialog.show(
          context: context,
          image:
              widget.game.cards[i].name == "Empty"
                  ? Image.asset("assets/icons/cross.png")
                  : Image.network(
                    "${BaseUrl.imageBaseUrl}/${widget.game.cards[i].imagePath}",
                  ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
        ),
        child: Icon(Icons.zoom_in),
      ),
    );
  }

  Widget animation(ad1, ad2) {
    String? animationPath;
    Duration duration = Duration(milliseconds: 2000);
    if (ad1 == "Fatma" && ad2 == "Tolga" ||
        ad1 == "Tolga" && ad2 == "Fatma" ||
        ad1 == "Tolga" && ad2 == "Fatma (Prime)" ||
        ad1 == "Fatma (Prime)" && ad2 == "Tolga") {
      animationPath = 'assets/animations/Kalp.json';
    } else if (ad1 == "Fatma" && ad2 == "Fatma (Prime)" ||
        ad1 == "Fatma (Prime)" && ad2 == "Fatma") {
      animationPath = "assets/animations/Kafatasi.json";
    } else if (ad1 == "Aydın" && ad2 == "Altan" ||
        ad1 == "Altan" && ad2 == "Aydın") {
      animationPath = "assets/animations/Clock.json";
      duration = Duration(seconds: 6);
    } else if (ad1 == "Emir" && ad2 == "Emir (Prime)" ||
        ad1 == "Emir (Prime)" && ad2 == "Emir") {
      animationPath = "assets/animations/Code.json";
    }
    if (animationPath == null || animationPath.isEmpty) {
      return SizedBox();
    }
    setState(() {
      showAnimation = true;
    });
    return Align(
      alignment: Alignment.center,
      child: Lottie.asset(
        animationPath,
        controller: _controller,
        width: 300,
        height: 300,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          _controller.duration = duration;
          _controller.forward();
        },
      ),
    );
  }
}
