class UsuarioModel {
  final int id;
  final String nombre;
  final String email;
  final String estado;
  final DateTime? fechaEliminacion;
  UsuarioModel({required this.id, required this.nombre, required this.email,required this.estado, this.fechaEliminacion});
  factory UsuarioModel.fromJson(Map<String, dynamic> j) => UsuarioModel(
    id: (j['id'] as num?)?.toInt() ?? 0,
    //(j['precio'] as num?)?.toDouble() ?? 0.0,
    nombre: j['nombre'],
    email: j['email'],
    estado: j['estado'] ?? '',
    fechaEliminacion: j['deletedAt'] != null ? DateTime.parse(j['deletedAt']) : null,
  );
  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre, 'email': email};
  @override
  String toString() => '[$id, $nombre, $email]';

  String toStringModified({int maxLength = 25}) {
    final raw = '[$id, $nombre, $email]';
    return (raw.length > maxLength) ? '${raw.substring(0, maxLength)}...' : raw;
  }
}
