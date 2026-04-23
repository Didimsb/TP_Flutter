

import 'package:flutter/material.dart';
import '../models/note.dart';

class CreateNotePage extends StatefulWidget {
  final Note? noteAModifier;

  const CreateNotePage({
    Key? key,
    this.noteAModifier,
  }) : super(key: key);

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();

  String _couleurSelectionnee = '#FFE082';

  final List<String> _couleurs = [
    '#FFE082',
    '#FFAB91',
    '#80DEEA',
    '#A5D6A7',
    '#CE93D8',
    '#90CAF9',
  ];

  @override
  void initState() {
    super.initState();

    // Mode modification
    if (widget.noteAModifier != null) {
      _titreController.text = widget.noteAModifier!.titre;
      _contenuController.text = widget.noteAModifier!.contenu;
      _couleurSelectionnee = widget.noteAModifier!.couleur;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Color hexToColor(String hex) {
    return Color(
      int.parse(
        'FF${hex.replaceAll('#', '')}',
        radix: 16,
      ),
    );
  }

  void _sauvegarderNote() {
    if (_titreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Le titre est obligatoire"),
        ),
      );
      return;
    }

    final note = Note(
      id: widget.noteAModifier?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      titre: _titreController.text.trim(),
      contenu: _contenuController.text.trim(),
      couleur: _couleurSelectionnee,
      dateCreation:
      widget.noteAModifier?.dateCreation ?? DateTime.now(),
      dateModification:
      widget.noteAModifier != null ? DateTime.now() : null,
    );

    Navigator.pop(context, note);
  }

  Widget _buildColorItem(String couleur) {
    final bool selectionnee =
        couleur == _couleurSelectionnee;

    return GestureDetector(
      onTap: () {
        setState(() {
          _couleurSelectionnee = couleur;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: hexToColor(couleur),
          shape: BoxShape.circle,
          border: Border.all(
            color: selectionnee
                ? Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: selectionnee
            ? const Icon(
          Icons.check,
          size: 18,
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool modeModification =
        widget.noteAModifier != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          modeModification
              ? "Modifier la note"
              : "Nouvelle note",
        ),
        actions: [
          IconButton(
            onPressed: _sauvegarderNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: "Titre",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _contenuController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: "Contenu",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choisir une couleur",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: _couleurs
                  .map((c) => _buildColorItem(c))
                  .toList(),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sauvegarderNote,
                icon: const Icon(Icons.save),
                label: const Text("Sauvegarder"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}