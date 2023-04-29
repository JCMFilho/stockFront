import 'package:flutter/material.dart';
import 'package:stock/models/produto_detalhe.dart';

class PedidoItemModel with ChangeNotifier {
  int? id;
  int? quantidade;
  ProdutoDetalheModel? produto;

  PedidoItemModel(
      {required this.id, required this.quantidade, required this.produto});

  PedidoItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = json['quantidade'];
    produto = ProdutoDetalheModel.fromJson(json['produto']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'quantidade': quantidade, 'produto': produto};

  static List<PedidoItemModel> pedidosItemsFromJson(List fullJson) {
    return fullJson.map((data) {
      return PedidoItemModel.fromJson(data);
    }).toList();
  }
}
