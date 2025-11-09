import 'package:template_app/core/utils/date_format.dart';

class ClassIdConverter {
  static dynamic obtenerLlaveDeObjetoRelacionado(dynamic json) {
    // Si 'usuarioJson' es un Map, tratamos de extraer el 'id'
    if (json is Map<String, dynamic>) {
      final id = json['id'];
      if (id is int) {
        return id; // Si es int, lo devolvemos tal cual
      } else if (id is String) {
        return id; // Si es String (como un UUID), lo dejamos como está
      }
    }
    return null; // Si no podemos convertirlo, retornamos null
  }

  static dynamic convertirIdParaJson(dynamic id) {
    if (id is int) {
      return id;
    } else if (id is String) {
      final parsedId = int.tryParse(id);
      return parsedId ?? id;
    }
    return null;
  }

  static DateTime? parsearFecha(dynamic campoFecha) {
    return campoFecha != null ? DateTime.parse(campoFecha) : null;
  }

  static double parsearADouble(dynamic campoDouble) {
    return (campoDouble as num?)!.toDouble();
  }

  static String? convertirFechaToJson(DateTime? campoFecha) {
    return campoFecha?.toIso8601String();
  }

  static String convertirParaJSONEnScreen(String? diagrama) {
    if (diagrama == null) {
      return 'N/A';
    }
    if (diagrama.length > 45) {
      return '${diagrama.substring(0, 45)}…';
    } else {
      return diagrama;
    }
  }

  static String convertirParaRelacionIdIntEnScreen(int? llaveForaneaId) {
    if (llaveForaneaId == null) {
      return 'N/A';
    }
    return llaveForaneaId.toString();
  }

  static String convertirParaRelacionIdStringEnScreen(String? llaveForaneaId) {
    if (llaveForaneaId == null) {
      return 'N/A';
    }
    return llaveForaneaId;
  }

  static String convertirParaFechaEnScreen(DateTime? fecha) {
    if (fecha == null) {
      return 'N/A';
    }
    return fecha.toPretty();
  }

  static String convertirParaBooleanEnScreen(bool booleano) {
    if (booleano == null) {
      return 'N/A';
    }
    return booleano ? "true" : "false";
  }

  static String convertirParaStringEnScreen(String? str) {
    if (str == null || str.isEmpty) {
      return 'N/A';
    }
    return str;
  }

  static String convertirParaFlotanteEnScreen(double valor) {
    if (valor == null) {
      return 'N/A';
    }
    return valor.toStringAsFixed(2);
  }

  //para los nulos en caso de no enviar
  static String? convertirParaModeloEnEdicionYCreacion(String str) {
    return str.isEmpty ? null : str.trim();
  }
}
