import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/produto.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CardProdutoWidget extends StatelessWidget {
  const CardProdutoWidget({Key? key, required this.produtos}) : super(key: key);

  final List<ProdutoModel> produtos;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: List.generate(
            produtos.length,
            (index) => ImageCard(
              produto: produtos[index],
              press: () {},
            ),
          ),
        ));
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.produto,
    required this.press,
  }) : super(key: key);

  final ProdutoModel? produto;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 350,
        width: 300,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(5.0),
                height: 250,
                width: 200,
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topRight,
                        child: produto!.isFavorito == false
                            ? const Icon(
                                Icons.favorite_border,
                                size: 20,
                                color: red,
                              )
                            : const Icon(
                                Icons.favorite,
                                size: 20,
                                color: red,
                              )),
                    Image.network(produto!.imagem ?? '',
                        width: 150, height: 100),
                    const SizedBox(height: 5),
                    Text(
                      produto!.nome ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 15,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: blue),
                          onRatingUpdate: (rating) {},
                        ),
                        Text(
                          '| Cod. ${produto!.id}',
                          style: const TextStyle(fontSize: 10.0),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'R\$ ${produto!.preco},00',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0)),
                        onPressed: () {},
                        child:
                            const Icon(Icons.shopping_cart_checkout, size: 18),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {},
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
