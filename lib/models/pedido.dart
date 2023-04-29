import 'package:flutter/material.dart';
import 'package:stock/models/pedido_item.dart';

class PedidoModel with ChangeNotifier {
  int? id;
  String? total;
  String? frete;
  String? status;
  List<PedidoItemModel>? items;

  PedidoModel(
      {required this.id,
      required this.total,
      required this.frete,
      required this.status,
      required this.items});

  PedidoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    frete = json['frete'];
    status = json['status'];
    items = PedidoItemModel.pedidosItemsFromJson(json['items']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'total': total,
        'frete': frete,
        'status': status,
        'items': items
      };

  static List<PedidoModel> pedidosFromJson(List fullJson) {
    return fullJson.map((data) {
      return PedidoModel.fromJson(data);
    }).toList();
  }
}

class PedidoPutModel with ChangeNotifier {
  int? idPedido;
  String? status;

  PedidoPutModel({required this.idPedido, required this.status});

  PedidoPutModel.fromJson(Map<String, dynamic> json) {
    idPedido = json['idPedido'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'status': status,
      };

  static List<PedidoModel> pedidosFromJson(List fullJson) {
    return fullJson.map((data) {
      return PedidoModel.fromJson(data);
    }).toList();
  }
}

class PedidoPostModel with ChangeNotifier {
  int? idCarrinho;
  String? idUsuario;
  String? frete;
  String? total;

  PedidoPostModel(
      {required this.idCarrinho,
      required this.idUsuario,
      required this.frete,
      required this.total});

  PedidoPostModel.fromJson(Map<String, dynamic> json) {
    idCarrinho = json['idCarrinho'];
    idUsuario = json['idUsuario'];
    frete = json['frete'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() => {
        'idCarrinho': idCarrinho,
        'idUsuario': idUsuario,
        'frete': frete,
        'total': total
      };

  static List<PedidoModel> pedidosFromJson(List fullJson) {
    return fullJson.map((data) {
      return PedidoModel.fromJson(data);
    }).toList();
  }
}
