import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef WeatherEmoji = String;

enum City {
  stockholm,
  paris,
  tokyo,
}

const unknownWeatherEmoji = '🤷🏾‍♂️';

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

final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  }
  return unknownWeatherEmoji;
});

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Column(
        children: [
          weather.when(
              data: (data) => Text(
                    data,
                    style: const TextStyle(fontSize: 50),
                  ),
              error: (_, __) => const Text(
                    unknownWeatherEmoji,
                    style: TextStyle(fontSize: 50),
                  ),
              loading: () => const CircularProgressIndicator()),
          Expanded(
            child: ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (ctx, index) {
                  final city = City.values[index];
                  final isSelected = city == ref.watch(currentCityProvider);

                  return ListTile(
                    title: Text(
                      city.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () =>
                        ref.read(currentCityProvider.notifier).state = city,
                  );
                }),
          )
        ],
      ),
    );
  }
}
