
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductModel>> execute() {
    // Implementation for fetching products from the repository
    return repository.fetchProducts();
  }
}
