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

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copy({required isFavorite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() {
    return 'Film(id: $id, title:$title, description:$description, isFavorite:$isFavorite)';
  }

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hashAll([id, isFavorite]);
}

const allFilms = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description: 'Description of the Shawshank Redemption',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'The GodFather',
    description: 'Description for the GodFather',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The GodFather: Part II',
    description: 'Description for the GodFather II',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'The Dark Knight',
    description: 'Description of the Dark Knight',
    isFavorite: false,
  ),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void updateFilm(Film film, bool isFavorite) {
    state = state
        .map((mFilm) =>
            mFilm.id == film.id ? mFilm.copy(isFavorite: isFavorite) : mFilm)
        .toList();
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

final favoriteStatusProvider = StateProvider<FavoriteStatus>((ref) {
  return FavoriteStatus.all;
});

final allFilmsProvider =
    StateNotifierProvider<FilmsNotifier, List<Film>>((ref) => FilmsNotifier());

final favoriteFilmProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where((mFilm) => mFilm.isFavorite),
);

final notFavoriteFilmProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where((mFilm) => !mFilm.isFavorite),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          const Center(child: FilterWidget()),
          Consumer(builder: (contex, ref, _) {
            final filter = ref.watch(favoriteStatusProvider);

            switch (filter) {
              case FavoriteStatus.all:
                return FilmsList(
                  provider: allFilmsProvider,
                );
                case FavoriteStatus.favorite:
                return FilmsList(
                  provider: favoriteFilmProvider,
                );
                case FavoriteStatus.notFavorite:
                return FilmsList(
                  provider: notFavoriteFilmProvider,
                );
            
            }
          }),
        ],
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton(
          value: ref.watch(favoriteStatusProvider),
          items: FavoriteStatus.values
              .map(
                (status) => DropdownMenuItem<FavoriteStatus>(
                  value: status,
                  child: Text(status.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            ref.watch(favoriteStatusProvider.notifier).state = value!;
          },
        );
      },
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsList({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
        child: ListView.builder(
      itemBuilder: (ctx, index) {
        final film = films.elementAt(index);
        final favoriteIcon = film.isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(
                Icons.favorite_border,
              );
        return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              icon: favoriteIcon,
              onPressed: () {
                final isFavorite = !film.isFavorite;
                ref
                    .read(allFilmsProvider.notifier)
                    .updateFilm(film, isFavorite);
              },
            ));
      },
      itemCount: films.length,
    ));
  }
}
