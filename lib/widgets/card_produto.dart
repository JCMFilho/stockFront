import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/favorito.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/models/produto_carrinho.dart';
import 'package:stock/models/produto_detalhe.dart';
import 'package:stock/screens/carrinho.dart';
import 'package:stock/screens/produto.dart';
import 'package:stock/screens/produtos.dart';
import 'package:stock/services/carrinho_service.dart';
import 'package:stock/services/favorito_service.dart';
import 'package:stock/services/produto_service.dart';

class CardProdutoWidget extends StatelessWidget {
  const CardProdutoWidget(
      {Key? key,
      required this.produtos,
      required this.userId,
      required this.userRole})
      : super(key: key);

  final List<ProdutoModel> produtos;
  final String userId;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: List.generate(
            produtos.length,
            (index) => ImageCard(
                produto: produtos[index],
                produtos: produtos,
                userId: userId,
                userRole: userRole),
          ),
        ));
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard(
      {Key? key,
      required this.produto,
      required this.produtos,
      required this.userId,
      required this.userRole})
      : super(key: key);

  final ProdutoModel produto;
  final List<ProdutoModel> produtos;
  final String userId;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ProdutoDetalheModel produtoDetalhe =
            await ProdutoService.getProduto(produto.id!);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProdutoScreen(
                  produto: produtoDetalhe,
                )));
      },
      child: SizedBox(
        height: 300,
        width: 300,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(5.0),
                height: 270,
                width: 200,
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topRight,
                        child: produto.isFavorito == false
                            ? IconButton(
                                icon: const Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                  color: red,
                                ),
                                onPressed: () async {
                                  FavoritoModel favorito = FavoritoModel(
                                      idUsuario: userId, idProduto: produto.id);
                                  FavoritoRetornoModel retornoFavorito =
                                      await FavoritoService.postFavorito(
                                          favorito);
                                  produto.isFavorito = true;
                                  produto.favoritoId = retornoFavorito.id;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProdutosScreen(produtos: produtos)));
                                },
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: red,
                                ),
                                onPressed: () async {
                                  await FavoritoService.deleteFavoritoPorId(
                                      produto.favoritoId!);
                                  produto.isFavorito = false;
                                  produto.favoritoId = null;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ProdutosScreen(produtos: produtos)));
                                },
                              )),
                    Image.network(produto.imagem ?? '',
                        width: 150, height: 100),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          produto.nome ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        Text(
                          ' | Cod. ${produto.id}',
                          style: const TextStyle(fontSize: 10.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'R\$ ${produto.preco},00',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: white,
                            padding: const EdgeInsets.all(16.0)),
                        onPressed: () async {
                          if (userRole != 'admin') {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String userId = prefs.getString('id')!;
                            ProdutoDetalheModel produtoDetalhe =
                                await ProdutoService.getProduto(produto.id!);
                            ProdutoCarrinhoModel produtoCarrinho =
                                ProdutoCarrinhoModel(
                                    id: null,
                                    quantidade: 1,
                                    produto: produtoDetalhe,
                                    usuarioId: userId);
                            await CarrinhoService.postCarrinho(produtoCarrinho);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProdutosScreen(produtos: produtos)));
                          }
                        },
                        child:
                            const Icon(Icons.shopping_cart_checkout, size: 18),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () async {
                          if (userRole != 'admin') {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String userId = prefs.getString('id')!;
                            ProdutoDetalheModel produtoDetalhe =
                                await ProdutoService.getProduto(produto.id!);
                            ProdutoCarrinhoModel produtoCarrinho =
                                ProdutoCarrinhoModel(
                                    id: null,
                                    quantidade: 1,
                                    produto: produtoDetalhe,
                                    usuarioId: userId);
                            CarrinhoModel carrinho =
                                await CarrinhoService.postCarrinho(
                                    produtoCarrinho);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CarrinhoScreen(carrinho: carrinho)));
                          }
                        },
                        child: const Text('Comprar'),
                      )
                    ])
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
