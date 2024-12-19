import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDialog extends StatefulWidget {
  final String tipoInicial;
  final Function(Map<String, dynamic>) onSubmit;

  const TransactionDialog({
    super.key,
    required this.tipoInicial, // Parâmetro 'tipoInicial' requerido
    required this.onSubmit,     // Função 'onSubmit' requerida
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final valorController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  late String tipo;

  @override
  void initState() {
    super.initState();
    tipo = widget.tipoInicial; // Inicializando tipo com o valor recebido
  }

  @override
  void dispose() {
    valorController.dispose();
    descricaoController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tipo == 'income' ? 'Adicionar Recebimento' : 'Adicionar Gasto',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dataController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  dataController.text =
                      DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tipo:'),
                DropdownButton<String>(
                  value: tipo,
                  items: const [
                    DropdownMenuItem(
                      value: 'income',
                      child: Text('Recebimento'),
                    ),
                    DropdownMenuItem(
                      value: 'expense',
                      child: Text('Gasto'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        tipo = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (valorController.text.isNotEmpty &&
                        descricaoController.text.isNotEmpty &&
                        dataController.text.isNotEmpty) {
                      double? valor = double.tryParse(valorController.text);
                      if (valor != null && valor > 0) {
                        widget.onSubmit({
                          'valor': valor,
                          'descricao': descricaoController.text,
                          'data': dataController.text,
                          'tipo': tipo,
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Insira um valor válido!'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}