import 'package:flutter/material.dart';
import 'package:stock/models/departamento.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/widgets/header.dart';

class DadosPedidosScreen extends StatefulWidget {
  const DadosPedidosScreen({Key? key}) : super(key: key);

  @override
  State<DadosPedidosScreen> createState() => _DadosPedidosScreenState();
}

class _DadosPedidosScreenState extends State<DadosPedidosScreen> {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.buildAppBar(context, 'Meus pedidos', userAvatar),
      body: const PedidosCard(),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class PedidosCard extends StatelessWidget {
  const PedidosCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector();
  }
}
