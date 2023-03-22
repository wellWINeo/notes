class Note {
  int id;
  String title;
  String description;
  String category;
  bool isDeleted = false;

  Note(this.id, this.title, this.description, this.category);

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['noteTitle'],
        description = json['noteDescription'],
        category = json['category'],
        isDeleted = json['isDeleted'];
}
