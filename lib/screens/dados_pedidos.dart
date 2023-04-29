import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/pedido.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/screens/dados_pedidos_detalhes.dart';
import 'package:stock/services/departamento_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/services/pedido_service.dart';
import 'package:stock/widgets/header.dart';

class DadosPedidosScreen extends StatefulWidget {
  const DadosPedidosScreen({Key? key}) : super(key: key);

  @override
  State<DadosPedidosScreen> createState() => _DadosPedidosScreenState();
}

class _DadosPedidosScreenState extends State<DadosPedidosScreen> {
  List<PedidoModel> pedidos = [];
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
    pedidos = await PedidoService.getPedidoPorUser(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Meus pedidos', userAvatar),
      body: Container(
        padding: const EdgeInsets.only(top: 50, right: 100, left: 100),
        child: ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) => PedidoCard(pedido: pedidos[index]),
        ),
      ),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class PedidoCard extends StatelessWidget {
  const PedidoCard({Key? key, required this.pedido}) : super(key: key);

  final PedidoModel pedido;

  @override
  Widget build(BuildContext context) {
    Color color = green;
    if (pedido.status == "Cancelado" || pedido.status == "Devolvido") {
      color = red;
    }
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Pedido número: ${pedido.id}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  pedido.status!,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  'Total R\$ ${pedido.total}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )
              ]),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DadosPedidosDetalhesScreen(pedido: pedido)));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    backgroundColor: transparent,
                  ),
                  child: const Text(
                    'Ver detalhes',
                    style: TextStyle(
                      color: blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
                Visibility(
                  visible: pedido.status != "Cancelado" &&
                      pedido.status != "Devolvido",
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: blue,
                      foregroundColor: white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      PedidoPutModel pedidoStatus = PedidoPutModel(
                          idPedido: pedido.id, status: "Cancelado");
                      PedidoService.putPedido(pedidoStatus);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DadosPedidosScreen()));
                    },
                    child: const Text('Cancelar pedido'),
                  ),
                )
              ])
            ],
          )),
      const SizedBox(height: 10),
    ]);
  }
}
