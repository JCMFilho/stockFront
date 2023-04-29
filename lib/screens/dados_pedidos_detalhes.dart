import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/pedido.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/pedido_item.dart';
import 'package:stock/models/produto_carrinho.dart';
import 'package:stock/screens/carrinho.dart';
import 'package:stock/services/carrinho_service.dart';
import 'package:stock/services/departamento_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/services/pedido_service.dart';
import 'package:stock/widgets/header.dart';

class DadosPedidosDetalhesScreen extends StatefulWidget {
  const DadosPedidosDetalhesScreen({
    Key? key,
    required this.pedido,
  }) : super(key: key);

  final PedidoModel pedido;

  @override
  State<DadosPedidosDetalhesScreen> createState() =>
      _DadosPedidosDetalhesScreenState();
}

class _DadosPedidosDetalhesScreenState
    extends State<DadosPedidosDetalhesScreen> {
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userAvatar = '';

  @override
  void initState() {
    getDepartamentos();
    getUsuario();
    super.initState();
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  Future getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userAvatar = prefs.getString('avatar')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color color = green;
    if (widget.pedido.status == "Cancelado" ||
        widget.pedido.status == "Devolvido") {
      color = red;
    }
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(
          context, 'Meus pedidos - detalhes', userAvatar),
      body: Container(
          padding: const EdgeInsets.only(top: 40, right: 100, left: 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido número: ${widget.pedido.id}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: lightYellow),
                  ),
                  Text(
                    widget.pedido.status!,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: widget.pedido.items!.length,
                itemBuilder: (context, index) => PedidoDetalheCard(
                  pedido: widget.pedido,
                  pedidoItem: widget.pedido.items![index],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total R\$ ${widget.pedido.total},00',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: lightYellow),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: lightYellow,
                        foregroundColor: blue,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () async {
                      CarrinhoModel carrinhoResposta = CarrinhoModel(
                          id: null,
                          idUsuario: null,
                          total: null,
                          produtos: null);
                      for (var produto in widget.pedido.items!) {
                        ProdutoCarrinhoModel produtoCarrinho =
                            ProdutoCarrinhoModel(
                                id: null,
                                quantidade: produto.quantidade,
                                produto: produto.produto,
                                usuarioId: userId);
                        carrinhoResposta =
                            await CarrinhoService.postCarrinho(produtoCarrinho);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CarrinhoScreen(carrinho: carrinhoResposta)));
                    },
                    child: const Text('Comprar novamente'),
                  )
                ],
              )
            ],
          )),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class PedidoDetalheCard extends StatelessWidget {
  const PedidoDetalheCard({
    Key? key,
    required this.pedido,
    required this.pedidoItem,
  }) : super(key: key);

  final PedidoModel pedido;
  final PedidoItemModel pedidoItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.network(pedidoItem.produto!.imagem!, width: 150, height: 150),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  pedidoItem.produto!.nome!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Text('Quantidade: ${pedidoItem.quantidade} - '),
                    Text(
                      'R\$ ${pedidoItem.produto!.preco},00 cada',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
            Visibility(
              visible:
                  pedido.status != "Cancelado" && pedido.status != "Devolvido",
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () async {
                  PedidoPutModel pedidoStatus =
                      PedidoPutModel(idPedido: pedido.id, status: "Devolvido");
                  PedidoService.putPedido(pedidoStatus);
                  pedido.status = "Devolvido";
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DadosPedidosDetalhesScreen(pedido: pedido)));
                },
                child: const Text('Devolver item'),
              ),
            )
          ]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
