import 'package:flutter/material.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          IconButton(
              onPressed: () {
                print('Save me');
              },
              icon: const Icon(Icons.save_rounded))
        ],
      ),
      body: Column(children: [
        const TextField(
          style: TextStyle(fontSize: 25.0, height: 2.0, color: Colors.black),
          decoration: InputDecoration(hintText: 'Enter header'),
        ),
        Expanded(
          child: SizedBox(
            height: height, // <-- TextField height
            child: const TextField(
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              decoration:
                  InputDecoration(filled: true, hintText: 'Enter a message'),
            ),
          ),
        )
      ]),
    );
  }
}
