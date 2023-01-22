import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/consts/imagens.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      height: size.height * 0.2,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 25 + 20.0,
          ),
          height: size.height * 0.2 - 35,
          decoration: const BoxDecoration(
            color: lightYellow,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: Row(
            children: [
              Image.asset(Images.logo),
              const Spacer(),
              Badge(
                  badgeColor: red,
                  badgeContent: const Text('2'),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 30,
                  )),
              const SizedBox(width: 30),
              Badge(
                  badgeColor: red,
                  badgeContent: const Text('3'),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  )),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 54,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: blue.withOpacity(0.23),
                  ),
                ]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      hintText: "Procurar",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: blue.withOpacity(0.5),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
