import 'package:flutter/cupertino.dart';

class ProdutoDepartamentoModel with ChangeNotifier {
  int? qtde;
  String? produto;
  String? departamento;

  ProdutoDepartamentoModel(
      {required this.qtde, required this.produto, required this.departamento});

  ProdutoDepartamentoModel.fromJson(Map<String, dynamic> json) {
    qtde = json['qtde'];
    produto = json['produto'];
    departamento = json['departamento'];
  }

  Map<String, dynamic> toJson() =>
      {'qtde': qtde, 'produto': produto, 'departamento': departamento};

  static List<ProdutoDepartamentoModel> produtoDepartamentoFromJson(
      List fullJson) {
    return fullJson.map((data) {
      return ProdutoDepartamentoModel.fromJson(data);
    }).toList();
  }
}
