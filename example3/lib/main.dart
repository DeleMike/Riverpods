import 'package:example3/weather.dart';
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
      home: const WeatherPage(),
    );
  }
}

typedef WeatherEmoji = String;

enum City {
  stockholm,
  paris,
  tokyo,
}

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stockholm: '❄️',
      City.paris: '⛈️',
      City.tokyo: '💨',
    }[city]!,
  );
}

const unknownWeatherEmoji = '🤷🏾‍♂️';

final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji?>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  }

  return unknownWeatherEmoji;
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) {
              return Text(data ?? '', style: const TextStyle(fontSize: 50));
            },
            error: (error, _) {
              return const Text('🤷🏾‍♂️');
            },
            loading: () => const CircularProgressIndicator(),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) {
              final city = City.values[index];
              final isSelected = city == ref.watch(currentCityProvider);
              return ListTile(
                title: Text(city.name),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  ref.read(currentCityProvider.notifier).state = city;
                },
              );
            },
            itemCount: City.values.length,
          ))
        ],
      ),
    );
  }
}
