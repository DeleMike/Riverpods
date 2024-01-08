import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/notes/add_note_state_notifier.dart';
import 'package:notes_app/services/notes_controller.dart';

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
  late NoteController noteController;

  @override
  void initState() {
    super.initState();
    final notesNotifier = ref.read(notesProvider.notifier);
    noteController = NoteController(notesNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          IconButton(
              onPressed: () async {
                _formKey.currentState!.save();
                await noteController
                    .saveNote(context)
                    .then((value) => Navigator.of(context).pop());
              },
              icon: const Icon(Icons.save_rounded))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(
                  fontSize: 25.0, height: 2.0, color: Colors.black),
              decoration: const InputDecoration(hintText: 'Enter header'),
              onSaved: (value) {
                noteController.formData['title'] = value ?? '';
              },
            ),
            Expanded(
              child: SizedBox(
                height: height * 0.5, // <-- TextField height
                child: TextFormField(
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      filled: true, hintText: 'Enter a message'),
                  onSaved: (value) {
                    noteController.formData['details'] = value ?? '';
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
