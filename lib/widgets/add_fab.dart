import 'package:flutter/material.dart';

class AddFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddFab({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}