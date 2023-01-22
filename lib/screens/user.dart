import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/screens/dados.dart';
import 'package:stock/screens/enderecos.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({
    Key? key,
    required this.userType,
  }) : super(key: key);

  final String userType;

  @override
  Widget build(BuildContext context) {
    String title1 = "Minha Conta";
    String title2 = "Atendimento";
    String text1 = "Meus dados";
    String text2 = "Meus pedidos";
    String text3 = "Meus endereços";
    String text4 = "WhatsApp";
    String text5 = "Enviar e-mail";
    String text6 = "Nossos telefones";
    var screen1 = const DadosScreen();
    var screen2 = const EnderecosScreen();
    var screen3 = const DadosScreen();
    var screen4 = const DadosScreen();
    var screen5 = const DadosScreen();
    var screen6 = const DadosScreen();
    IconData icon1 = Icons.account_circle_rounded;
    IconData icon2 = Icons.shopping_cart_rounded;
    IconData icon3 = Icons.account_box_rounded;
    IconData icon4 = Icons.chat;
    IconData icon5 = Icons.mail;
    IconData icon6 = Icons.phone;
    if (userType == "admin") {
      title1 = "Gerenciar";
      title2 = "Gerenciar Produtos";
      text1 = "Meus dados";
      text2 = "Endereços das lojas";
      text3 = "Estatisticas";
      text4 = "Adicionar";
      text5 = "Editar";
      text6 = "Excluir";
      icon1 = Icons.account_circle_outlined;
      icon2 = Icons.account_circle_outlined;
      icon3 = Icons.assignment;
      icon4 = Icons.account_circle_outlined;
      icon5 = Icons.account_circle_outlined;
      icon6 = Icons.assignment;
      screen3 = const DadosScreen();
    }
    double heigth = (MediaQuery.of(context).size.height / 2) - 240;
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: heigth),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSizedBox(context, title1, text1, text2, text3, icon1, icon2,
                  icon3, screen1, screen2, screen3),
              buildSizedBox(context, title2, text4, text5, text6, icon4, icon5,
                  icon6, screen4, screen5, screen6),
            ]),
      ),
    );
  }

  SizedBox buildSizedBox(context, title, text1, text2, text3, icon1, icon2,
      icon3, screen1, screen2, screen4) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => screen1));
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Icon(icon1, size: 50.0),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              text1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => screen2));
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Icon(icon2, size: 50.0),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              text2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => screen2));
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Icon(icon3, size: 50.0),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              text3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      )),
                ]),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Minha Conta"),
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
