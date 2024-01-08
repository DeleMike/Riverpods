import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final randomQuoteServiceProvider =
    Provider<RandomQuoteApiService>((ref) => RandomQuoteApiService());

class RandomQuoteApiService {
  Future<Suggestion> getSuggestion() async {
    try {
      final res = await Dio().get('https://www.boredapi.com/api/activity');
      return Suggestion.fromJson(res.data);
    } catch (e) {
      throw Exception('Error getting suggestion');
    }
  }
}

class Suggestion {
  Suggestion({
    required this.activity,
    required this.type,
  });

  final String activity;
  final String type;

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      Suggestion(activity: json["activity"], type: json["type"]);
}
