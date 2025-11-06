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
  final int? usuario_id;
  final DateTime? fechaEliminacion;
  final String estado;

  ObjetoModel({
    required this.id,
    required this.nombre,
    required this.valor_numerico,
    required this.diagrama,
    required this.fecha_reserva,
    required this.valor_de_verdad,
    required this.campo,
    required this.valor_entero,
    required this.usuario_id,
    required this.fechaEliminacion,
    required this.estado,
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
    usuario_id:
        json['usuario'] is Map<String, dynamic>
            ? (json['usuario']['id'] is int
                ? json['usuario']['id'] as int
                : null)
            : null,
    fechaEliminacion:
        json['fechaEliminacion'] != null
            ? DateTime.parse(json['deletedAt'])
            : null,
    estado: json['estado'] ?? '',
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
    'usuario_id': usuario_id,
    'estado': estado,
  };
  @override
  String toString() =>
      '[$id, $nombre, $valor_numerico, $diagrama, $fecha_reserva, $valor_de_verdad, $campo, $valor_entero, $usuario_id]';

  String toStringModified({int maxLength = 15}) {
    final raw =
        '[$id, $nombre, $valor_numerico, $diagrama, $fecha_reserva, $valor_de_verdad, $campo, $valor_entero, $usuario_id]';
    return (raw.length > maxLength) ? '${raw.substring(0, maxLength)}...' : raw;
  }
}
