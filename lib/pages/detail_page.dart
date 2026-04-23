

import 'package:flutter/material.dart';
import '../models/note.dart';
import 'create_page.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;

  const DetailNotePage({Key? key, required this.note}) : super(key: key);

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  Color hexToColor(String hex) {
    return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year} à "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _modifierNote() async {
    final noteModifiee = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateNotePage(noteAModifier: _note)),
    );

    if (noteModifiee != null && noteModifiee is Note) {
      setState(() {
        _note = noteModifiee;
      });

      Navigator.pop(context, {'action': 'modified', 'note': noteModifiee}); // ✅
    }
  }

  Future<void> _supprimerNote() async {
    final confirmation = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: const Text("Voulez-vous vraiment supprimer cette note ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      Navigator.pop(context, {'action': 'deleted'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(_note.couleur),
        title: const Text("Détail Note"),
        actions: [
          IconButton(onPressed: _modifierNote, icon: const Icon(Icons.edit)),
          IconButton(onPressed: _supprimerNote, icon: const Icon(Icons.delete)),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _note.titre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              "Créée le : ${formatDate(_note.dateCreation)}",
              style: const TextStyle(color: Colors.grey),
            ),

            if (_note.dateModification != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "Modifiée le : ${formatDate(_note.dateModification!)}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _note.contenu,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
