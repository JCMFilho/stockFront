import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stock/consts/api.dart';
import 'package:stock/models/usuario.dart';

class UserService {
  static Future<UsuarioModel> getUsuario(String id) async {
    try {
      var uri = Uri.http(baseUrl, "/api/usuario/$id");
      var response = await http.get(uri);

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }

  static Future<UsuarioModel> postUsuario(UsuarioModel user) async {
    try {
      var uri = Uri.http(baseUrl, "/api/usuario");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }

  static Future<UsuarioModel> postLoginUsuario(LoginModel login) async {
    try {
      var uri = Uri.http(baseUrl, "/api/usuario/login");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: json.encode(login.toJson()));

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return UsuarioModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }

/*   static Future<List<ProductsModel>> getAllProducts(
      {required String limit}) async {
    List temp = await getData(
      target: "products",
      limit: limit,
    );
    return ProductsModel.productsFromSnapshot(temp);
  }

  static Future<List<CategoriesModel>> getAllCategories() async {
    List temp = await getData(target: "categories");
    return CategoriesModel.categoriesFromSnapshot(temp);
  }

  static Future<List<UsersModel>> getAllUsers() async {
    List temp = await getData(target: "users");
    return UsersModel.usersFromSnapshot(temp);
  }

  static Future<ProductsModel> getProductById({required String id}) async {
    try {
      var uri = Uri.https(
        BASE_URL,
        "api/v1/products/$id",
      );
      var response = await http.get(uri);

      // print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProductsModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  } */
}
