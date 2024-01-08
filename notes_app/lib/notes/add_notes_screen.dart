import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/controllers/note_controller.dart';

import 'add_note_state_notifier.dart';

class Hello extends ConsumerStatefulWidget {
  const Hello({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelloState();
}

class _HelloState extends ConsumerState<Hello> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AddNotesScreen extends ConsumerStatefulWidget {
  const AddNotesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends ConsumerState<AddNotesScreen> {
  final _formKey = GlobalKey<FormState>();
  NoteController noteController = NoteController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final notes = ref.watch(noteStateNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          IconButton(
              onPressed: () {
                _formKey.currentState!.save();

                // get values
                noteController.addNote();
              },
              icon: const Icon(Icons.save_rounded))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style:
                  TextStyle(fontSize: 25.0, height: 2.0, color: Colors.black),
              decoration: InputDecoration(hintText: 'Enter header'),
              onSaved: (value) {
                noteController.notesData['title'] = value;
              },
            ),
            Expanded(
              child: SizedBox(
                height: height * 0.5, // <-- TextField height
                child: TextFormField(
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      filled: true, hintText: 'Enter a message'),
                  onSaved: (value) {
                    noteController.notesData['details'] = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
