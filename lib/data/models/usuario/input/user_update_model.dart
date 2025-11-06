class UsuarioUpdateModel {
  final String nombre;
  final String email;
  final String estado;
  UsuarioUpdateModel({required this.nombre, required this.email, required this.estado});
  factory UsuarioUpdateModel.fromJson(Map<String, dynamic> j) =>
      UsuarioUpdateModel(nombre: j['nombre'], email: j['email'], estado: j['estado'] ?? '');
  Map<String, dynamic> toJson() => {'nombre': nombre, 'email': email,'estado': estado.toLowerCase()};
}
