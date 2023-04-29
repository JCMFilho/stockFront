import 'dart:js_util';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/departamento.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock/models/estatistica.dart';
import 'package:stock/models/produto_departamento.dart';
import 'package:stock/services/departamento_service.dart';
import 'package:stock/services/estatistica_service.dart';
import 'package:stock/widgets/graficos/mais_acessados.dart';
import 'package:stock/widgets/graficos/mais_devolvidos.dart';
import 'package:stock/widgets/graficos/mais_vendido.dart';
import 'package:stock/widgets/header.dart';

class EstatisticasScreen extends StatefulWidget {
  const EstatisticasScreen({Key? key}) : super(key: key);

  @override
  State<EstatisticasScreen> createState() => _EstatisticasScreenState();
}

class _EstatisticasScreenState extends State<EstatisticasScreen> {
  EstatisticaModel? estatisticas;
  List<DepartamentoModel> departamentos = [];
  String userId = '';
  String userAvatar = '';

  @override
  void initState() {
    getEstatisticas();
    getUsuario();
    getDepartamentos();
    super.initState();
  }

  Future getEstatisticas() async {
    estatisticas = await EstatisticaService.getEstatistica();
    setState(() {});
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
      appBar: HeaderWidget.buildAppBar(context, 'Estatísticas', userAvatar),
      body: EstatisticaCard(estatisticas: estatisticas!),
      drawer: HeaderWidget.buildDrawer(context, userId, departamentos),
    );
  }
}

class EstatisticaCard extends StatelessWidget {
  const EstatisticaCard({Key? key, required this.estatisticas})
      : super(key: key);

  final EstatisticaModel estatisticas;

  @override
  Widget build(BuildContext context) {
    Map<String?, List<ProdutoDepartamentoModel>> produtosPorDepartamento =
        groupBy(estatisticas.maisAcessados!,
            (ProdutoDepartamentoModel produto) => produto.departamento);

    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0 / 4),
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  GraficoMaisVendido(maisVendidos: estatisticas.maisVendidos!),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20.0 / 4),
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GraficoMaisDevolvido(
                  maisDevolvidos: estatisticas.maisDevolvidos!),
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.all(20.0 / 4),
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Mais acessados',
                      style: TextStyle(color: blue, fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: produtosPorDepartamento.entries
                          .map((entry) => GraficoMaisAcessados(
                                departamento: entry.key!,
                                maisAcessados: entry.value,
                              ))
                          .toList(),
                    )
                  ],
                )),
          ],
        ));
  }
}
