import 'package:flutter/material.dart';

class InformationQuizIntro extends StatelessWidget {
  final List<Map<String, dynamic>> rules = [
    {
      "emoji": "👤",
      "text": "Misafir oyuncu oyunu oynayabilir ancak skor tablosunu göremez.",
    },

    {"emoji": "✔️", "text": "Her doğru cevap 10 puan kazandırır."},
    {
      "emoji": "❌",
      "text": "Yanlış cevapta elenirsin, puanın geçerli sayılmaz.",
    },
    {"emoji": "⏱️", "text": "Soru başına 40 saniye süren var."},
    {"emoji": "🏆", "text": "En yüksek puanını hedefle!"},

    {
      "emoji": "🥇",
      "text": "Altın, gümüş ve bronz madalya ile en iyi 3 skor ödüllendirilir.",
    },
    {"emoji": "📈", "text": "Skor tablosunda zirveye adını yazdır."},
    {"emoji": "🎯", "text": "Sorular rastgele sırayla karşına çıkacaktır."},
    {
      "emoji": "🧠",
      "text":
          "Sorular kategorilere göre hazırlanmıştır. Zorluk seviyesi kolaydan zora doğrudur ve sorular her oyunda rastgele sırayla gelir.",
    },
    {"emoji": "💡", "text": "Hızlı düşün ve doğru cevabı ver!"},

    // Joker tanımı
    {
      "emoji": "🃏",
      "text":
          "50:50, çift cevap ve soru atlama olmak üzere 3 farklı joker hakkın var.",
    },
    {"emoji": "🚫", "text": "Her joker yalnızca bir kez kullanılabilir."},

    // Joker açıklamaları
    {
      "emoji": Image.asset('assets/icons/fifty.png', width: 32, height: 32),
      "text": "50:50 jokeri ile iki yanlış şık elenir.",
    },
    {
      "emoji": Image.asset('assets/icons/double.png', width: 32, height: 32),
      "text":
          "Çift cevap jokeri: Bir soruda iki farklı cevap deneme hakkı verir.",
    },
    {
      "emoji": Image.asset('assets/icons/skip.png', width: 32, height: 32),
      "text":
          "Soru atlama jokeri: Bir soruyu pas geçip sonraya bırakmanı sağlar.",
    },

    // ✅ Yeni ek kurallar
    {
      "emoji": "☠️",
      "text": "Cevabını onayladıktan sonra geri dönüş yok, dikkatli seç!",
    },
    {
      "emoji": "⏳",
      "text":
          " Zamanı kaçırma! Süre dolduğunda cevap vermezsen, skorun geçersiz sayılır.",
    },
  ];

  InformationQuizIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        centerTitle: true,
        title: Text(
          "📌 Oyun Kuralları",
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 2),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: rules.length,
          separatorBuilder: (context, index) => Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            final rule = rules[index];
            return Card(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.white24),
              ),
              elevation: 4,
              child: ListTile(
                leading:
                    rule["emoji"] is String
                        ? Text(rule["emoji"], style: TextStyle(fontSize: 24))
                        : rule["emoji"],
                title: Text(
                  rule["text"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
