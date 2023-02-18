import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/produto.dart';
import 'package:stock/screens/dados_produtos.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/produto_service.dart';
import 'package:stock/widgets/header.dart';

class ProdutosAdminScreen extends StatefulWidget {
  const ProdutosAdminScreen({Key? key}) : super(key: key);

  @override
  State<ProdutosAdminScreen> createState() => _ProdutosAdminScreenState();
}

class _ProdutosAdminScreenState extends State<ProdutosAdminScreen> {
  List<ProdutoModel> produtos = [];
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userAvatar = '';

  @override
  void initState() {
    getUsuario();
    getDepartamentos();
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
    produtos = await ProdutoService.getProdutos(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Meus produtos', userAvatar),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, right: 25.0, bottom: 50.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_box_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ProdutoModel produto = ProdutoModel(
                        id: null,
                        nome: null,
                        estoque: null,
                        descricao: null,
                        totalAcessos: null,
                        imagem: null,
                        preco: null,
                        departamentoId: null,
                        departamento: null,
                        isFavorito: null,
                        favoritoId: null);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DadosProdutosScreen(produto: produto)));
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) =>
                  ProdutoCard(produto: produtos[index]),
            ),
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
    required this.produto,
  }) : super(key: key);

  final ProdutoModel produto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              height: 200,
              width: 800,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    produto.imagem!,
                    width: 200,
                    height: 100,
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                      width: 490,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(produto.nome ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                          Row(
                            children: [
                              const Text('Departamento: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(produto.departamento ?? '',
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Descrição: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                  width: 420,
                                  child: Text(
                                    produto.descricao ?? '',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Estoque: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(produto.estoque.toString(),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Preço: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                'R\$ ${produto.preco},00',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        ],
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DadosProdutosScreen(produto: produto)));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outlined,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              bool resposta;
                              return Container(
                                height: 200,
                                color: lightYellow,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        'Deseja excluir esse produto?',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 25),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              child: const Text('Sim'),
                                              onPressed: () async => {
                                                    resposta =
                                                        await ProdutoService
                                                            .deleteProdutoPorId(
                                                                produto.id!),
                                                    if (resposta)
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ProdutosAdminScreen()))
                                                  }),
                                          const SizedBox(width: 25),
                                          ElevatedButton(
                                            child: const Text('Não'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
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
