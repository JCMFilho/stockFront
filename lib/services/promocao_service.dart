import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/promocao.dart';

class PromocaoService {
  static Future<List<PromocaoModel>> getData(String tipo) async {
    try {
      var uri = Uri.http(baseUrl, "/api/promocao/$tipo");
      var response = await http.get(uri);

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return PromocaoModel.promocoesFromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }

  static Future<List<PromocaoModel>> getPromocaoByTipo(String tipo) async {
    List temp = await getData(tipo);
    return PromocaoModel.promocoesFromJson(temp);
  }
}
