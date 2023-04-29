import 'package:flutter/material.dart';
import 'package:stock/models/produto_carrinho.dart';
import 'package:stock/models/usuario.dart';

class CarrinhoModel with ChangeNotifier {
  int? id;
  UsuarioModel? idUsuario;
  int? total;
  List<ProdutoCarrinhoModel>? produtos;

  CarrinhoModel({
    required this.id,
    required this.idUsuario,
    required this.total,
    required this.produtos,
  });

  CarrinhoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUsuario = json['idUsuario'];
    total = json['total'];
    produtos = ProdutoCarrinhoModel.produtosFromJson(json['produtos']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'idUsuario': idUsuario, 'total': total, 'produtos': produtos};

  static List<CarrinhoModel> carrinhosFromJson(List fullJson) {
    return fullJson.map((data) {
      return CarrinhoModel.fromJson(data);
    }).toList();
  }
}
