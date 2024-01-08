import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/notes/get_quote_screen.dart';

import 'notes/add_note_state_notifier.dart';
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
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetQuoteScreen()));
              },
              icon: const Icon(Icons.content_paste_go_outlined))
        ],
      ),
      body: notes.isEmpty
          ? const SizedBox(
              child: Center(
                  child: Text(
                'No notes yet!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              )),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                Notes note = notesBox.getAt(index);
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNotesScreen(
                                  title: note.title,
                                  details: note.details,
                                  tag: 'update',
                                  note: note,
                                )));
                  },
                  title: Text(note.title ?? ''),
                  subtitle: Text(note.details ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(notesProvider.notifier).deleteNote(note.uuid);
                    },
                  ),
                );
              },
              itemCount: notes.length,
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
