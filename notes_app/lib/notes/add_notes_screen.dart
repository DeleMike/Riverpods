import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/data/notes.dart';
import 'package:notes_app/notes/add_note_state_notifier.dart';
import 'package:notes_app/services/notes_controller.dart';

class AddNotesScreen extends ConsumerStatefulWidget {
  const AddNotesScreen(
      {super.key, this.title, this.details, this.note, this.tag = 'create'});

  final String? title;
  final String? details;
  final String tag;
  final Notes? note;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends ConsumerState<AddNotesScreen> {
  final _formKey = GlobalKey<FormState>();
  late NoteController noteController;

  final titleController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final notesNotifier = ref.read(notesProvider.notifier);
    noteController = NoteController(notesNotifier);
    titleController.text = widget.title ?? '';
    detailsController.text = widget.details ?? '';
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

                if (widget.tag.toLowerCase() == 'update') {
                  if (widget.note != null) {
                    final updatedNote = widget.note!
                        .updated(titleController.text, detailsController.text);
                    await noteController
                        .editNote(context, updatedNote)
                        .then((value) => Navigator.of(context).pop());
                  }
                } else {
                  await noteController
                      .saveNote(context)
                      .then((value) => Navigator.of(context).pop());
                }
              },
              icon: const Icon(Icons.save_rounded))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
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
                  controller: detailsController,
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
