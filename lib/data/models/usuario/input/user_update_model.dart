class UsuarioUpdateModel {
  final String nombre;
  final String email;
  UsuarioUpdateModel({required this.nombre, required this.email});
  factory UsuarioUpdateModel.fromJson(Map<String, dynamic> j) =>
      UsuarioUpdateModel(nombre: j['nombre'], email: j['email']);
  Map<String, dynamic> toJson() => {'nombre': nombre, 'email': email};
}
