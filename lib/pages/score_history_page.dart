import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/score_history_item.dart';
import 'package:gorsel_programlama_proje/pages/awards.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ScoreHistoryPage extends StatefulWidget {
  final int userId;
  final ScoreHistoryItem? recentEntry;

  const ScoreHistoryPage({super.key, required this.userId, this.recentEntry});

  @override
  State<ScoreHistoryPage> createState() => _ScoreHistoryPageState();
}

class _ScoreHistoryPageState extends State<ScoreHistoryPage> {
  late Future<List<ScoreHistoryItem>> _skorGecmisiGelecegi;
  final Map<int, ScoreHistoryItem> _enSonSkorlar =
      {}; // Kullanıcı ID'sine göre en son skor

  @override
  void initState() {
    super.initState();
    _skorGecmisiGelecegi = fetchScoreHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D2671), Color(0xFFC33764)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'En İyi Skorlar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 4,
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D2671), Color(0xFFC33764)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<ScoreHistoryItem>>(
          future: _skorGecmisiGelecegi,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Veri alınırken bir hata oluştu: ${snapshot.error}',
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Henüz skor kaydı bulunmuyor.'));
            } else {
              final List<ScoreHistoryItem> skorGecmisi = snapshot.data!;

              // Yeni eklenen skoru işle
              if (widget.recentEntry != null) {
                _enSonSkorlar.update(
                  widget.recentEntry!.userId,
                  (existing) =>
                      widget.recentEntry!.datetime.isAfter(existing.datetime)
                          ? widget.recentEntry!
                          : existing,
                  ifAbsent: () => widget.recentEntry!,
                );
              }

              // Veritabanından gelen skor geçmişini işle
              for (var skor in skorGecmisi) {
                _enSonSkorlar.update(
                  skor.userId,
                  (existing) =>
                      skor.datetime.isAfter(existing.datetime)
                          ? skor
                          : existing,
                  ifAbsent: () => skor,
                );
              }

              // En son skorları listeye dönüştür ve sırala
              final enSonSkorListesi = _enSonSkorlar.values.toList();
              enSonSkorListesi.sort((a, b) {
                int skorKarsilastirma = b.scorePuan.compareTo(a.scorePuan);
                return skorKarsilastirma != 0
                    ? skorKarsilastirma
                    : b.datetime.compareTo(a.datetime);
              });

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: enSonSkorListesi.length,
                itemBuilder: (context, index) {
                  final skorKaydi = enSonSkorListesi[index];
                  String formattedDate = DateFormat(
                    'dd MMM - HH:mm:ss',
                    'tr',
                  ).format(skorKaydi.datetime);

                  final isTop3 = index < 3;
                  final String? medalEmoji = switch (index) {
                    0 => '🥇',
                    1 => '🥈',
                    2 => '🥉',
                    _ => null,
                  };

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500 + (index * 100)),
                        curve: Curves.easeOutBack,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color:
                                isTop3
                                    ? (index == 0
                                        ? Colors.amberAccent
                                        : Colors.white.withValues(alpha: 0.3))
                                    : Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white24,
                            child: Text(
                              medalEmoji ?? '👤',
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          title: Text(
                            'Kullanıcı Adı: ${skorKaydi.userName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '$formattedDate\nSkor: ${skorKaydi.scorePuan}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          isThreeLine: true,
                          trailing:
                              isTop3
                                  ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => Awards(
                                                skorKaydi: skorKaydi,
                                                siralama: index,
                                              ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.limeAccent.shade400,
                                      foregroundColor:
                                          Colors.deepPurple.shade800,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.yellow.shade700,
                                          width: 1.5,
                                        ),
                                      ),
                                      elevation: 6,
                                      animationDuration: const Duration(
                                        milliseconds: 150,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text('Ödülü Kap!'),
                                      ],
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                      if (isTop3 && index == 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Lottie.asset(
                                'assets/animations/star.json',
                                repeat: true,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
