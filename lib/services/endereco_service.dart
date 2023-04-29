import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/endereco.dart';

class EnderecoService {
  static Future<EnderecoModel> getEnderecoPrincipalPorUser(String id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/endereco/endereco-principal/$id");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return EnderecoModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting main address info $error");
      throw error.toString();
    }
  }

  static Future<List<EnderecoModel>> getEnderecoPorUser(String id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/endereco/$id");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return EnderecoModel.enderecosFromJson(data);
    } catch (error) {
      log("an error occured while getting address info $error");
      throw error.toString();
    }
  }

  static Future<EnderecoModel> postEndereco(EnderecoModel endereco) async {
    try {
      var uri = Uri.http(baseUrl, "/api/endereco");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(endereco.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return EnderecoModel.fromJson(data);
    } catch (error) {
      log("an error occured while creating address info $error");
      throw error.toString();
    }
  }

  static Future<bool> putEndereco(int id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/endereco/$id");
      var response = await http.put(uri);

      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (error) {
      log("an error occured while changing address info $error");
      throw error.toString();
    }
  }

  static Future<bool> deleteEnderecoPorId(int id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/endereco/$id");
      var response = await http.delete(uri);

      if (response.statusCode != 204) {
        return false;
      }
      return true;
    } catch (error) {
      log("an error occured while deleting address info $error");
      throw error.toString();
    }
  }
}
