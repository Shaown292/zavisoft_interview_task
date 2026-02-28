import 'package:flutter/material.dart';

class BestSellingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double rating;

  const BestSellingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 6),

            /// Price
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 4),

            /// Rating Row
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),

            const Spacer(),

            /// Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}