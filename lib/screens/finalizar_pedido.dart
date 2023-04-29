import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/carrinho.dart';
import 'package:stock/models/departamento.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/models/endereco.dart';
import 'package:stock/models/pedido.dart';
import 'package:stock/screens/dados_enderecos.dart';
import 'package:stock/screens/dados_pedidos.dart';
import 'package:stock/screens/enderecos.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/endereco_service.dart';
import 'package:stock/services/pedido_service.dart';
import 'package:stock/widgets/header.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class FinalizarPedidoScreen extends StatefulWidget {
  const FinalizarPedidoScreen(
      {Key? key, required this.carrinho, required this.total})
      : super(key: key);

  final int total;
  final CarrinhoModel carrinho;

  @override
  State<FinalizarPedidoScreen> createState() => _FinalizarPedidoScreenState();
}

class _FinalizarPedidoScreenState extends State<FinalizarPedidoScreen> {
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userAvatar = '';
  EnderecoModel endereco = EnderecoModel(
      id: null,
      usuarioId: null,
      tipo: null,
      logradouro: null,
      numero: null,
      bairro: null,
      cidade: null,
      estado: null,
      cep: null,
      enderecoPrincipal: null);

  @override
  void initState() {
    getUsuario();
    getDepartamentos();
    super.initState();
  }

  Future getEnderecoPrincipal(userId) async {
    endereco = await EnderecoService.getEnderecoPrincipalPorUser(userId);
    setState(() {});
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  Future getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id')!;
    userAvatar = prefs.getString('avatar')!;
    getEnderecoPrincipal(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Finalizar pedido', userAvatar),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  Row(
                    children: [
                      SelecionarEndereco(
                        width: (width / 2) - 70,
                        endereco: endereco,
                      ),
                      const SizedBox(width: 20),
                      ExibirResumo(
                          width: (width / 2) - 70,
                          carrinho: widget.carrinho,
                          total: widget.total)
                    ],
                  ),
                  const SizedBox(height: 20),
                  SelecionarFrete(width: width - 40),
                  const SizedBox(height: 20),
                  SelecionarPagamento(width: width - 40),
                  const SizedBox(height: 20),
                  TextButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: lightYellow,
                        foregroundColor: blue,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () async {
                      PedidoPostModel pedido = PedidoPostModel(
                          idUsuario: userId,
                          idCarrinho: widget.carrinho.id,
                          frete: valorFrete.value.name,
                          total: widget.total.toString());
                      await PedidoService.postPedido(pedido);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DadosPedidosScreen()));
                    },
                    child: const Text('Finalizar pedido'),
                  )
                ],
              ))),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class SelecionarEndereco extends StatelessWidget {
  const SelecionarEndereco(
      {Key? key, required this.width, required this.endereco})
      : super(key: key);

  final double width;
  final EnderecoModel endereco;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 200,
        width: width,
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Endereço de entrega',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Text(
                    '${endereco.tipo} ${endereco.logradouro}, ${endereco.numero}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(' - Bairro ${endereco.bairro} - Cidade ${endereco.cidade}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(' - Estado ${endereco.estado} - CEP ${endereco.cep}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EnderecosScreen()));
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                backgroundColor: transparent,
              ),
              child: const Text(
                'Alterar endereço principal',
                style: TextStyle(
                  color: blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                EnderecoModel novoEndereco = EnderecoModel(
                    id: null,
                    usuarioId: null,
                    tipo: null,
                    logradouro: null,
                    numero: null,
                    bairro: null,
                    cidade: null,
                    estado: null,
                    cep: null,
                    enderecoPrincipal: null);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        DadosEnderecosScreen(endereco: novoEndereco)));
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                backgroundColor: transparent,
              ),
              child: const Text(
                'Adicionar novo endereço de entrega',
                style: TextStyle(
                  color: blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ));
  }
}

enum ValorFrete { cinco, dez, quinze }

final valorFrete = ValueNotifier<ValorFrete>(ValorFrete.cinco);

class SelecionarFrete extends StatelessWidget {
  const SelecionarFrete({Key? key, required this.width}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        width: width,
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Opções de frete',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ValueListenableBuilder<ValorFrete>(
                    valueListenable: valorFrete,
                    builder: (context, value, _) => Radio(
                      value: ValorFrete.cinco,
                      groupValue: value,
                      onChanged: (value) {
                        valorFrete.value = ValorFrete.cinco;
                      },
                    ),
                  ),
                  const Text('Pac',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  const Text('R\$5,00'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ValueListenableBuilder<ValorFrete>(
                    valueListenable: valorFrete,
                    builder: (context, value, _) => Radio(
                      value: ValorFrete.dez,
                      groupValue: value,
                      onChanged: (value) {
                        valorFrete.value = ValorFrete.dez;
                      },
                    ),
                  ),
                  const Text('Sedex',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  const Text('R\$10,00'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ValueListenableBuilder<ValorFrete>(
                    valueListenable: valorFrete,
                    builder: (context, value, _) => Radio(
                      value: ValorFrete.quinze,
                      groupValue: value,
                      onChanged: (value) {
                        valorFrete.value = ValorFrete.quinze;
                      },
                    ),
                  ),
                  const Text('Transportadora',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  const Text('R\$15,00'),
                ],
              ),
            ],
          ),
        ));
  }
}

class SelecionarPagamento extends StatelessWidget {
  const SelecionarPagamento({Key? key, required this.width}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        height: 350,
        width: width,
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: lightYellow,
            appBar: const TabBar(
              labelColor: black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              tabs: [
                Tab(
                  text: 'Boleto',
                ),
                Tab(
                  text: 'Pix',
                ),
              ],
            ),
            body: TabBarView(
              children: [
                Scaffold(
                    backgroundColor: lightYellow,
                    body: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Use o código de barras abaixo para pagar o pedido. O pagamento será processado em até 3 dias úteis.'),
                        const SizedBox(height: 30),
                        SizedBox(
                            height: 100,
                            width: width / 2,
                            child: SfBarcodeGenerator(
                                value: 'http://www.syncfusion.com'))
                      ],
                    ))),
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'Use o qr code abaixo para pagar o pedido. O pagamento será processado em até 1 dia útil.'),
                    const SizedBox(height: 30),
                    SizedBox(
                        height: 100,
                        width: width / 2,
                        child: SfBarcodeGenerator(
                            value: 'http://www.syncfusion.com',
                            symbology: QRCode()))
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}

class ExibirResumo extends StatelessWidget {
  const ExibirResumo(
      {Key? key,
      required this.width,
      required this.carrinho,
      required this.total})
      : super(key: key);

  final double width;
  final int total;
  final CarrinhoModel carrinho;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 200,
        width: width,
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do pedido',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
              itemCount: carrinho.produtos!.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(carrinho.produtos![index].produto!.nome!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                          'Quantidade: ${carrinho.produtos![index].quantidade} - '),
                      Text(
                          'Total R\$ ${carrinho.produtos![index].produto!.preco! * carrinho.produtos![index].quantidade!},00'),
                      Text(
                          ' (R\$ ${carrinho.produtos![index].produto!.preco},00 cada)',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total R\$$total,00',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )
          ],
        ));
  }
}
