import 'package:flutter/cupertino.dart';

class FavoritoModel with ChangeNotifier {
  String? idUsuario;
  int? idProduto;

  FavoritoModel({required this.idUsuario, required this.idProduto});

  FavoritoModel.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    idProduto = json['idProduto'];
  }

  Map<String, dynamic> toJson() =>
      {'idUsuario': idUsuario, 'idProduto': idProduto};

  static List<FavoritoModel> favoritosFromJson(List fullJson) {
    return fullJson.map((data) {
      return FavoritoModel.fromJson(data);
    }).toList();
  }
}

class FavoritoRetornoModel with ChangeNotifier {
  int? id;

  FavoritoRetornoModel({required id});

  FavoritoRetornoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() => {'id': id};

  static List<FavoritoModel> favoritosFromJson(List fullJson) {
    return fullJson.map((data) {
      return FavoritoModel.fromJson(data);
    }).toList();
  }
}
