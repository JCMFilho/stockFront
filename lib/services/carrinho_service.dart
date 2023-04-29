import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/produto_carrinho.dart';

class CarrinhoService {
  static Future<CarrinhoModel> getCarrinhoPorUser(String id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/carrinho/$id");
      var response = await http.get(uri);

      if (response.bodyBytes.isEmpty) {
        return CarrinhoModel(
            id: null, idUsuario: null, total: null, produtos: null);
      }

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }

      return CarrinhoModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting carrinho info $error");
      throw error.toString();
    }
  }

  static Future<CarrinhoModel> postCarrinho(
      ProdutoCarrinhoModel produtoCarrinho) async {
    try {
      var uri = Uri.http(baseUrl, "/api/carrinho");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(produtoCarrinho.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return CarrinhoModel.fromJson(data);
    } catch (error) {
      log("an error occured while creating carrinho info $error");
      throw error.toString();
    }
  }

  static Future<void> putCarrinho(ProdutoCarrinhoModel produtoCarrinho) async {
    try {
      var uri = Uri.http(baseUrl, "/api/carrinho");
      var response = await http.put(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(produtoCarrinho.toJson()));

      if (response.statusCode != 204) {
        var data = jsonDecode(response.body);
        throw data["message"];
      }
    } catch (error) {
      log("an error occured while updating carrinho info $error");
      throw error.toString();
    }
  }

  static Future<void> deleteCarrinho(
      ProdutoCarrinhoModel produtoCarrinho) async {
    try {
      var uri = Uri.http(baseUrl, "/api/carrinho/${produtoCarrinho.id}");
      var response = await http.delete(uri);

      if (response.statusCode != 204) {
        var data = jsonDecode(response.body);
        throw data["message"];
      }
    } catch (error) {
      log("an error occured while deleting carrinho info $error");
      throw error.toString();
    }
  }
}
