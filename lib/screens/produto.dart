import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/produto_carrinho.dart';
import 'package:stock/models/produto_detalhe.dart';
import 'package:stock/screens/carrinho.dart';
import 'package:stock/screens/home.dart';
import 'package:stock/services/carrinho_service.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/widgets/header.dart';

class ProdutoScreen extends StatefulWidget {
  const ProdutoScreen({Key? key, required this.produto}) : super(key: key);

  final ProdutoDetalheModel produto;

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  String userId = '';
  String userAvatar = '';
  double nota = 0;
  List<DepartamentoModel> departamentos = [];

  @override
  void initState() {
    getDepartamentos();
    getUsuario();
    getNotaMedia();
    super.initState();
  }

  Future getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userAvatar = prefs.getString('avatar')!;
    setState(() {});
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  getNotaMedia() {
    for (var avaliacao in widget.produto.avaliacoes!) {
      nota = nota + avaliacao.nota!;
    }
    nota = nota / widget.produto.avaliacoes!.length;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar:
            HeaderWidget.buildAppBar(context, "Detalhe do produto", userAvatar),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      padding: const EdgeInsets.all(20.0 / 4),
                      height: 400,
                      width: 500,
                      decoration: BoxDecoration(
                        color: lightYellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Image.network(widget.produto.imagem!,
                              width: 500, height: 230),
                          const SizedBox(height: 20),
                          Text(
                            widget.produto.nome!,
                            style: const TextStyle(
                              fontSize: 30,
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar.builder(
                                initialRating: nota,
                                minRating: 0,
                                direction: Axis.horizontal,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.zero,
                                itemSize: 20,
                                itemBuilder: (context, _) =>
                                    const Icon(Icons.star, color: blue),
                                onRatingUpdate: (rating) {},
                              ),
                              Text(
                                '| Cod. ${widget.produto.id}',
                                style: const TextStyle(fontSize: 10.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ProdutoCarrinhoModel produtoCarrinho =
                                        ProdutoCarrinhoModel(
                                            id: null,
                                            quantidade: 1,
                                            produto: widget.produto,
                                            usuarioId: userId);
                                    await CarrinhoService.postCarrinho(
                                        produtoCarrinho);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  },
                                  child: const Icon(
                                      Icons.shopping_cart_checkout,
                                      size: 30),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ProdutoCarrinhoModel produtoCarrinho =
                                        ProdutoCarrinhoModel(
                                            id: null,
                                            quantidade: 1,
                                            produto: widget.produto,
                                            usuarioId: userId);
                                    CarrinhoModel carrinhoResposta =
                                        await CarrinhoService.postCarrinho(
                                            produtoCarrinho);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CarrinhoScreen(
                                                    carrinho:
                                                        carrinhoResposta)));
                                  },
                                  child: const Text(
                                    'Comprar',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25),
              alignment: Alignment.topLeft,
              child: const Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 30,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20.0 / 4),
              height: 100,
              width: width - 40,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(widget.produto.descricao!,
                  style: const TextStyle(fontSize: 15)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 25),
              alignment: Alignment.topLeft,
              child: const Text(
                'Avaliações',
                style: TextStyle(
                  fontSize: 30,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            widget.produto.avaliacoes!.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(20.0 / 4),
                    height: 100,
                    width: width - 40,
                    decoration: BoxDecoration(
                      color: lightYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Esse produto ainda não possui avaliações',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ))
                : Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListView.builder(
                          itemCount: widget.produto.avaliacoes!.length,
                          itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.all(20.0 / 4),
                            height: 100,
                            width: width - 40,
                            decoration: BoxDecoration(
                              color: lightYellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBar.builder(
                                  initialRating: widget
                                      .produto.avaliacoes![index].nota!
                                      .toDouble(),
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.zero,
                                  itemSize: 15,
                                  itemBuilder: (context, _) =>
                                      const Icon(Icons.star, color: blue),
                                  onRatingUpdate: (rating) {},
                                ),
                                const SizedBox(height: 5),
                                Text(
                                    widget
                                        .produto.avaliacoes![index].descricao!,
                                    style: const TextStyle(fontSize: 25)),
                                const SizedBox(height: 15),
                                Text(
                                    'Avaliação feita por: ${widget.produto.avaliacoes![index].idUsuario!.nome!} em ${widget.produto.avaliacoes![index].data!}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ))),
          ],
        ),
        drawer: HeaderWidget.buildDrawer(context, userId, departamentos));
  }
}
