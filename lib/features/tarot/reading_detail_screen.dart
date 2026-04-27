import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/reading_model.dart';
import '../../core/theme/app_theme.dart';
import 'tarot_helpers.dart';

class ReadingDetailScreen extends StatelessWidget {
  final TarotReading reading;

  const ReadingDetailScreen({super.key, required this.reading});

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final energyColor = getEnergyColor(reading.energy);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "✦ Detail Ramalan ✦",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: AppColors.stardustPink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card with question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.nebulaPurple,
                    AppColors.mysticIndigo,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.stardustPink.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.stardustPink.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        getSpreadEmoji(reading.spreadType),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        getSpreadLabel(reading.spreadType),
                        style: const TextStyle(
                          color: AppColors.astraMauve,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: energyColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: energyColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          getEnergyLabel(reading.energy),
                          style: TextStyle(
                            color: energyColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Pertanyaan",
                    style: TextStyle(
                      color: AppColors.astraMauve,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '"${reading.question}"',
                    style: const TextStyle(
                      color: AppColors.moonGlow,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formatDate(reading.createdAt),
                    style: const TextStyle(
                      color: AppColors.astraMauve,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Cards drawn
            _sectionTitle("🃏 Kartu yang Ditarik"),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reading.cardsDrawn.length,
                itemBuilder: (context, index) {
                  final card = reading.cardsDrawn[index];
                  final cardColor = getCardColor(card.name);
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cardColor.withValues(alpha: 0.15),
                          AppColors.cosmicPurple,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cardColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getCardEmoji(card.name),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          card.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cardColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.position,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.astraMauve,
                            fontSize: 10,
                          ),
                        ),
                        if (card.reversed)
                          const Text(
                            "↓ Terbalik",
                            style: TextStyle(
                              color: AppColors.challenging,
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Interpretation
            _sectionTitle("🔮 Interpretasi"),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cosmicPurple,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.astraMauve.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                reading.interpretation,
                style: const TextStyle(
                  color: AppColors.moonGlow,
                  fontSize: 14,
                  height: 1.8,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Card meanings
            if (reading.cardMeanings.isNotEmpty) ...[
              _sectionTitle("✦ Makna Tiap Kartu"),
              const SizedBox(height: 12),
              ...reading.cardMeanings.map((cm) {
                final cardColor = getCardColor(cm.card);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cosmicPurple,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cardColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            getCardEmoji(cm.card),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cm.card,
                              style: TextStyle(
                                color: cardColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            cm.position,
                            style: const TextStyle(
                              color: AppColors.astraMauve,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cm.meaning,
                        style: const TextStyle(
                          color: AppColors.moonGlow,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 12),

            // Advice
            if (reading.advice.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.goldAccent.withValues(alpha: 0.15),
                      AppColors.cosmicPurple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.goldAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text("🌟", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text(
                          "Pesan Bintang",
                          style: TextStyle(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reading.advice,
                      style: const TextStyle(
                        color: AppColors.moonGlow,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.stardustPink,
        letterSpacing: 0.5,
      ),
    );
  }
}
