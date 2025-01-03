import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  void saveNote() async {
    final supabase = Supabase.instance.client;
    final note =
        await supabase.from('notes').insert({'body': textController.text});
    print(note);
  }

  void addNewNote() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: Text('Add New Note'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          TextButton(
            onPressed: () => {saveNote(), Navigator.pop(context)},
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewNote(),
        child: Icon(Icons.add),
      ),
    );
  }
}
