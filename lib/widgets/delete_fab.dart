import 'package:flutter/material.dart';

class DeleteFab extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteFab({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.delete),
    );
  }
}