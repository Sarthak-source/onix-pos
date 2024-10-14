import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price.toString()}'),
      onTap: () {
        // Handle product selection
      },
    );
  }
}
