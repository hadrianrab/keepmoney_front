import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildTransactionCard({
  required Map<String, dynamic> transacao,
  required String type,
  required NumberFormat format,
  required VoidCallback onDelete,
}) {
  final bool isIncome = transacao['tipo'] == 'income';
  final Color iconColor = isIncome ? Colors.green : Colors.red;
  final IconData icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        '$type ${format.format(transacao['valor'])}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: iconColor,
        ),
      ),
      subtitle: Text(transacao['descricao']),
      trailing: GestureDetector(
        onTap: onDelete,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ),
  );
}