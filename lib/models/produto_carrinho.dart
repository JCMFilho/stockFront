import 'package:flutter/material.dart';
import 'package:stock/models/produto_detalhe.dart';

class ProdutoCarrinhoModel with ChangeNotifier {
  int? id;
  int? quantidade;
  ProdutoDetalheModel? produto;
  String? usuarioId;

  ProdutoCarrinhoModel({
    required this.id,
    required this.quantidade,
    required this.produto,
    required this.usuarioId,
  });

  ProdutoCarrinhoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = json['quantidade'];
    produto = ProdutoDetalheModel.fromJson(json['produto']);
    usuarioId = json['usuarioId'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantidade': quantidade,
        'produto': produto,
        'usuarioId': usuarioId
      };

  static List<ProdutoCarrinhoModel> produtosFromJson(List fullJson) {
    return fullJson.map((data) {
      return ProdutoCarrinhoModel.fromJson(data);
    }).toList();
  }
}
