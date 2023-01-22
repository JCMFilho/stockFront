import 'package:flutter/material.dart';

class Producto {
  String name;
  String brand;
  String description;
  double price;
  double rating;
  List<Color> productColors;
  List<String> productImages;

  Producto(
      {required this.name,
      required this.brand,
      required this.description,
      required this.price,
      required this.rating,
      required this.productColors,
      required this.productImages});
}
