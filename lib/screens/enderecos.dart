import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/endereco.dart';
import 'package:stock/screens/dados_enderecos.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/endereco_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/widgets/header.dart';

class EnderecosScreen extends StatefulWidget {
  const EnderecosScreen({Key? key}) : super(key: key);

  @override
  State<EnderecosScreen> createState() => _EnderecosScreenState();
}

class _EnderecosScreenState extends State<EnderecosScreen> {
  List<EnderecoModel> enderecos = [];
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
    enderecos = await EnderecoService.getEnderecoPorUser(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Meus endereços', userAvatar),
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
                    EnderecoModel endereco = EnderecoModel(
                        id: null,
                        usuarioId: null,
                        tipo: null,
                        logradouro: null,
                        numero: null,
                        bairro: null,
                        cidade: null,
                        estado: null,
                        cep: null);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DadosEnderecosScreen(endereco: endereco)));
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: enderecos.length,
              itemBuilder: (context, index) =>
                  EnderecoCard(endereco: enderecos[index]),
            ),
          )
        ],
      ),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class EnderecoCard extends StatelessWidget {
  const EnderecoCard({
    Key? key,
    required this.endereco,
  }) : super(key: key);
  final EnderecoModel endereco;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              height: 100,
              width: 800,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Text(endereco.tipo ?? '',
                              overflow: TextOverflow.ellipsis)),
                      const Text(' '),
                      Flexible(
                          child: Text(endereco.logradouro ?? '',
                              overflow: TextOverflow.ellipsis)),
                      const Text(', '),
                      Flexible(
                          child: Text(endereco.numero ?? '',
                              overflow: TextOverflow.ellipsis)),
                      const Text(' - Bairro '),
                      Flexible(
                          child: Text(endereco.bairro ?? '',
                              overflow: TextOverflow.ellipsis)),
                      const Text(' - Cidade '),
                      Flexible(
                          child: Text(endereco.cidade ?? '',
                              overflow: TextOverflow.ellipsis)),
                      const Text(' - Estado '),
                      Flexible(
                          child: Text(endereco.estado ?? '',
                              overflow: TextOverflow.ellipsis)),
                      const Text(' - CEP '),
                      Flexible(
                          child: Text(endereco.cep ?? '',
                              overflow: TextOverflow.ellipsis))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                                  DadosEnderecosScreen(endereco: endereco)));
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
                                        'Deseja excluir esse endereço?',
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
                                                        await EnderecoService
                                                            .deleteEnderecoPorId(
                                                                endereco.id!),
                                                    if (resposta)
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const EnderecosScreen()))
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
