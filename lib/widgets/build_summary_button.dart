import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildSummaryButton({
  required String title,
  required double value,
  required Color color,
  required IconData icon,
  required String type,
  required NumberFormat format,
}) {
  return Container(
    width: 170,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(height: 5),
        Text(
          '$type ${format.format(value)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    ),
  );
}