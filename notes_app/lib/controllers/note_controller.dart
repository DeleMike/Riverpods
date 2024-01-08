import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_manager.dart';
import 'package:notes_app/data/notes.dart';
import 'package:uuid/uuid.dart';

class NoteController implements NoteManager {
  Map<String, dynamic> notesData = {};
  
  @override
  Notes? addNote() {
    final String title = notesData['title'] ?? '';
    final String details = notesData['details'] ?? '';
    final labels = notesData['label'];

    if (title.isEmpty && details.isEmpty) {
      // do not allow creation
      print('Cannot Create Note. You must fill in one of title or details');
      return null;
    } else {
      // creata a note id
      final uuid = const Uuid().v4();

      //create a note
      return Notes(uuid: uuid, title: title, details: details, label: labels);
    }
  }

  @override
  void deleteNote() {
    // TODO: implement deleteNote
  }

  @override
  void editNote() {
    // TODO: implement editNote
  }

  @override
  void getNotes() {}
}
