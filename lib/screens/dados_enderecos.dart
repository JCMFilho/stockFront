import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/endereco.dart';
import 'package:stock/screens/enderecos.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/endereco_service.dart';
import 'package:stock/widgets/header.dart';

class DadosEnderecosScreen extends StatefulWidget {
  const DadosEnderecosScreen({
    Key? key,
    required this.endereco,
  }) : super(key: key);

  final EnderecoModel endereco;

  @override
  State<DadosEnderecosScreen> createState() => _DadosEnderecosScreenState();
}

class _DadosEnderecosScreenState extends State<DadosEnderecosScreen> {
  List<DepartamentoModel> departamentos = [];
  String userAvatar = '';
  String validacao = '';

  @override
  void initState() {
    getUser();
    getDepartamentos();
    super.initState();
  }

  Future getDepartamentos() async {
    departamentos = await DepartamentoService.getDepartamentos();
    setState(() {});
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.endereco.usuarioId = prefs.getString('id')!;
    userAvatar = prefs.getString('avatar')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderWidget.buildAppBar(context, 'Endereço', userAvatar),
        body: Container(
          alignment: Alignment.center,
          child: buildSizedBox(context, widget.endereco),
        ),
        drawer: HeaderWidget.buildDrawer(
            context, widget.endereco.usuarioId, departamentos));
  }

  SizedBox buildSizedBox(context, endereco) {
    TextEditingController tipoController =
        TextEditingController(text: endereco.tipo);
    TextEditingController logradouroController =
        TextEditingController(text: endereco.logradouro);
    TextEditingController numeroController =
        TextEditingController(text: endereco.numero);
    TextEditingController bairroController =
        TextEditingController(text: endereco.bairro);
    TextEditingController cidadeController =
        TextEditingController(text: endereco.cidade);
    TextEditingController estadoController =
        TextEditingController(text: endereco.estado);
    TextEditingController cepController =
        TextEditingController(text: endereco.cep);
    return SizedBox(
      width: MediaQuery.of(context).size.height,
      child: Container(
        height: 350,
        width: 800,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: TextField(
                    controller: tipoController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'Tipo',
                        labelText: 'Tipo',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: TextField(
                    controller: logradouroController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'Logradouro',
                        labelText: 'Logradouro',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: SizedBox(
                  child: TextField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'Número',
                        labelText: 'Número',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Bairro',
                      labelText: 'Bairro',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  controller: cidadeController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Cidade',
                      labelText: 'Cidade',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: estadoController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Estado',
                      labelText: 'Estado',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  maxLength: 10,
                  controller: cepController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Cep',
                      labelText: 'Cep',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(validacao,
              style: const TextStyle(
                color: red,
              )),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              if (tipoController.text != '' &&
                  logradouroController.text != '' &&
                  numeroController.text != '' &&
                  bairroController.text != '' &&
                  cidadeController.text != '' &&
                  estadoController.text != '' &&
                  cepController.text != '') {
                endereco.tipo = tipoController.text;
                endereco.logradouro = logradouroController.text;
                endereco.numero = numeroController.text;
                endereco.bairro = bairroController.text;
                endereco.cidade = cidadeController.text;
                endereco.estado = estadoController.text;
                endereco.cep = cepController.text;
                EnderecoModel enderecoResposta =
                    await EnderecoService.postEndereco(endereco);
                if (enderecoResposta.id != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EnderecosScreen()));
                } else {
                  setState(() {
                    validacao =
                        'Erro ao cadastrar endereço. Tente novamente mais tarde';
                  });
                }
              } else {
                setState(() {
                  validacao = 'Preencha todos os campos';
                });
              }
            },
            child: const Text('Salvar'),
          ),
        ]),
      ),
    );
  }
}
