import 'package:flutter/material.dart';
import '../model/product_model.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;

  const ProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// Product Info
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        "${product.rating} (${product.ratingCount})",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}