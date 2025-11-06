class ProductoModel {
  final String id;
  final DateTime fechaCreacion;
  final bool esCaro;
  final String diagrama; // lo tratamos como string, no lo parseamos todavía
  final String nombre;
  final double precio;
  final String estado;
  final DateTime? fechaEliminacion;

  ProductoModel({
    required this.id,
    required this.fechaCreacion,
    required this.esCaro,
    required this.diagrama,
    required this.nombre,
    required this.precio,
    required this.estado,
    required this.fechaEliminacion,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> j) => ProductoModel(
    id: '${j['id']}',
    fechaCreacion: DateTime.parse(j['fecha_creacion']),
    esCaro: j['es_caro'] ?? false,
    diagrama: j['diagrama'] ?? '',
    nombre: j['nombre'] ?? '',
    precio: (j['precio'] as num?)?.toDouble() ?? 0.0,
    estado: j['estado'] ?? '',
    fechaEliminacion: j['deletedAt'] != null ? DateTime.parse(j['deletedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fecha_creacion': fechaCreacion.toIso8601String(),
    'es_caro': esCaro,
    'diagrama': diagrama,
    'nombre': nombre,
    'precio': precio,
    'estado': estado,
  };
}
