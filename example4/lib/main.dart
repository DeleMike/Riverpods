import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ilena',
  'Joseph',
  'Kincaid',
  'Larry'
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider((ref) =>
    ref.watch(tickerProvider.stream).map((count) => names.getRange(0, count)));

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stream Provider')),
      body: names.when(
          data: (data) {
            final data_ = data.toList();
            return ListView.builder(
              itemBuilder: (ctx, index) => ListTile(
                title: Text(data_[index]),
              ),
              itemCount: data_.length,
            );
          },
          error: (_, __) => const Text('End of list reached'),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
