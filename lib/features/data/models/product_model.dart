class ProductModel {
  final int barcodeNumber;
  final String name;
  final double price;
  final double quantity; // Add quantity field

  ProductModel({
    required this.barcodeNumber,
    required this.name,
    required this.price,
    this.quantity = 0, // Default quantity to 1
  });

  // Factory constructor to create an instance of ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcodeNumber: json['barcodeNumber'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'] ?? 1, // Handle quantity in JSON, default to 1 if not present
    );
  }

  // Method to convert a ProductModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'barcodeNumber': barcodeNumber,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  // CopyWith method to update fields immutably
  ProductModel copyWith({
    int? barcodeNumber,
    String? name,
    double? price,
    double? quantity,
  }) {
    return ProductModel(
      barcodeNumber: barcodeNumber ?? this.barcodeNumber,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
