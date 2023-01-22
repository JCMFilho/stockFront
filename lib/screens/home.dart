import 'package:flutter/material.dart';
import 'package:stock/widgets/card.dart';
import 'package:stock/widgets/header.dart';
import 'package:stock/widgets/swiper.dart';

import 'package:stock/consts/cores.dart';
import 'package:stock/models/promocao.dart';
import 'package:stock/screens/user.dart';
import 'package:stock/services/promocao_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PromocaoModel> promocaoSmall = [];
  List<PromocaoModel> promocaoMedium = [];
  List<PromocaoModel> promocaoBig = [];
  List<PromocaoModel> promocaoRotative = [];
  String userType = '';

  @override
  void initState() {
    getPromocoes();
    getRole();
    super.initState();
  }

  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('role')!;
    setState(() {});
  }

  Future<void> getPromocoes() async {
    promocaoRotative = await PromocaoService.getData("rotative");
    promocaoSmall = await PromocaoService.getData("small");
    promocaoMedium = await PromocaoService.getData("medium");
    promocaoBig = await PromocaoService.getData("big");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: buildAppBar(),
        body: promocaoRotative.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderWidget(size: size),
                    SwiperWidget(
                      size: size,
                      promocao: promocaoRotative,
                    ),
                    CardWidget(
                        promocaoCategories: promocaoBig,
                        width: 500,
                        height: 250),
                    CardWidget(
                        promocaoCategories: promocaoSmall,
                        width: 100,
                        height: 100),
                    CardWidget(
                        promocaoCategories: promocaoMedium,
                        width: 200,
                        height: 200),
                  ],
                ),
              ));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Departamentos"),
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserScreen(userType: userType)));
            },
          ),
        ),
      ],
    );
  }
}
