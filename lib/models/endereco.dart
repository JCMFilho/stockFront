import 'package:flutter/cupertino.dart';

class EnderecoModel with ChangeNotifier {
  int? id;
  String? usuarioId;
  String? tipo;
  String? logradouro;
  String? numero;
  String? bairro;
  String? cidade;
  String? estado;
  String? cep;
  bool? enderecoPrincipal;

  EnderecoModel(
      {required this.id,
      required this.usuarioId,
      required this.tipo,
      required this.logradouro,
      required this.numero,
      required this.bairro,
      required this.cidade,
      required this.estado,
      required this.cep,
      required this.enderecoPrincipal});

  EnderecoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioId = json['usuarioId'];
    tipo = json['tipo'];
    logradouro = json['logradouro'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    cep = json['cep'];
    enderecoPrincipal = json['enderecoPrincipal'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'tipo': tipo,
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'enderecoPrincipal': enderecoPrincipal
      };

  static List<EnderecoModel> enderecosFromJson(List fullJson) {
    return fullJson.map((data) {
      return EnderecoModel.fromJson(data);
    }).toList();
  }
}
