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
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
        TextInputFormatter.withFunction((oldV, newV) {
          final t = newV.text.replaceAll(',', '.');
          return newV.copyWith(
            text: t,
            selection: TextSelection.collapsed(offset: t.length),
          );
        }),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.pin_outlined),
      ),
      // sin validator obligatorio
      // onChanged: (v) {
      //   if (v.trim().isEmpty) {
      //     controller.text = '0';
      //     controller.selection = TextSelection.fromPosition(
      //       TextPosition(offset: controller.text.length),
      //     );
      //   }
      // },
      onTap: () {
        // Si el campo tiene un "0" de precarga, se limpia visualmente
        if (controller.text == '0' || controller.text == '0.0') {
          controller.clear();
        }
      },
    );
  }
}
