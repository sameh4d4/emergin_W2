class popActor {
  final int id;
  final String nama;

  popActor({required this.id, required this.nama});
  factory popActor.fromJson(Map<String, dynamic> json) {
    return popActor(
      id: json['person_id'],
      nama: json['person_name'],
    );
  }
}