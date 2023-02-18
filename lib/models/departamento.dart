import 'package:flutter/cupertino.dart';

class DepartamentoModel with ChangeNotifier {
  int? id;
  String? nome;

  DepartamentoModel({required this.id, required this.nome});

  DepartamentoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome};

  static List<DepartamentoModel> departamentosFromJson(List fullJson) {
    return fullJson.map((data) {
      return DepartamentoModel.fromJson(data);
    }).toList();
  }
}
