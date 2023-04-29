import 'package:flutter/cupertino.dart';
import 'package:stock/models/mais_devolvidos.dart';
import 'package:stock/models/produto_departamento.dart';

class ChartSampleData {
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume,
      this.product1,
      this.product2,
      this.product3});

  final dynamic x;

  final num? y;

  final dynamic xValue;

  final num? yValue;

  final num? secondSeriesYValue;

  final num? thirdSeriesYValue;

  final Color? pointColor;

  final num? size;

  final String? text;

  final num? open;

  final num? close;

  final num? low;

  final num? high;

  final num? volume;

  final String? product1;

  final String? product2;

  final String? product3;
}

class EstatisticaModel with ChangeNotifier {
  List<ProdutoDepartamentoModel>? maisVendidos;
  List<ProdutoDepartamentoModel>? maisAcessados;
  List<MaisDevolvidosModel>? maisDevolvidos;

  EstatisticaModel(
      {required this.maisVendidos,
      required this.maisAcessados,
      required this.maisDevolvidos});

  EstatisticaModel.fromJson(Map<String, dynamic> json) {
    maisVendidos = ProdutoDepartamentoModel.produtoDepartamentoFromJson(
        json['maisVendidos']);
    maisAcessados = ProdutoDepartamentoModel.produtoDepartamentoFromJson(
        json['maisAcessados']);
    maisDevolvidos =
        MaisDevolvidosModel.maisDevolvidosFromJson(json['maisDevolvidos']);
  }

  Map<String, dynamic> toJson() => {
        'maisVendidos': maisVendidos,
        'maisAcessados': maisAcessados,
        'maisDevolvidos': maisDevolvidos
      };

  static List<EstatisticaModel> estatisticasFromJson(List fullJson) {
    return fullJson.map((data) {
      return EstatisticaModel.fromJson(data);
    }).toList();
  }
}
