// lib/data/models/objeto/input/objeto_update_model.dart
class ObjetoUpdateModel {
  final String nombre;
  final double valor_numerico;
  final String diagrama;
  final DateTime? fecha_reserva;
  final bool valor_de_verdad;
  final String campo;
  final int valor_entero;
  final int? usuario_id;
  final String estado;

  ObjetoUpdateModel({
    required this.nombre,
    required this.valor_numerico,
    required this.diagrama,
    required this.fecha_reserva,
    required this.valor_de_verdad,
    required this.campo,
    required this.valor_entero,
    required this.usuario_id,
    required this.estado    
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'valor_numerico': valor_numerico,
    'diagrama': diagrama,
    'fecha_reserva': fecha_reserva?.toIso8601String(),
    'valor_de_verdad': valor_de_verdad,
    'campo': campo,
    'valor_entero': valor_entero,
    'usuarioId':usuario_id,
    'estado': estado.toLowerCase()
  };
}

