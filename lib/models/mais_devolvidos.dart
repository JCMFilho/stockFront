import 'package:flutter/cupertino.dart';

class MaisDevolvidosModel with ChangeNotifier {
  int? qtde;
  String? departamento;
  String? data;

  MaisDevolvidosModel(
      {required this.qtde, required this.departamento, required this.data});

  MaisDevolvidosModel.fromJson(Map<String, dynamic> json) {
    qtde = json['qtde'];
    departamento = json['departamento'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() =>
      {'qtde': qtde, 'produto': departamento, 'data': data};

  static List<MaisDevolvidosModel> maisDevolvidosFromJson(List fullJson) {
    return fullJson.map((data) {
      return MaisDevolvidosModel.fromJson(data);
    }).toList();
  }
}
