
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 60,
              color: Colors.grey,
            ),
          const SizedBox(height: 16.0),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
