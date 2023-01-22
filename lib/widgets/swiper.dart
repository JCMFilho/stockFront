import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:stock/models/promocao.dart';

class SwiperWidget extends StatelessWidget {
  const SwiperWidget({Key? key, required this.size, required this.promocao})
      : super(key: key);

  final List<PromocaoModel> promocao;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Swiper(
        itemCount: promocao.length,
        itemBuilder: (ctx, index) {
          return Padding(
              padding: const EdgeInsets.all(20.0 / 4),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(promocao[index].imagem!,
                      fit: BoxFit.cover)));
        },
        autoplay: true,
        pagination: const SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
                color: Colors.white, activeColor: Colors.red)),
      ),
    );
  }
}
