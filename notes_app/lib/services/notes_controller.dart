import 'package:flutter/material.dart'
    show BuildContext, ScaffoldMessenger, SnackBar, Text, debugPrint;
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/notes/add_note_state_notifier.dart';
import 'package:uuid/uuid.dart';

class NoteController {
  late NotesStateNotifier notesStateNotifier;
  NoteController(this.notesStateNotifier);

  Map<String, dynamic> formData = {};

  Future<void> saveNote(BuildContext context) async {
    if (formData['title'].toString().isEmpty &&
        formData['details'].toString().isEmpty) {
      // we cannot save a note that is empty
      debugPrint('Cannot save empty note');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('We cannot save an empty list')));
    } else {
      // save note
      // form note model
      final note = Notes(
        title: formData['title'],
        details: formData['details'],
        label: const [],
        uuid: const Uuid().v4(),
      );

      notesStateNotifier.newNote(note);
    }
  }
}
