import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/departamento.dart';

class DepartamentoService {
  static Future<List<DepartamentoModel>> getDepartamentos() async {
    try {
      var uri = Uri.http(baseUrl, "/api/departamento");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return DepartamentoModel.departamentosFromJson(data);
    } catch (error) {
      log("an error occured while getting departamentos info $error");
      throw error.toString();
    }
  }
}
