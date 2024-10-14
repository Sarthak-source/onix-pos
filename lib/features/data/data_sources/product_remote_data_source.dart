import '../models/product_model.dart';

class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts() async {
    // Simulate a network call to fetch products (you can replace this with actual API calls)
    await Future.delayed(const Duration(seconds: 2)); // Simulating network delay

    // Returning dummy data
    return [
      ProductModel(barcodeNumber: 1, name: "Product 1", price: 10.0),
      ProductModel(barcodeNumber: 2, name: "Product 2", price: 20.0),
    ];
  }
}
