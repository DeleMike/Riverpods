import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';

class NotesStateNotifier extends StateNotifier<List<Notes>> {
  NotesStateNotifier() : super([]);

  /// READ
  /// get all notes in the database and add it to the state
  void getNotes() {}

  /// CREATE
  /// add a note to the database and update the state
  void addNotes(Notes note) {}

  /// UPDATE
  /// update a note in the database and update the state too
  void updateNotes(Notes note) {}

  /// DELETE
  /// delete a note in the database and update the state too
  void deleteNote(Notes note) {}

  void clearCart() {
    state = [];
  }
}
