import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/favorito.dart';

class FavoritoService {
  static Future<FavoritoRetornoModel> postFavorito(FavoritoModel pedido) async {
    try {
      var uri = Uri.https(baseUrl, "/api/favorito");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(pedido.toJson()));

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return FavoritoRetornoModel.fromJson(data);
    } catch (error) {
      log("an error occured while creating favorito info $error");
      throw error.toString();
    }
  }

  static Future<bool> deleteFavoritoPorId(int id) async {
    try {
      var uri = Uri.https(baseUrl, "/api/favorito/$id");
      var response = await http.delete(uri);

      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (error) {
      log("an error occured while deleting favorito info $error");
      throw error.toString();
    }
  }
}
