import 'package:flutter/material.dart';

import 'features/presentation/screens/pos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
    
      title: 'Product Order',
      home: ProductOrderScreen(),
    );
  }
}

// class ProductOrderScreen extends StatefulWidget {
//   const ProductOrderScreen({super.key});

//   @override
//   _ProductOrderScreenState createState() => _ProductOrderScreenState();
// }

// class _ProductOrderScreenState extends State<ProductOrderScreen> {
//   List<Product> productList = [
//     Product(name: "Mixer 2200W", price: 297.00),
//     Product(name: "Oven 80L", price: 629.00),
//     Product(name: "Cake Maker 1600W", price: 629.00),
//   ];

//   TextEditingController barcodeController = TextEditingController();
//   int defaultQuantity = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Product Order")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Barcode Input and Add Button
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: barcodeController,
//                     decoration: const InputDecoration(
//                       labelText: "Enter Product Number / Scan Barcode",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     addProductByBarcode(barcodeController.text);
//                   },
//                   child: const Text("Add"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Product List Table
//             Expanded(
//               child: PlutoGrid(
//                 columns: [
//                   PlutoColumn(
//                     title: 'Name',
//                     field: 'name',
//                     type: PlutoColumnType.text(),
//                   ),
//                   PlutoColumn(
//                     title: 'Unit',
//                     field: 'unit',
//                     type: PlutoColumnType.text(),
//                   ),
//                   PlutoColumn(
//                     title: 'Quantity',
//                     field: 'quantity',
//                     type: PlutoColumnType.number(),
//                     renderer: (rendererContext) {
//                       return Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.remove),
//                             onPressed: () => adjustQuantity(rendererContext, -1),
//                           ),
//                           Text(rendererContext.cell.value.toString()),
//                           IconButton(
//                             icon: const Icon(Icons.add),
//                             onPressed: () => adjustQuantity(rendererContext, 1),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   PlutoColumn(
//                     title: 'Price',
//                     field: 'price',
//                     type: PlutoColumnType.number(),
//                   ),
//                   PlutoColumn(
//                     title: 'Delete',
//                     field: 'delete',
//                     type: PlutoColumnType.text(),
//                     renderer: (rendererContext) {
//                       return IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => deleteProduct(rendererContext),
//                       );
//                     },
//                   ),
//                 ],
//                 rows: productList
//                     .map((product) => PlutoRow(cells: {
//                           'name': PlutoCell(value: product.name),
//                           'unit': PlutoCell(value: 'pcs'),
//                           'quantity': PlutoCell(value: defaultQuantity),
//                           'price': PlutoCell(value: product.price),
//                           'delete': PlutoCell(value: 'delete'),
//                         }))
//                     .toList(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Print Button
//             ElevatedButton(
//               onPressed: printOrder,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 //primary: Colors.blue,
//               ),
//               child: const Text("Print"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void addProductByBarcode(String barcode) {
//     // Handle fetching product by barcode and adding it to the product list.
//     // For now, we'll just simulate adding a product.
//     setState(() {
//       productList.add(Product(name: "Scanned Product", price: 399.00));
//     });
//   }

//   void adjustQuantity(PlutoColumnRendererContext rendererContext, int amount) {
//     setState(() {
//       int newQuantity = rendererContext.cell.value + amount;
//       if (newQuantity > 0) {
//         rendererContext.row.cells['quantity']!.value = newQuantity;
//       }
//     });
//   }

//   void deleteProduct(PlutoColumnRendererContext rendererContext) {
//     setState(() {
//       rendererContext.stateManager.removeRows([rendererContext.row]);
//     });
//   }

//   void printOrder() {
//     // Handle print functionality
//     // Collect all order details and print.
//     if (kDebugMode) {
//       print("Order printed");
//     }
//   }
// }

// class Product {
//   String name;
//   double price;
//   Product({required this.name, required this.price});
// }
