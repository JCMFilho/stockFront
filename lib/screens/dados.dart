import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/usuario.dart';
import 'package:stock/services/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DadosScreen extends StatefulWidget {
  const DadosScreen({Key? key}) : super(key: key);

  @override
  State<DadosScreen> createState() => _DadosScreenState();
}

class _DadosScreenState extends State<DadosScreen> {
  UsuarioModel user =
      UsuarioModel(id: null, nome: null, email: null, dataCadastro: null);
  @override
  void initState() {
    getUsuario();
    super.initState();
  }

  Future<void> getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    user = await UserService.getUsuario(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        alignment: Alignment.center,
        child: buildSizedBox(context, user),
      ),
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
                  controller: cfpController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'CPF',
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  controller: rgController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'RG',
                  ),
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
            ),
          ),
          TextField(
            controller: emailController,
            enabled: false,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              hintText: 'Insira email',
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: celularController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Insira o celular',
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  controller: telefoneController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Insira o telefone',
                  ),
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
                  ),
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              user.cpf = cfpController.text;
              user.rg = rgController.text;
              user.nome = nomeController.text;
              user.telefone = telefoneController.text;
              user.celular = celularController.text;
              user.senha = senhaController.text;
            },
            child: const Text('Salvar'),
          ),
        ]),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Meus dados"),
      titleTextStyle: const TextStyle(
          color: blue, fontSize: 20, fontWeight: FontWeight.bold),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: blue, size: 30),
        padding: const EdgeInsets.only(left: 25.0),
        alignment: Alignment.center,
        onPressed: () {},
      ),
      leadingWidth: 45.0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 30),
          child: IconButton(
            alignment: Alignment.center,
            icon: const Icon(
              Icons.account_circle,
              size: 40,
              color: blue,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
