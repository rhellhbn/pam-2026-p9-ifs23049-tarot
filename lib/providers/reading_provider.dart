import 'package:flutter/material.dart';
import '../data/models/reading_model.dart';
import '../data/services/reading_service.dart';

class ReadingProvider extends ChangeNotifier {
  List<TarotReading> readings = [];
  int page = 1;
  bool isLoading = false;
  bool isGenerating = false;
  bool hasMore = true;
  String? errorMessage;

  void reset() {
    readings = [];
    page = 1;
    hasMore = true;
    errorMessage = null;
  }

  Future<void> fetchReadings(String token) async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await ReadingService.getReadings(token, page);
      final List data = result['data'];

      if (data.isEmpty) {
        hasMore = false;
      } else {
        readings.addAll(data.map((e) => TarotReading.fromJson(e)).toList());
        page++;
      }
    } catch (e) {
      errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TarotReading?> generateReading(
      String token, String question, String spreadType) async {
    isGenerating = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await ReadingService.generateReading(token, question, spreadType);
      final reading = TarotReading.fromJson(result['data']);

      reset();
      await fetchReadings(token);

      return reading;
    } catch (e) {
      errorMessage = e.toString().replaceFirst("Exception: ", "");
      return null;
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> deleteReading(String token, int readingId) async {
    try {
      await ReadingService.deleteReading(token, readingId);
      readings.removeWhere((r) => r.id == readingId);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
    }
  }
}
