
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../services/note_service.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';

  Color hexToColor(String couleur) {
    return Color(
      int.parse(
        'FF${couleur.replaceAll('#', '')}',
        radix: 16,
      ),
    );
  }

  Future<void> _ouvrirCreatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateNotePage(),
      ),
    );

    if (result != null && result is Note) {
      context.read<NoteService>().addNote(result);
    }
  }

  Future<void> _ouvrirDetailPage(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailNotePage(
          note: note,
        ),
      ),
    );

    if (result != null && result is Map) {
      final action = result['action'];

      if (action == 'deleted') {
        context.read<NoteService>().deleteNote(note.id);
      }

      if (action == 'modified') {
        final Note noteModifiee = result['note'];
        context.read<NoteService>().updateNote(noteModifiee);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<NoteService>();

    final notes = _query.isEmpty
        ? service.notes
        : service.search(_query);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Bloc-Notes (${service.notes.length})",
        ),
        centerTitle: true,

        actions: [
          PopupMenuButton<TypeTri>(
            icon: const Icon(Icons.sort),

            onSelected: (tri) {
              context
                  .read<NoteService>()
                  .setTri(tri);
            },

            itemBuilder: (_) => const [
              PopupMenuItem(
                value: TypeTri.dateRecent,
                child: Text(
                  "Date (récent d'abord)",
                ),
              ),

              PopupMenuItem(
                value: TypeTri.dateAncien,
                child: Text(
                  "Date (ancien d'abord)",
                ),
              ),

              PopupMenuItem(
                value: TypeTri.titreAZ,
                child: Text(
                  "Titre A → Z",
                ),
              ),

              PopupMenuItem(
                value: TypeTri.titreZA,
                child: Text(
                  "Titre Z → A",
                ),
              ),
            ],
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher une note...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      body: notes.isEmpty
          ? const Center(
        child: Text(
          "Aucune note",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: hexToColor(note.couleur),
                    width: 4,
                  ),
                ),
              ),
              child: ListTile(
                onTap: () =>
                    _ouvrirDetailPage(note),

                title: Text(
                  note.titre,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                ),

                subtitle: Text(
                  note.contenu,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }
}