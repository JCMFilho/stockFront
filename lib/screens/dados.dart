import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/models/usuario.dart';
import 'package:stock/screens/user.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/widgets/header.dart';

class DadosScreen extends StatefulWidget {
  const DadosScreen({Key? key}) : super(key: key);

  @override
  State<DadosScreen> createState() => _DadosScreenState();
}

class _DadosScreenState extends State<DadosScreen> {
  UsuarioModel user =
      UsuarioModel(id: null, nome: null, email: null, dataCadastro: null);
  List<DepartamentoModel> departamentos = [];
  String userAvatar = '';
  String validacao = '';

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
    String id = prefs.getString('id')!;
    user = await UserService.getUsuario(id);
    userAvatar = prefs.getString('avatar')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Meus dados', userAvatar),
      body: Container(
        alignment: Alignment.center,
        child: buildSizedBox(context, user),
      ),
      drawer: HeaderWidget.buildDrawer(context, user.id, departamentos),
    );
  }

  SizedBox buildSizedBox(context, user) {
    TextEditingController cfpController = TextEditingController(text: user.cpf);
    TextEditingController rgController = TextEditingController(text: user.rg);
    TextEditingController nomeController =
        TextEditingController(text: user.nome);
    TextEditingController celularController =
        TextEditingController(text: user.celular);
    TextEditingController telefoneController =
        TextEditingController(text: user.telefone);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController senhaController = TextEditingController();
    TextEditingController confirmaSenhaController = TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.height,
      child: Container(
        height: 600,
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
                child: TextField(
                  maxLength: 11,
                  controller: cfpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'CPF',
                      labelText: 'CPF',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: rgController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'RG',
                      labelText: 'RG',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ],
          ),
          TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Insira nome completo',
                  labelText: 'Nome',
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
          TextField(
            controller: emailController,
            enabled: false,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Insira email',
                labelText: 'Email',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 11,
                  controller: celularController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Insira o celular',
                      labelText: 'Celular',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: telefoneController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Insira o telefone',
                      labelText: 'Telefone',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: senhaController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Insira sua senha',
                      labelText: 'Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextFormField(
                  controller: confirmaSenhaController,
                  validator: (val) {
                    if (val != senhaController.text) {
                      return 'As senhas não conferem';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Confirme sua senha',
                      labelText: 'Confirmação de senha',
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
              user.cpf = cfpController.text;
              user.rg = rgController.text;
              if (nomeController.text.contains(' ')) {
                user.nome = nomeController.text;
              } else {
                setState(() {
                  validacao = 'Digite pelo menos um sobrenome';
                });
                return;
              }
              user.telefone = telefoneController.text;
              user.celular = celularController.text;
              if (senhaController.text != '') {
                if (senhaController.text.length < 8) {
                  setState(() {
                    validacao = 'Senha deve conter pelo menos 8 caracteres';
                  });
                  return;
                }
                user.senha = senhaController.text;
              } else {
                user.senha = '';
              }
              UsuarioModel userResposta = await UserService.putUsuario(user);
              if (userResposta.id != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserScreen()));
              } else {
                setState(() {
                  validacao =
                      'Erro ao cadastrar endereço. Tente novamente mais tarde';
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
