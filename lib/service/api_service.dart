import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/product_model.dart';

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}