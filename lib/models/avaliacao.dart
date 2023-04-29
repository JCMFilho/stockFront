import 'package:flutter/cupertino.dart';
import 'package:stock/models/usuario.dart';

class AvaliacaoModel with ChangeNotifier {
  int? id;
  String? data;
  String? descricao;
  int? nota;
  UsuarioModel? idUsuario;

  AvaliacaoModel(
      {required this.id,
      required this.data,
      required this.descricao,
      required this.nota,
      required this.idUsuario});

  AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    descricao = json['descricao'];
    nota = json['nota'];
    idUsuario = UsuarioModel.fromJson(json['idUsuario']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'descricao': descricao,
        'nota': nota,
        'idUsuario': idUsuario
      };

  static List<AvaliacaoModel> avaliacoesFromJson(List fullJson) {
    return fullJson.map((data) {
      return AvaliacaoModel.fromJson(data);
    }).toList();
  }
}
