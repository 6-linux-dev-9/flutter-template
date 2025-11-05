import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final Widget child;
  const FormCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}
