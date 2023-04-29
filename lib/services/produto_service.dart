import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/models/produto_detalhe.dart';

class ProdutoService {
  static Future<List<ProdutoModel>> getProdutos(String? id) async {
    try {
      var uri =
          Uri.http(baseUrl, "/api/produto/listar-todos", {"idUsuario": id});
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProdutoModel.produtosFromJson(data);
    } catch (error) {
      log("an error occured while getting products info $error");
      throw error.toString();
    }
  }

  static Future<List<ProdutoModel>> getProdutosFavoritadosPorUsuario(
      String? id) async {
    try {
      var uri =
          Uri.http(baseUrl, "/api/produto/meus-favoritos", {"idUsuario": id});
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProdutoModel.produtosFromJson(data);
    } catch (error) {
      log("an error occured while getting products favoritados info $error");
      throw error.toString();
    }
  }

  static Future<ProdutoDetalheModel> getProduto(int id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/produto/$id");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProdutoDetalheModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }

  static Future<List<ProdutoModel>> getProdutosPorDepartamento(
      int idDepartamento, String? idUsuario) async {
    try {
      var uri = Uri.http(
          baseUrl,
          "/api/produto/listar-por-departamento/$idDepartamento",
          {"idUsuario": idUsuario});
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProdutoModel.produtosFromJson(data);
    } catch (error) {
      log("an error occured while getting product by departamento info $error");
      throw error.toString();
    }
  }

  static Future<List<ProdutoModel>> getProdutosPorNome(
      String nomeProduto, String? idUsuario) async {
    try {
      var uri = Uri.http(
          baseUrl, "/api/produto/nome/$nomeProduto", {"idUsuario": idUsuario});
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProdutoModel.produtosFromJson(data);
    } catch (error) {
      log("an error occured while getting product by name info $error");
      throw error.toString();
    }
  }

  static Future<ProdutoModel> postProduto(ProdutoModel user) async {
    try {
      var uri = Uri.http(baseUrl, "/api/produto");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return ProdutoModel.fromJson(data);
    } catch (error) {
      log("an error occured while creating product info $error");
      throw error.toString();
    }
  }

  static Future<bool> deleteProdutoPorId(int id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/produto/$id");
      var response = await http.delete(uri);

      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (error) {
      log("an error occured while deleting product info $error");
      throw error.toString();
    }
  }
}
