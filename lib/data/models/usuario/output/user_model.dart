class UsuarioModel {
  final String id;
  final String nombre;
  final String email;
  UsuarioModel({required this.id, required this.nombre, required this.email});
  factory UsuarioModel.fromJson(Map<String, dynamic> j) =>
      UsuarioModel(id: '${j['id']}', nombre: j['nombre'], email: j['email']);
  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre, 'email': email};
}
