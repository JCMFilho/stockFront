import 'package:flutter/material.dart';
import 'package:stock/models/avaliacao.dart';
import 'package:stock/models/departamento.dart';

class ProdutoDetalheModel with ChangeNotifier {
  int? id;
  String? nome;
  int? estoque;
  String? descricao;
  int? totalAcessos;
  String? imagem;
  int? preco;
  DepartamentoModel? departamento;
  List<AvaliacaoModel>? avaliacoes;
  bool? isFavorito;
  int? favoritoId;

  ProdutoDetalheModel({
    required this.id,
    required this.nome,
    required this.estoque,
    required this.descricao,
    required this.totalAcessos,
    required this.imagem,
    required this.preco,
    required this.departamento,
    this.avaliacoes,
    this.isFavorito,
    this.favoritoId,
  });

  ProdutoDetalheModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    estoque = json['estoque'];
    descricao = json['descricao'];
    totalAcessos = json['totalAcessos'];
    imagem = json['imagem'];
    preco = json['preco'];
    departamento = DepartamentoModel.fromJson(json['departamento']);
    avaliacoes = AvaliacaoModel.avaliacoesFromJson(json['avaliacoes']);
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
        'departamento': departamento,
        'avaliacoes': avaliacoes,
        'isFavorito': isFavorito,
        'favoritoId': favoritoId
      };

  static List<ProdutoDetalheModel> produtosFromJson(List fullJson) {
    return fullJson.map((data) {
      return ProdutoDetalheModel.fromJson(data);
    }).toList();
  }
}
