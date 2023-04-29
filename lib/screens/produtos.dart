import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/services/carrinho_service.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/produto_service.dart';

import 'package:stock/widgets/card_produto.dart';
import 'package:stock/widgets/header.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key, required this.produtos}) : super(key: key);

  final List<ProdutoModel> produtos;

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  String userId = '';
  String userRole = '';
  String userAvatar = '';
  int totalCarrinho = 0;
  int totalFavorito = 0;
  List<DepartamentoModel> departamentos = [];

  @override
  void initState() {
    getDepartamentos();
    getUsuario();
    super.initState();
  }

  Future getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userAvatar = prefs.getString('avatar')!;
    userRole = prefs.getString('role')!;
    List<ProdutoModel> produtos =
        await ProdutoService.getProdutosFavoritadosPorUsuario(userId);
    totalFavorito = produtos.length;
    CarrinhoModel carrinho = await CarrinhoService.getCarrinhoPorUser(userId);
    totalCarrinho = carrinho.total!;
    setState(() {});
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar:
            HeaderWidget.buildAppBar(context, "Lista de produtos", userAvatar),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(
                  size: size,
                  userId: userId,
                  userRole: userRole,
                  totalCarrinho: totalCarrinho,
                  totalFavorito: totalFavorito),
              CardProdutoWidget(
                  produtos: widget.produtos, userId: userId, userRole: userRole)
            ],
          ),
        ),
        drawer: HeaderWidget.buildDrawer(context, userId, departamentos));
  }
}
