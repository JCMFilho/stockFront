import 'package:flutter/material.dart';
import 'package:stock/models/estatistica.dart';
import 'package:stock/models/produto_departamento.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoMaisAcessados extends StatelessWidget {
  const GraficoMaisAcessados(
      {Key? key, required this.departamento, required this.maisAcessados})
      : super(key: key);

  final String departamento;
  final List<ProdutoDepartamentoModel> maisAcessados;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: departamento),
      series: _getDefaultPieSeries(),
    );
  }

  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries() {
    List<ChartSampleData>? chartData = <ChartSampleData>[];

    if (maisAcessados.isNotEmpty) {
      chartData.add(ChartSampleData(
          x: maisAcessados[0].produto,
          y: maisAcessados[0].qtde,
          text: '${maisAcessados[0].produto} : ${maisAcessados[0].qtde}'));
    }

    if (maisAcessados.length > 1) {
      chartData.add(ChartSampleData(
          x: maisAcessados[1].produto,
          y: maisAcessados[1].qtde,
          text: '${maisAcessados[1].produto} : ${maisAcessados[1].qtde}'));
    }

    if (maisAcessados.length > 2) {
      chartData.add(ChartSampleData(
          x: maisAcessados[2].produto,
          y: maisAcessados[2].qtde,
          text: '${maisAcessados[2].produto} : ${maisAcessados[2].qtde}'));
    }

    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }
}
