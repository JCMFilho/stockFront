import 'package:flutter/cupertino.dart';

class AvaliacaoModel with ChangeNotifier {
  String? id;
  String? data;
  String? descricao;
  int? nota;
  String? idUsuario;
  int? idProduto;

  AvaliacaoModel(
      {required this.id,
      required this.data,
      required this.descricao,
      required this.nota,
      required this.idUsuario,
      required this.idProduto});

  AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    descricao = json['descricao'];
    nota = json['nota'];
    idUsuario = json['idUsuario'];
    idProduto = json['idProduto'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'descricao': descricao,
        'nota': nota,
        'idUsuario': idUsuario,
        'idProduto': idProduto
      };

  static List<AvaliacaoModel> avaliacoesFromJson(List fullJson) {
    return fullJson.map((data) {
      return AvaliacaoModel.fromJson(data);
    }).toList();
  }
}
