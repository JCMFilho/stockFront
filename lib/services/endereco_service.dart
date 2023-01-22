import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/endereco.dart';

class EnderecoService {
  static Future<List<EnderecoModel>> getEnderecoPorUser(String id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/endereco/$id");
      var response = await http.get(uri);

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return EnderecoModel.enderecosFromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }
}
