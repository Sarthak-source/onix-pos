// lib/data/repositories/product_repository.dart

import '../data_sources/product_remote_data_source.dart'; // Import the data source
import '../models/product_model.dart'; // Import the product model

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  // Constructor that takes a ProductRemoteDataSource as a dependency
  ProductRepository(this.remoteDataSource);

  // Method to fetch products from the remote data source
  Future<List<ProductModel>> fetchProducts() async {
    return await remoteDataSource.getProducts();
  }
}
