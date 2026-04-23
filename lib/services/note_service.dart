
import 'package:flutter/material.dart';
import '../models/note.dart';

enum TypeTri {
  dateRecent,
  dateAncien,
  titreAZ,
  titreZA,
}

class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];

  TypeTri _tri = TypeTri.dateRecent;

  TypeTri get tri => _tri;

  List<Note> get notes {
    final liste = List<Note>.from(_notes);

    switch (_tri) {
      case TypeTri.dateRecent:
        liste.sort(
              (a, b) => b.dateCreation.compareTo(a.dateCreation),
        );
        break;

      case TypeTri.dateAncien:
        liste.sort(
              (a, b) => a.dateCreation.compareTo(b.dateCreation),
        );
        break;

      case TypeTri.titreAZ:
        liste.sort(
              (a, b) => a.titre.toLowerCase().compareTo(
            b.titre.toLowerCase(),
          ),
        );
        break;

      case TypeTri.titreZA:
        liste.sort(
              (a, b) => b.titre.toLowerCase().compareTo(
            a.titre.toLowerCase(),
          ),
        );
        break;
    }

    return liste;
  }

  void setTri(TypeTri nouveauTri) {
    _tri = nouveauTri;
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }


  void updateNote(Note noteModifiee) {
    final index = _notes.indexWhere(
          (n) => n.id == noteModifiee.id,
    );

    if (index != -1) {
      _notes[index] = noteModifiee;
      notifyListeners();
    }
  }


  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }


  List<Note> search(String query) {
    if (query.trim().isEmpty) {
      return notes;
    }

    final q = query.toLowerCase();

    return notes.where((note) {
      return note.titre
          .toLowerCase()
          .contains(q) ||
          note.contenu
              .toLowerCase()
              .contains(q);
    }).toList();
  }


  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere(
            (n) => n.id == id,
      );
    } catch (e) {
      return null;
    }
  }
}