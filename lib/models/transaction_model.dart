class Transaction {
  final int id;
  final double valor;
  final String descricao;
  final String data;
  final String tipo;

  Transaction({
    required this.id,
    required this.valor,
    required this.descricao,
    required this.data,
    required this.tipo,
  }) : assert(tipo.isNotEmpty, 'O tipo não pode ser vazio');

  factory Transaction.fromJson(Map<String, dynamic> json) {
    String tipo = json['tipo'] ?? 'income';

    if (tipo.isEmpty) {
      tipo = 'income';
    }

    return Transaction(
      id: json['id'],
      valor: json['valor'],
      descricao: json['descricao'],
      data: json['data'],
      tipo: tipo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valor': valor,
      'descricao': descricao,
      'data': data,
      'tipo': tipo,
    };
  }
}