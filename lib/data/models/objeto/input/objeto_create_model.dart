// lib/data/models/objeto/input/objeto_create_model.dart
class ObjetoCreateModel {
  final String nombre;
  final double valor_numerico;
  final String diagrama;
  final DateTime? fecha_reserva;
  final bool valor_de_verdad;
  final String campo;
  final int valor_entero;
  final int? usuario_id;


  ObjetoCreateModel({
    required this.nombre,
    required this.valor_numerico,
    required this.diagrama,
    required this.fecha_reserva,
    required this.valor_de_verdad,
    required this.campo,
    required this.valor_entero,
    required this.usuario_id
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'valor_numerico': valor_numerico,
    'diagrama': diagrama,
    'fecha_reserva': fecha_reserva?.toIso8601String(),
    'valor_de_verdad': valor_de_verdad,
    'campo': campo,
    'valor_entero': valor_entero,
    'usuarioId': usuario_id
  };
  @override
  String toString() {
    return 'ObjetoCreateModel(nombre: $nombre, valor_numerico: $valor_numerico, diagrama: $diagrama, fecha_reserva: $fecha_reserva, valor_de_verdad: $valor_de_verdad, campo: $campo, valor_entero: $valor_entero, usuario_id: $usuario_id)';
  }
}
