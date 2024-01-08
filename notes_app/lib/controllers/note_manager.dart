import '../data/notes.dart';

abstract class NoteManager {
  /// read
  void getNotes();

  ///add
  Notes? addNote();

  ///edit
  void editNote();

  ///delete
  void deleteNote();
}
