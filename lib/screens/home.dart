import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/models/departamento.dart';
import 'package:stock/services/departamento_service.dart';

import 'package:stock/widgets/card.dart';
import 'package:stock/widgets/header.dart';
import 'package:stock/widgets/swiper.dart';
import 'package:stock/models/promocao.dart';
import 'package:stock/services/promocao_service.dart';

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
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userAvatar = '';

  @override
  void initState() {
    getDepartamentos();
    getPromocoes();
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
        appBar: HeaderWidget.buildAppBar(context, 'Bem vindo', userAvatar),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(size: size, userId: userId),
              SwiperWidget(
                size: size,
                promocao: promocaoRotative,
              ),
              CardWidget(
                  promocaoCategories: promocaoBig,
                  userId: userId,
                  width: (size.width / 3) - 5,
                  height: 250),
              CardWidget(
                  promocaoCategories: promocaoSmall,
                  userId: userId,
                  width: (size.width / 10) - 5,
                  height: 100),
              CardWidget(
                  promocaoCategories: promocaoMedium,
                  userId: userId,
                  width: (size.width / 6) - 5,
                  height: 200),
            ],
          ),
        ),
        drawer: HeaderWidget.buildDrawer(context, userId, departamentos));
  }
}
