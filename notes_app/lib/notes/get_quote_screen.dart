import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/get_random_quote_service.dart';

final getQuoteProvider = FutureProvider.autoDispose<Suggestion>((ref) {
  final api = ref.watch(randomQuoteServiceProvider);
  return api.getSuggestion();
});

class GetQuoteScreen extends ConsumerWidget {
  const GetQuoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(getQuoteProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Random Quote')),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(getQuoteProvider.future),
          child: ListView(
            children: [
              quotes.when(data: (data) {
                return Text(
                  data.activity,
                  style: Theme.of(context).textTheme.headline4,
                );
              }, error: (error, _) {
                return Text(error.toString());
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              }),
            ],
          ),
        ),
      ),
    );
  }
}
