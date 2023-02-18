import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/screens/dados.dart';
import 'package:stock/screens/dados_pedidos.dart';
import 'package:stock/screens/dados_produtos.dart';
import 'package:stock/screens/enderecos.dart';
import 'package:stock/screens/estatisticas.dart';
import 'package:stock/screens/produtos_admin.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/widgets/header.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<DepartamentoModel> departamentos = [];
  String userType = '';
  String userId = '';
  String userAvatar = '';

  @override
  void initState() {
    getUsuario();
    getDepartamentos();
    super.initState();
  }

  Future getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userType = prefs.getString('role')!;
    userAvatar = prefs.getString('avatar')!;
    setState(() {});
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String title1 = "Minha Conta";
    String title2 = "Atendimento";
    String text1 = "Meus dados";
    String text2 = "Meus endereços";
    String text3 = "Meus pedidos";
    String text4 = "WhatsApp";
    String text5 = "Enviar e-mail";
    String text6 = "Nossos telefones";
    var screen1 = const DadosScreen();
    var screen2 = const EnderecosScreen();
    var screen3 = userType != "admin"
        ? const DadosPedidosScreen()
        : const EstatisticasScreen();
    DadosProdutosScreen? screen4;
    ProdutosAdminScreen? screen5;
    ProdutosAdminScreen? screen6;
    IconData icon1 = Icons.account_circle_rounded;
    IconData icon2 = Icons.account_box_rounded;
    IconData icon3 = Icons.shopping_cart_rounded;
    IconData icon4 = Icons.chat;
    IconData icon5 = Icons.mail;
    IconData icon6 = Icons.phone;
    if (userType == "admin") {
      title1 = "Gerenciar";
      title2 = "Gerenciar Produtos";
      text1 = "Meus dados";
      text2 = "Endereços das lojas";
      text3 = "Estatisticas";
      text4 = "Adicionar";
      text5 = "Editar";
      text6 = "Excluir";
      icon1 = Icons.account_circle_outlined;
      icon2 = Icons.assignment;
      icon3 = Icons.auto_graph;
      icon4 = Icons.add_box_outlined;
      icon5 = Icons.edit_outlined;
      icon6 = Icons.delete_outlined;
      ProdutoModel produto = ProdutoModel(
          id: null,
          nome: null,
          estoque: null,
          descricao: null,
          totalAcessos: null,
          imagem: null,
          preco: null,
          departamentoId: null,
          departamento: null,
          isFavorito: null,
          favoritoId: null);
      screen4 = DadosProdutosScreen(produto: produto);
      screen5 = const ProdutosAdminScreen();
      screen6 = const ProdutosAdminScreen();
    }
    double heigth = (MediaQuery.of(context).size.height / 2) - 240;
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Minha Conta', userAvatar),
      body: Padding(
        padding: EdgeInsets.only(top: heigth),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSizedBox(context, title1, text1, text2, text3, icon1, icon2,
                  icon3, screen1, screen2, screen3),
              buildSizedBox(context, title2, text4, text5, text6, icon4, icon5,
                  icon6, screen4, screen5, screen6),
            ]),
      ),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }

  SizedBox buildSizedBox(context, title, text1, text2, text3, icon1, icon2,
      icon3, screen1, screen2, screen3) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        if (screen1 == null) {
                          js.context.callMethod('open',
                              ['https://wa.me/5531994396217', '_blank']);
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => screen1));
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Icon(icon1, size: 50.0, color: blue),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              text1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: blue),
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                      onTap: () {
                        if (screen2 == null) {
                          js.context.callMethod('open', [
                            'https://criarmeulink.com.br/u/1675035349',
                            '_blank'
                          ]);
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => screen2));
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Icon(icon2, size: 50.0, color: blue),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              text2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: blue),
                            ),
                          ),
                        ],
                      )),
                  screen3 == null
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 80.0),
                              child: Icon(icon3, size: 50.0, color: blue),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Column(
                                children: [
                                  Text(
                                    text3,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: blue),
                                  ),
                                  const Text(
                                    '0800 000 0000',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: blue),
                                  ),
                                  const Text(
                                    '(031) 3131-3131',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => screen3));
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 80.0),
                                child: Icon(icon3, size: 50.0, color: blue),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Text(
                                  text3,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: blue),
                                ),
                              ),
                            ],
                          )),
                ]),
          ),
        ],
      ),
    );
  }
}
