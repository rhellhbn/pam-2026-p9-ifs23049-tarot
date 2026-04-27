import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Returns color based on card suit/type
Color getCardColor(String cardName) {
  if (_isMajorArcana(cardName)) return AppColors.major;
  if (cardName.contains('Wands')) return AppColors.wands;
  if (cardName.contains('Cups')) return AppColors.cups;
  if (cardName.contains('Swords')) return AppColors.swords;
  if (cardName.contains('Pentacles')) return AppColors.pentacles;
  return AppColors.astraMauve;
}

bool _isMajorArcana(String name) {
  const majorCards = [
    'The Fool', 'The Magician', 'The High Priestess', 'The Empress',
    'The Emperor', 'The Hierophant', 'The Lovers', 'The Chariot',
    'Strength', 'The Hermit', 'Wheel of Fortune', 'Justice',
    'The Hanged Man', 'Death', 'Temperance', 'The Devil',
    'The Tower', 'The Star', 'The Moon', 'The Sun',
    'Judgement', 'The World',
  ];
  return majorCards.contains(name);
}

String getCardEmoji(String cardName) {
  if (_isMajorArcana(cardName)) return '★';
  if (cardName.contains('Wands')) return '🔥';
  if (cardName.contains('Cups')) return '💧';
  if (cardName.contains('Swords')) return '⚡';
  if (cardName.contains('Pentacles')) return '🌿';
  return '✦';
}

Color getEnergyColor(String energy) {
  switch (energy) {
    case 'positive':
      return AppColors.positive;
    case 'challenging':
      return AppColors.challenging;
    case 'transformative':
      return AppColors.transformative;
    default:
      return AppColors.neutral;
  }
}

String getEnergyLabel(String energy) {
  switch (energy) {
    case 'positive':
      return '✨ Positif';
    case 'challenging':
      return '⚡ Menantang';
    case 'transformative':
      return '🌙 Transformatif';
    default:
      return '☯ Netral';
  }
}

String getSpreadLabel(String spreadType) {
  switch (spreadType) {
    case 'single':
      return 'Kartu Tunggal';
    case 'three_card':
      return '3 Kartu';
    case 'celtic_cross':
      return 'Celtic Cross';
    default:
      return spreadType;
  }
}

String getSpreadEmoji(String spreadType) {
  switch (spreadType) {
    case 'single':
      return '🃏';
    case 'three_card':
      return '🔮';
    case 'celtic_cross':
      return '✝';
    default:
      return '✦';
  }
}
