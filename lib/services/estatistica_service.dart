import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/estatistica.dart';

class EstatisticaService {
  static Future<EstatisticaModel> getEstatistica() async {
    try {
      var uri = Uri.https(baseUrl, "/api/estatistica");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return EstatisticaModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting estatistica info $error");
      throw error.toString();
    }
  }
}
