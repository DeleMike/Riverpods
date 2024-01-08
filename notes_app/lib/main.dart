import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/data/notes.dart';

import 'notes/add_notes_screen.dart';
import 'services/boxes.dart';

const databaseName = 'notesBox';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  notesBox = await Hive.openBox<Notes>(databaseName);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData.light(),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Notes'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Notes note = notesBox.getAt(index);
          return ListTile(
            title: Text(note.title ?? ''),
            subtitle: Text(note.details ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          );
        },
        itemCount: notesBox.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNotesScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
