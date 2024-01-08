import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';

final noteStateNotifierProvider =
    StateNotifierProvider.autoDispose<NotesStateNotifier, List<Notes>>(
        (ref) => NotesStateNotifier());

class NotesStateNotifier extends StateNotifier<List<Notes>> {
  NotesStateNotifier() : super([]);

  /// READ
  /// get all notes in the database and add it to the state
  void getNotes() {
    // use the controller to get notes.
    // update the state here
  }

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
