class ProductoCreateModel {
  final DateTime fechaCreacion;
  final bool esCaro;
  final String diagrama;
  final String nombre;
  final double precio;

  ProductoCreateModel({
    required this.fechaCreacion,
    required this.esCaro,
    required this.diagrama,
    required this.nombre,
    required this.precio,
  });

  factory ProductoCreateModel.fromJson(Map<String, dynamic> j) =>
      ProductoCreateModel(
        fechaCreacion: DateTime.parse(j['fecha_creacion']),
        esCaro: j['es_caro'] ?? false,
        diagrama: j['diagrama'] ?? '',
        nombre: j['nombre'] ?? '',
        precio: (j['precio'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    'fecha_creacion': fechaCreacion.toIso8601String(),
    'es_caro': esCaro,
    'diagrama': diagrama,
    'nombre': nombre,
    'precio': precio,
  };
}
