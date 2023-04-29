import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/produto_carrinho.dart';
import 'package:stock/screens/finalizar_pedido.dart';
import 'package:stock/screens/home.dart';
import 'package:stock/services/carrinho_service.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/widgets/header.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({Key? key, required this.carrinho}) : super(key: key);

  final CarrinhoModel carrinho;
  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userRole = '';
  String userAvatar = '';
  final total = ValueNotifier<int>(0);

  @override
  void initState() {
    getDepartamentos();
    getUsuario();
    getTotal();
    super.initState();
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  Future getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userRole = prefs.getString('role')!;
    userAvatar = prefs.getString('avatar')!;
    setState(() {});
  }

  getTotal() {
    for (var produtoCarrinho in widget.carrinho.produtos!) {
      total.value = total.value +
          (produtoCarrinho.quantidade! * produtoCarrinho.produto!.preco!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.carrinho.produtos!.isEmpty) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }

    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Meu carrinho', userAvatar),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: widget.carrinho.produtos!.length,
              itemBuilder: (context, index) => ProdutoCard(
                  carrinho: widget.carrinho,
                  produtoCarrinho: widget.carrinho.produtos![index],
                  userId: userId,
                  userRole: userRole),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Container(
                padding: const EdgeInsets.all(20.0 / 4),
                height: 50,
                width: 800,
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        backgroundColor: transparent,
                      ),
                      child: const Text(
                        'Continuar comprando',
                        style: TextStyle(
                          color: blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: total,
                      builder: (context, value, child) {
                        return Text(
                          'Total R\$ ${value.toString()},00',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        );
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: blue,
                        foregroundColor: white,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FinalizarPedidoScreen(
                                carrinho: widget.carrinho,
                                total: total.value)));
                      },
                      child: const Text('Finalizar compra'),
                    )
                  ],
                )),
          )
        ],
      ),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class ProdutoCard extends StatelessWidget {
  const ProdutoCard({
    Key? key,
    required this.carrinho,
    required this.produtoCarrinho,
    required this.userId,
    required this.userRole,
  }) : super(key: key);

  final CarrinhoModel carrinho;
  final ProdutoCarrinhoModel produtoCarrinho;
  final String userId;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    final quantidade = ValueNotifier<int>(produtoCarrinho.quantidade!);
    final total = ValueNotifier<int>(
        produtoCarrinho.produto!.preco! * produtoCarrinho.quantidade!);
    double nota = 0;
    produtoCarrinho.produto?.avaliacoes!
        .map((avalicao) => nota = nota + avalicao.nota!);
    nota = nota / produtoCarrinho.produto!.avaliacoes!.length;
    produtoCarrinho.usuarioId = userId;

    return GestureDetector(
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              height: 200,
              width: 800,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(produtoCarrinho.produto!.imagem!,
                      width: 150, height: 150),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            produtoCarrinho.produto!.nome ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Text(
                            ' | Cod. ${produtoCarrinho.produto!.id}',
                            style: const TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text('Quantidade'),
                          const SizedBox(width: 10),
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (quantidade.value > 1) {
                                        quantidade.value--;
                                        produtoCarrinho.quantidade =
                                            quantidade.value;
                                        total.value =
                                            produtoCarrinho.produto!.preco! *
                                                produtoCarrinho.quantidade!;
                                        await CarrinhoService.putCarrinho(
                                            produtoCarrinho);
                                      }
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  ValueListenableBuilder<int>(
                                    valueListenable: quantidade,
                                    builder: (context, value, child) {
                                      return Text(
                                        value.toString(),
                                        style: const TextStyle(fontSize: 18),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      quantidade.value++;
                                      produtoCarrinho.quantidade =
                                          quantidade.value;
                                      total.value =
                                          produtoCarrinho.produto!.preco! *
                                              produtoCarrinho.quantidade!;
                                      await CarrinhoService.putCarrinho(
                                          produtoCarrinho);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              )),
                          const SizedBox(width: 10),
                          Text(
                            'R\$${produtoCarrinho.produto!.preco},00 cada',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outlined,
                          size: 30,
                          color: black,
                        ),
                        onPressed: () async {
                          await CarrinhoService.deleteCarrinho(produtoCarrinho);
                          CarrinhoModel carrinho =
                              await CarrinhoService.getCarrinhoPorUser(userId);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CarrinhoScreen(carrinho: carrinho)));
                        },
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: total,
                        builder: (context, value, child) {
                          return Text(
                            'Total R\$${value.toString()},00',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
