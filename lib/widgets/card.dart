import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/screens/produtos.dart';
import 'package:stock/services/produto_service.dart';

import '../models/promocao.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.promocaoCategories,
    required this.userId,
    required this.width,
    required this.height,
  }) : super(key: key);

  final List<PromocaoModel> promocaoCategories;
  final String userId;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0 / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          promocaoCategories.length,
          (index) => ImageCard(
            icon: promocaoCategories[index].imagem,
            press: () async {
              List<ProdutoModel> produtos =
                  await ProdutoService.getProdutosPorDepartamento(
                      promocaoCategories[index].departamentoId ?? 0, userId);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProdutosScreen(
                        produtos: produtos,
                      )));
            },
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.icon,
    required this.press,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String? icon;
  final GestureTapCallback press;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0 / 4),
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(icon!),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
