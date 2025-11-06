class ProductoUpdateModel {
  final DateTime fechaCreacion;
  final bool esCaro;
  final String diagrama;
  final String nombre;
  final double precio;
  final String estado;

  ProductoUpdateModel({
    required this.fechaCreacion,
    required this.esCaro,
    required this.diagrama,
    required this.nombre,
    required this.precio,
    required this.estado,
  });

  factory ProductoUpdateModel.fromJson(Map<String, dynamic> j) =>
      ProductoUpdateModel(
        fechaCreacion: DateTime.parse(j['fecha_creacion']),
        esCaro: j['es_caro'] ?? false,
        diagrama: j['diagrama'] ?? '',
        nombre: j['nombre'] ?? '',
        precio: (j['precio'] as num?)?.toDouble() ?? 0.0,
        estado: j['estado'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'fecha_creacion': fechaCreacion.toIso8601String(),
    'es_caro': esCaro,
    'diagrama': diagrama,
    'nombre': nombre,
    'precio': precio,
    'estado': estado.toLowerCase(),
  };
}
