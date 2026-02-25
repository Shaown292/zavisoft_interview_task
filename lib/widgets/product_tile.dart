import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product['image'], width: 40),
      title: Text(product['title']),
      subtitle: Text("\$${product['price']}"),
    );
  }
}