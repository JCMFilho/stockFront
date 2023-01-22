import 'package:flutter/cupertino.dart';

class UsuarioModel with ChangeNotifier {
  String? id;
  String? nome;
  String? email;
  String? senha;
  String? cpf;
  String? rg;
  String? telefone;
  String? celular;
  String? role;
  String? avatar;
  String? dataCadastro;

  UsuarioModel(
      {required this.id,
      required this.nome,
      required this.email,
      this.senha,
      this.cpf,
      this.rg,
      this.telefone,
      this.celular,
      this.role,
      this.avatar,
      required this.dataCadastro});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    cpf = json['cpf'];
    rg = json['rg'];
    telefone = json['telefone'];
    celular = json['celular'];
    role = json['role'];
    avatar = json['avatar'];
    dataCadastro = json['data_cadastro'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
        'cpf': cpf,
        'rg': rg,
        'telefone': telefone,
        'celular': celular,
        'role': role,
        'avatar': avatar,
        'data_cadastro': dataCadastro
      };

  static List<UsuarioModel> usersFromJson(List fullJson) {
    return fullJson.map((data) {
      return UsuarioModel.fromJson(data);
    }).toList();
  }
}

class LoginModel with ChangeNotifier {
  String? login;
  String? senha;

  LoginModel({
    required this.login,
    required this.senha,
  });

  Map<String, dynamic> toJson() => {'login': login, 'senha': senha};
}
