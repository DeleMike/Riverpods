import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/data/notes.dart';

final notesProvider = StateNotifierProvider<NotesStateNotifier, List<Notes>>(
    (ref) => NotesStateNotifier());

class NotesStateNotifier extends StateNotifier<List<Notes>> {
  NotesStateNotifier() : super([]) {
    _fetchLocalNotes();
  }

  Future<Box<Notes>> get _openBox async {
    return await Hive.openBox<Notes>('notesBox');
  }

  void _fetchLocalNotes() async {
    debugPrint('Init notes');
    final notesBox = await _openBox;
    final notes = notesBox.values.toList();

    debugPrint('on init, empty? - ${notesBox.values.isEmpty}');

    state = [...state, ...notes];
  }

  /// Add a new note.
  Future<void> newNote(Notes newNote) async {
    final notesBox = await _openBox;

    await notesBox.add(newNote);
    debugPrint(notesBox.values.last.uuid.toString());

    state = [...state, newNote];
  }

  void updateNote(Notes existingNote) async {
    final notesBox = await _openBox;

    // get index of existing note in state
    final stateIndex = state.indexOf(state.reversed.firstWhere((note) {
      return note.uuid == existingNote.uuid;
    }));

    // change any param that changed
    state[stateIndex] = existingNote;
    debugPrint('StateIndex - $stateIndex');

    final indexStorage = notesBox.values.toList().indexOf(notesBox.values
        .toList()
        .firstWhere((element) => element.uuid == existingNote.uuid));

    debugPrint('index - $indexStorage');

    await notesBox.deleteAt(indexStorage);
    await notesBox.add(existingNote);

    debugPrint('local - ${notesBox.values.toList().length}');

    state = List.from(state);
  }

  void deleteNote(String uuid) async {
    final notesBox = await _openBox;

    final index = state.indexOf(state.firstWhere((note) {
      return note.uuid == uuid;
    }));

    final notesIndex = notesBox.values.toList().indexOf(state[index]);

    await notesBox.deleteAt(notesIndex);

    state.removeAt(index);
    state = List.from(state);
  }
}
