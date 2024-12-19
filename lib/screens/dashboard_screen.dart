import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/build_summary_button.dart';
import '../widgets/transaction_dialog.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashBoardView();
  }
}

class DashBoardView extends StatelessWidget {
  DashBoardView({super.key});

  final String type = r'R$';
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  final List<Map<String, dynamic>> transactions = [
    {'id': 1, 'tipo': 'income', 'valor': 600.0, 'descricao': 'Salário'},
    {'id': 2, 'tipo': 'expense', 'valor': 200.0, 'descricao': 'Supermercado'},
    {'id': 3, 'tipo': 'income', 'valor': 300.0, 'descricao': 'Freelance'},
    {'id': 4, 'tipo': 'expense', 'valor': 100.0}, // Sem descrição
  ];

  @override
  Widget build(BuildContext context) {
    final totalRecebimentos = transactions
        .where((t) => t['tipo'] == 'income')
        .fold<double>(0.0, (sum, t) => sum + t['valor']);

    final totalGastos = transactions
        .where((t) => t['tipo'] == 'expense')
        .fold<double>(0.0, (sum, t) => sum + t['valor']);

    final saldoTotal = transactions.fold<double>(
      0.0,
          (sum, transaction) => sum +
          (transaction['tipo'] == 'income' ? transaction['valor'] : -transaction['valor']),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Hero(
            tag: 'saldo',
            child: Text(
              'Saldo: $type ${currencyFormat.format(saldoTotal)}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.amber[100],
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumo das Finanças',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSummaryButton(
                    title: "Recebimentos",
                    value: totalRecebimentos,
                    color: Colors.green,
                    icon: Icons.arrow_upward,
                    type: type,
                    format: currencyFormat,
                  ),
                  buildSummaryButton(
                    title: "Gastos",
                    value: totalGastos,
                    color: Colors.red,
                    icon: Icons.arrow_downward,
                    type: type,
                    format: currencyFormat,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return buildTransactionCard(
                      transacao: transactions[index],
                      type: type,
                      format: currencyFormat,
                      onDelete: () => _confirmDeleteTransaction(
                        context,
                        index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openTransactionDialog(context, 'income'),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Recebimento",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _openTransactionDialog(context, 'expense'),
                icon: const Icon(Icons.remove, color: Colors.white),
                label: const Text(
                  "Gasto",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteTransaction(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza de que deseja excluir esta transação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              transactions.removeAt(index);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _openTransactionDialog(BuildContext context, String tipoInicial) {
    tipoInicial = tipoInicial.isEmpty ? 'income' : tipoInicial;

    showDialog(
      context: context,
      builder: (context) => TransactionDialog(
        tipoInicial: tipoInicial,
        onSubmit: (newTransaction) {
          newTransaction['tipo'] ??= tipoInicial;
          transactions.add(newTransaction);
        },
      ),
    );
  }
}

Widget buildTransactionCard({
  required Map<String, dynamic> transacao,
  required String type,
  required NumberFormat format,
  required VoidCallback onDelete,
}) {
  final bool isIncome = transacao['tipo'] == 'income';
  final Color iconColor = isIncome ? Colors.green : Colors.red;
  final IconData icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

  final String descricao = transacao['descricao'] is String
      ? transacao['descricao']
      : 'Sem descrição';

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 4), // Menor espaçamento
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
      subtitle: Text(descricao),
      trailing: GestureDetector(
        onTap: onDelete,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
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