class Note {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String titre;
  String contenu;
  String couleur;
  DateTime dateCreation;
  DateTime? dateModification;


  Note({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.couleur,
    required this.dateCreation,
    this.dateModification,
  });
}