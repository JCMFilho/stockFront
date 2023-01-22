import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/endereco.dart';
import 'package:stock/services/endereco_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EnderecosScreen extends StatefulWidget {
  const EnderecosScreen({Key? key}) : super(key: key);

  @override
  State<EnderecosScreen> createState() => _EnderecosScreenState();
}

class _EnderecosScreenState extends State<EnderecosScreen> {
  List<EnderecoModel> enderecos = [];
  @override
  void initState() {
    getUsuario();
    super.initState();
  }

  Future<void> getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    enderecos = await EnderecoService.getEnderecoPorUser(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0 / 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              enderecos.length,
              (index) => EnderecoCard(endereco: enderecos[index], press: () {}),
            ),
          ),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Meus endereços"),
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

class EnderecoCard extends StatelessWidget {
  const EnderecoCard({
    Key? key,
    required this.press,
    required this.endereco,
  }) : super(key: key);

  final GestureTapCallback press;
  final EnderecoModel endereco;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0 / 4),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(endereco.tipo ?? ''),
                  Text(endereco.logradouro ?? ''),
                  Text(endereco.numero ?? '')
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
