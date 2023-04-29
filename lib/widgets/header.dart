import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import 'package:stock/consts/cores.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/screens/carrinho.dart';
import 'package:stock/screens/home.dart';
import 'package:stock/screens/produtos.dart';
import 'package:stock/screens/user.dart';
import 'package:stock/screens/login.dart';
import 'package:stock/consts/imagens.dart';
import 'package:stock/services/carrinho_service.dart';
import 'package:stock/services/produto_service.dart';
import 'package:stock/utils/authentication.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(
      {Key? key,
      required this.size,
      required this.userId,
      required this.userRole,
      required this.totalCarrinho,
      required this.totalFavorito})
      : super(key: key);

  final Size size;
  final String userId;
  final String userRole;
  final int totalCarrinho;
  final int totalFavorito;

  @override
  Widget build(BuildContext context) {
    Widget badgeCarrinho = totalCarrinho != 0 && userRole != 'admin'
        ? badges.Badge(
            badgeStyle: const badges.BadgeStyle(badgeColor: red),
            badgeContent: Text(
              totalCarrinho.toString(),
              style: const TextStyle(
                color: white,
              ),
            ),
            child: IconButton(
              onPressed: () async {
                CarrinhoModel carrinho =
                    await CarrinhoService.getCarrinhoPorUser(userId);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CarrinhoScreen(
                          carrinho: carrinho,
                        )));
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 30),
            ))
        : const Icon(Icons.shopping_cart_outlined, size: 30);

    Widget badgeFavorito = totalFavorito != 0
        ? badges.Badge(
            badgeStyle: const badges.BadgeStyle(badgeColor: red),
            badgeContent: Text(
              totalFavorito.toString(),
              style: const TextStyle(
                color: white,
              ),
            ),
            child: IconButton(
              onPressed: () async {
                List<ProdutoModel> produtos =
                    await ProdutoService.getProdutosFavoritadosPorUsuario(
                        userId);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProdutosScreen(
                          produtos: produtos,
                        )));
              },
              icon: const Icon(Icons.favorite_border, size: 30),
            ))
        : const Icon(Icons.favorite_border, size: 30);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      height: size.height * 0.2,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 25 + 20.0,
          ),
          height: size.height * 0.2 - 35,
          decoration: const BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
                child: Image.asset(Images.logo),
              ),
              const Spacer(),
              badgeFavorito,
              const SizedBox(width: 30),
              badgeCarrinho,
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 54,
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: blue.withOpacity(0.23),
                  ),
                ]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) async {
                      List<ProdutoModel> produtos =
                          await ProdutoService.getProdutosPorNome(
                              value, userId);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProdutosScreen(
                                produtos: produtos,
                              )));
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      hintText: "Procurar",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: blue.withOpacity(0.5),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  static AppBar buildAppBar(context, title, avatar) {
    return AppBar(
      title: Text(title),
      titleTextStyle: const TextStyle(
          color: blue, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: blue, size: 30),
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserScreen()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
                signOut();
              }
            },
            position: PopupMenuPosition.under,
            color: blue,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Meus dados',
                    style: TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Sair',
                    style: TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ],
            icon: avatar != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(avatar),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 40,
                    color: blue,
                  ),
          ),
        )
      ],
    );
  }

  static Drawer buildDrawer(context, userid, departamentos) {
    return Drawer(
      backgroundColor: blue,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 70.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: lightYellow,
              ),
              child: Text('Departamentos',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
          ),
          ...departamentos.map((departamento) => ListTile(
                title: Text(departamento.nome,
                    style: const TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                onTap: () async {
                  List<ProdutoModel> produtos =
                      await ProdutoService.getProdutosPorDepartamento(
                          departamento.id, userid);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProdutosScreen(
                            produtos: produtos,
                          )));
                },
              )),
        ],
      ),
    );
  }
}
