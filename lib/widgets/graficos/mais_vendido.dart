import 'dart:js_util';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/estatistica.dart';
import 'package:stock/models/produto_departamento.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoMaisVendido extends StatelessWidget {
  const GraficoMaisVendido({Key? key, required this.maisVendidos})
      : super(key: key);

  final List<ProdutoDepartamentoModel> maisVendidos;

  @override
  Widget build(BuildContext context) {
    TooltipBehavior? tooltipBehavior = TooltipBehavior(enable: true);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Mais vendidos', textStyle: const TextStyle(color: blue)),
      primaryXAxis: CategoryAxis(
          labelStyle: const TextStyle(color: blue),
          majorGridLines: const MajorGridLines(color: blue),
          majorTickLines: const MajorTickLines(color: blue)),
      primaryYAxis: NumericAxis(
          labelStyle: const TextStyle(color: blue),
          maximum: 14,
          minimum: 0,
          interval: 2,
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(color: blue),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      tooltipBehavior: tooltipBehavior,
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumn() {
    List<ChartSampleData>? chartData = <ChartSampleData>[];
    Map<String?, List<ProdutoDepartamentoModel>> produtosPorDepartamento =
        groupBy(maisVendidos,
            (ProdutoDepartamentoModel produto) => produto.departamento);
    produtosPorDepartamento.forEach((key, value) {
      chartData.add(ChartSampleData(
          x: key,
          y: value[0].qtde,
          secondSeriesYValue: value.length > 1 ? value[1].qtde : 0,
          thirdSeriesYValue: value.length > 2 ? value[2].qtde : 0,
          product1: value[0].produto,
          product2: value.length > 1 ? value[1].produto : '',
          product3: value.length > 2 ? value[2].produto : ''));
    });

    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          width: 0.8,
          spacing: 0.2,
          dataSource: chartData,
          color: const Color.fromRGBO(251, 193, 55, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Ouro',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (ChartSampleData sales, _) => sales.product1!),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 0.8,
          spacing: 0.2,
          color: const Color.fromRGBO(177, 183, 188, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Prata',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (ChartSampleData sales, _) => sales.product2!),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 0.8,
          spacing: 0.2,
          color: const Color.fromRGBO(140, 92, 69, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Bronze',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (ChartSampleData sales, _) => sales.product3!)
    ];
  }
}
