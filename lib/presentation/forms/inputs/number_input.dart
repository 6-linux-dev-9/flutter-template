// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class NumberInput extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final String? Function(String?)? validator;

//   const NumberInput({
//     super.key,
//     required this.controller,
//     this.label = 'Amount',
//     this.hint = 'Ej. 123.45',
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: const TextInputType.numberWithOptions(
//         decimal: true,
//         signed: false,
//       ),
//       inputFormatters: [
//         FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
//         TextInputFormatter.withFunction((oldV, newV) {
//           final t = newV.text.replaceAll(',', '.');
//           return newV.copyWith(
//             text: t,
//             selection: TextSelection.collapsed(offset: t.length),
//           );
//         }),
//       ],
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: const Icon(Icons.pin_outlined),
//       ),
//       validator: validator,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const NumberInput({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.hint = 'Ej. 123.45',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        // Permite números y punto o coma
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
        // Mantiene posición del cursor incluso al reemplazar comas por puntos
        TextInputFormatter.withFunction((oldV, newV) {
          if (newV.text.contains(',')) {
            final cursorPos = newV.selection.baseOffset;
            final replacedText = newV.text.replaceAll(',', '.');
            final diff = newV.text.length - replacedText.length;
            final newCursorPos = (cursorPos - diff).clamp(
              0,
              replacedText.length,
            );
            return newV.copyWith(
              text: replacedText,
              selection: TextSelection.collapsed(offset: newCursorPos),
            );
          }
          return newV;
        }),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.pin_outlined),
      ),
      onTap: () {
        // Si el campo tiene un valor 0 o 0.0 inicial, se limpia
        if (controller.text == '0' || controller.text == '0.0') {
          controller.clear();
        }
      },
    );
  }
}
