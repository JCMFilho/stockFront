import 'package:flutter/material.dart';

class ProdutoModel with ChangeNotifier {
  int? id;
  String? nome;
  int? estoque;
  String? descricao;
  int? totalAcessos;
  String? imagem;
  int? preco;
  int? departamentoId;
  String? departamento;
  bool? isFavorito;
  int? favoritoId;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.estoque,
    required this.descricao,
    required this.totalAcessos,
    required this.imagem,
    required this.preco,
    required this.departamentoId,
    required this.departamento,
    required this.isFavorito,
    this.favoritoId,
  });

  ProdutoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    estoque = json['estoque'];
    descricao = json['descricao'];
    totalAcessos = json['totalAcessos'];
    imagem = json['imagem'];
    preco = json['preco'];
    departamentoId = json['departamentoId'];
    departamento = json['departamento'];
    isFavorito = json['isFavorito'];
    favoritoId = json['favoritoId'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'estoque': estoque,
        'descricao': descricao,
        'totalAcessos': totalAcessos,
        'imagem': imagem,
        'preco': preco,
        'departamentoId': departamentoId,
        'departamento': departamento,
        'isFavorito': isFavorito,
        'favoritoId': favoritoId
      };

  static List<ProdutoModel> produtosFromJson(List fullJson) {
    return fullJson.map((data) {
      return ProdutoModel.fromJson(data);
    }).toList();
  }
}
