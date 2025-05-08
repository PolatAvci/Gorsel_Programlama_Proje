import 'package:gorsel_programlama_proje/models/card_model.dart';

class Game {
  final int _roundCount;
  int round;
  bool _isGameover = false;
  List<CardModel> cards;
  final List<CardModel> _selectedCards = [];
  final List<CardModel> _rankCard = [];
  int _currentRound = 1;
  final int _tournamentRound;
  int _currentTournamentRound = 1;

  Game({required this.round, required this.cards})
    : _roundCount = round,
      _tournamentRound = (cards.length - 1) {
    if (!_isPowerOfTwo(round)) {
      throw Exception("Round sayısı ikini kuvveti olmalıdır");
    }
    while (cards.length < round * 2) {
      cards.add(
        CardModel(
          id: cards.length, // boş id
          name: "Empty",
          imagePath: "assets/icons/cross.png",
          winCount: 0,
        ),
      );
    }
  }

  get currentRound => _currentRound;

  get isGameOver => _isGameover;

  get rankCard => _rankCard;

  get tournamentRound => _tournamentRound;

  get currentTournamentRound => _currentTournamentRound;

  void updateCurrentRound() {
    if (_currentRound == round) {
      _currentRound = 0;
      cards = _selectedCards.toList(); // _selectedCard.copy() ile aynı görev
      _selectedCards.clear();
      round = (round / 2).toInt();
    }
    _currentRound++;
    // son eleman kalınca oyun biter
    if (round == 0 && cards.length == 1) {
      _isGameover = true;
      _rankCard.insert(0, cards[0]); // son kartı sıralamaya dahil et
      cards.clear();
    }
  }

  bool _isPowerOfTwo(int num) {
    return (num > 0 && (num & (num - 1)) == 0);
  }

  void _selectCard(int index) {
    // 0 ilk kart, 1 ikinci kart
    _selectedCards.add(cards[index]);
  }

  void _deSelectCard(int index) {
    // 0 ilk kart, 1 ikinci kart
    _rankCard.insert(0, cards[index]); // ilk elenen kart sonda kalır
  }

  void _makeChoice(int selectedIndex, int deSelectedIndex) {
    _selectCard(selectedIndex);
    _deSelectCard(deSelectedIndex);
    cards.removeAt(0); // ilk kartı kaldırır
    cards.removeAt(0); // ikinci kartı kaldırır
  }

  void selectFirstCard() {
    _makeChoice(0, 1); // ilk kartı seçip ikinci kartı siler
  }

  void selectSecondCard() {
    _makeChoice(1, 0); // ikinci kartı seçip ilk kartı siler
  }

  void deSelectTournament(int deSelectedIndex) {
    _rankCard.insert(0, cards.removeAt(deSelectedIndex));
  }

  void updateTournamentTour() {
    _currentTournamentRound++;
    if (_currentTournamentRound == _tournamentRound + 1) {
      _isGameover = true;
      _rankCard.insert(
        0,
        cards.removeAt(0),
      ); // oyun bitince sona kalan kartı da sıralamaya dahil eder
    }
  }

  void restart() {
    _isGameover = false;

    // oyun bitmediyse kalan kartları eski listesine koyar
    for (CardModel card in _rankCard) {
      cards.add(card);
    }
    for (CardModel card in _selectedCards) {
      cards.add(card);
    }
    _selectedCards.clear();
    _rankCard.clear();
    _currentRound = 1;
    _currentTournamentRound = 1;
    round = _roundCount; // roundu başlangıçtaki sayısına getirir
  }
}
