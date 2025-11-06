// lib/data/models/objeto/objeto_model.dart
class ObjetoModel {
  final int id;
  final String nombre;
  final double valor_numerico;
  final String diagrama;
  final DateTime? fecha_reserva;
  final bool valor_de_verdad;
  final String campo;
  final int valor_entero;

  ObjetoModel({
    required this.id,
    required this.nombre,
    required this.valor_numerico,
    required this.diagrama,
    required this.fecha_reserva,
    required this.valor_de_verdad,
    required this.campo,
    required this.valor_entero,
  });

  factory ObjetoModel.fromJson(Map<String, dynamic> json) => ObjetoModel(
    id: json['id'],
    nombre: json['nombre'],
    valor_numerico: (json['valor_numerico'] as num?)?.toDouble() ?? 0.0,
    diagrama: json['diagrama'] ?? '',
    fecha_reserva:
        json['fecha_reserva'] != null
            ? DateTime.parse(json['fecha_reserva'])
            : null,
    valor_de_verdad: json['valor_de_verdad'] ?? false,
    campo: json['campo'] ?? '',
    valor_entero: json['valor_entero'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'valor_numerico': valor_numerico,
    'diagrama': diagrama,
    'fecha_reserva': fecha_reserva?.toIso8601String(),
    'valor_de_verdad': valor_de_verdad,
    'campo': campo,
    'valor_entero': valor_entero,
  };
}
