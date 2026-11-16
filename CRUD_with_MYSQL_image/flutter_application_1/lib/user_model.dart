class User {
  final int id;
  final String name;
  final String email;
  final String? foto; // Field baru untuk foto

  User({required this.id, required this.name, required this.email, this.foto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']), // Konversi String ke int
      name: json['name'],
      email: json['email'],
      foto: json['foto'], // Ambil path foto dari JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'foto': foto,
    };
  }
}