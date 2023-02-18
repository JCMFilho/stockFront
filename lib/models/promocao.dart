import 'package:flutter/cupertino.dart';

class PromocaoModel with ChangeNotifier {
  int? id;
  String? imagem;
  int? departamentoId;
  String? tipo;

  PromocaoModel(
      {required this.id,
      required this.imagem,
      required this.departamentoId,
      required this.tipo});

  PromocaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagem = json['imagem'];
    departamentoId = json['departamentoId'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagem': imagem,
        'departamentoId': departamentoId,
        'tipo': tipo
      };

  static List<PromocaoModel> promocoesFromJson(List fullJson) {
    return fullJson.map((data) {
      return PromocaoModel.fromJson(data);
    }).toList();
  }
}
