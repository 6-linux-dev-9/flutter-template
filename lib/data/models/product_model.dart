class ProductModel {
  final String id;
  final String nombre;
  final double precio;
  ProductModel({required this.id, required this.nombre, required this.precio});
  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
    id: '${j['id']}',
    nombre: j['nombre'],
    precio: (j['precio'] as num).toDouble(),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'precio': precio,
  };
}
