class UsuarioCreateModel {
  final String nombre;
  final String email;
  UsuarioCreateModel({required this.nombre, required this.email});
  factory UsuarioCreateModel.fromJson(Map<String, dynamic> j) =>
      UsuarioCreateModel(nombre: j['nombre'], email: j['email']);
  Map<String, dynamic> toJson() => {'nombre': nombre, 'email': email};
}
