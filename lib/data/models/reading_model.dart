class TarotCard {
  final String name;
  final String position;
  final bool reversed;

  TarotCard({
    required this.name,
    required this.position,
    required this.reversed,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      reversed: json['reversed'] ?? false,
    );
  }
}

class CardMeaning {
  final String card;
  final String position;
  final bool reversed;
  final String meaning;

  CardMeaning({
    required this.card,
    required this.position,
    required this.reversed,
    required this.meaning,
  });

  factory CardMeaning.fromJson(Map<String, dynamic> json) {
    return CardMeaning(
      card: json['card'] ?? '',
      position: json['position'] ?? '',
      reversed: json['reversed'] ?? false,
      meaning: json['meaning'] ?? '',
    );
  }
}

class TarotReading {
  final int id;
  final String question;
  final String spreadType;
  final List<TarotCard> cardsDrawn;
  final String interpretation;
  final List<CardMeaning> cardMeanings;
  final String advice;
  final String energy;
  final String createdAt;

  TarotReading({
    required this.id,
    required this.question,
    required this.spreadType,
    required this.cardsDrawn,
    required this.interpretation,
    required this.cardMeanings,
    required this.advice,
    required this.energy,
    required this.createdAt,
  });

  factory TarotReading.fromJson(Map<String, dynamic> json) {
    return TarotReading(
      id: json['id'],
      question: json['question'] ?? '',
      spreadType: json['spread_type'] ?? 'three_card',
      cardsDrawn: (json['cards_drawn'] as List<dynamic>? ?? [])
          .map((e) => TarotCard.fromJson(e))
          .toList(),
      interpretation: json['interpretation'] ?? '',
      cardMeanings: (json['card_meanings'] as List<dynamic>? ?? [])
          .map((e) => CardMeaning.fromJson(e))
          .toList(),
      advice: json['advice'] ?? '',
      energy: json['energy'] ?? 'neutral',
      createdAt: json['created_at'] ?? '',
    );
  }
}
