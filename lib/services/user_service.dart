import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/usuario.dart';

class UserService {
  static Future<UsuarioModel> getUsuario(String id) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario/$id");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting usuario info $error");
      throw error.toString();
    }
  }

  static Future<UsuarioModel> getUsuarioByEmail(String email) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario/email/$email");
      var response = await http.get(uri);

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting usuario by email info $error");
      throw error.toString();
    }
  }

  static Future<UsuarioModel> postUsuario(UsuarioModel user) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while creating usuario info $error");
      throw error.toString();
    }
  }

  static Future<UsuarioModel> putUsuario(UsuarioModel user) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario");
      var response = await http.put(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while updating usuario info $error");
      throw error.toString();
    }
  }

  static Future<UsuarioModel> postLoginUsuario(LoginModel login) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario/login");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(login.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while login user info $error");
      throw error.toString();
    }
  }

  static Future<int> recuperarSenha(String email) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario/recuperar");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(email));

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return data;
    } catch (error) {
      log("an error occured while login user info $error");
      throw error.toString();
    }
  }

  static Future<bool> trocarSenha(LoginModel login) async {
    try {
      var uri = Uri.https(baseUrl, "/api/usuario/trocar");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(login.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return data;
    } catch (error) {
      log("an error occured while login user info $error");
      throw error.toString();
    }
  }
}
