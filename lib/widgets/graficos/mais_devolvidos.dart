import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/models/estatistica.dart';
import 'package:stock/models/mais_devolvidos.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoMaisDevolvido extends StatelessWidget {
  const GraficoMaisDevolvido({Key? key, required this.maisDevolvidos})
      : super(key: key);

  final List<MaisDevolvidosModel> maisDevolvidos;

  @override
  Widget build(BuildContext context) {
    TrackballBehavior? trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Devoluções', textStyle: const TextStyle(color: blue)),
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
      series: _getStackedLineSeries(),
      trackballBehavior: trackballBehavior,
    );
  }

  List<StackedLineSeries<ChartSampleData, String>> _getStackedLineSeries() {
    List<ChartSampleData>? chartData = <ChartSampleData>[];
    Map<String?, List<MaisDevolvidosModel>> produtosPorDepartamento = groupBy(
        maisDevolvidos, (MaisDevolvidosModel produto) => produto.departamento);
    produtosPorDepartamento.forEach((key, value) {
      chartData.add(ChartSampleData(
          x: key,
          y: value[0].qtde,
          secondSeriesYValue: value.length > 1 ? value[1].qtde : 0,
          thirdSeriesYValue: value.length > 2 ? value[2].qtde : 0));
    });
    return <StackedLineSeries<ChartSampleData, String>>[
      StackedLineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}
