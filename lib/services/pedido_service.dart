import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/pedido.dart';

class PedidoService {
  static Future<List<PedidoModel>> getPedidoPorUser(String id) async {
    try {
      var uri = Uri.https(baseUrl, "/api/pedido/$id");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return PedidoModel.pedidosFromJson(data);
    } catch (error) {
      log("an error occured while getting pedido info $error");
      throw error.toString();
    }
  }

  static Future<PedidoModel> postPedido(PedidoPostModel pedido) async {
    try {
      var uri = Uri.https(baseUrl, "/api/pedido");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(pedido.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return PedidoModel.fromJson(data);
    } catch (error) {
      log("an error occured while creating pedido info $error");
      throw error.toString();
    }
  }

  static Future<void> putPedido(PedidoPutModel pedido) async {
    try {
      var uri = Uri.https(baseUrl, "/api/pedido");
      var response = await http.put(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(pedido.toJson()));

      if (response.statusCode != 204) {
        var data = jsonDecode(response.body);
        throw data["message"];
      }
    } catch (error) {
      log("an error occured while updating carrinho info $error");
      throw error.toString();
    }
  }
}
