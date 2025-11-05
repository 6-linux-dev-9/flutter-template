import 'package:intl/intl.dart';

extension PrettyDate on DateTime? {
  String toPretty() {
    if (this == null) return 'N/A';
    return DateFormat('dd MMM yyyy, HH:mm').format(this!);
  }
}
