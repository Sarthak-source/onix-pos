import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/features/presentation/widgets/pdf_view.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pluto_grid/pluto_grid.dart';

import '../../data/models/product_model.dart';

// Define Product States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

// Define Product Cubit
class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  List<ProductModel> productList = [
    ProductModel(
        name: "Mixer 2200W",
        price: 297.00,
        barcodeNumber: 100250131070,
        quantity: 1),
    ProductModel(
        name: "Oven 80L",
        price: 629.00,
        barcodeNumber: 9788179927687,
        quantity: 1),
    ProductModel(
        name: "Cake Maker 1600W",
        price: 629.00,
        barcodeNumber: 30,
        quantity: 1),
  ];

  Future<void> fetchProductByBarcode(String barcode) async {
    emit(ProductLoading());

    try {
      // Check if the barcode is empty
      if (barcode.isEmpty) {
        emit(ProductError('Barcode cannot be empty.'));
        return;
      }

      // Simulate network delay or database query
      await Future.delayed(const Duration(seconds: 2));

      // Find the product by barcode
      productList = [
        productList.firstWhere(
          (product) => product.barcodeNumber.toString() == barcode.trim(),
          orElse: () => throw Exception('Product not found'),
        )
      ];

      emit(ProductLoaded(productList));

      key = UniqueKey();

      // Emit ProductLoaded with the found product
      emit(ProductLoaded(productList));
    } catch (e) {
      // Handle the error state
      emit(ProductError(e.toString()));
    }
  }

  late PlutoGridStateManager stateManagerProviders;

  UniqueKey key = UniqueKey();

  TextEditingController defaultQuantityController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();

  // Method to return PlutoRow list
  List<PlutoRow> plutoRow() {
    return productList
        .map((product) => PlutoRow(cells: {
              'name': PlutoCell(value: product.name),
              'unit': PlutoCell(value: 'pcs'),
              'quantity': PlutoCell(value: product.quantity),
              'price': PlutoCell(value: product.price),
              'delete': PlutoCell(value: 'delete'),
              'product': PlutoCell(value: product), // Store the product object
            }))
        .toList();
  }

  // Define PlutoColumn List
  List<PlutoColumn> column = [
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
      width: PlutoGridSettings.minColumnWidth * 3,
      textAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableDropToResize: false,
      enableSorting: false,
      backgroundColor: kSkyDarkColor,
    ),
    PlutoColumn(
      title: 'Unit',
      field: 'unit',
      type: PlutoColumnType.text(),
      width: PlutoGridSettings.minColumnWidth * 3,
      textAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableDropToResize: false,
      enableSorting: false,
      backgroundColor: kSkyDarkColor,
    ),
    PlutoColumn(
      title: 'Quantity',
      field: 'quantity',
      width: PlutoGridSettings.minColumnWidth * 3,
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableDropToResize: false,
      enableSorting: false,
      backgroundColor: kSkyDarkColor,
      renderer: (rendererContext) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Transform.scale(
              scale: 0.8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove, color: Colors.grey),
                          onPressed: () {
                            log(rendererContext.stateManager.currentRow!.cells
                                .toString());
                            int currentQuantity =
                                rendererContext.cell.value ?? 0;
                            if (currentQuantity > 0) {
                              rendererContext
                                  .stateManager
                                  .currentRow!
                                  .cells['quantity']!
                                  .value = currentQuantity - 1;
                              // Notify the state manager that the row has changed
                              rendererContext.stateManager.notifyListeners();
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        rendererContext.cell.value.toString(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            int currentQuantity =
                                rendererContext.cell.value ?? 0;
                            rendererContext.stateManager.currentRow!
                                .cells['quantity']!.value = currentQuantity + 1;
                            // Notify the state manager that the row has changed
                            rendererContext.stateManager.notifyListeners();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Price',
      field: 'price',
      width: PlutoGridSettings.minColumnWidth * 3,
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableDropToResize: false,
      enableSorting: false,
      backgroundColor: kSkyDarkColor,
    ),
    PlutoColumn(
      title: 'Delete',
      field: 'delete',
      width: PlutoGridSettings.minColumnWidth * 3,
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableDropToResize: false,
      enableSorting: false,
      backgroundColor: kSkyDarkColor,
      renderer: (rendererContext) {
        return IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            rendererContext.stateManager.removeRows([rendererContext.row]);
          },
        );
      },
    ),
  ];

  // Fetch products
  void fetchProducts() {
    emit(ProductLoaded(productList));
  }

  // Simulate adding a product by barcode
  void addProductByBarcode(String barcode) {
    productList.add(ProductModel(
        name: "Scanned Product",
        price: 399.00,
        barcodeNumber: 20,
        quantity: 1));
    emit(ProductLoaded(productList));
  }

  // Adjust product quantity
  void adjustQuantity(ProductModel product, int amount) {
    final index = productList.indexOf(product);
    final newQuantity = productList[index].quantity + amount;

    if (newQuantity > 0) {
      productList[index] = productList[index].copyWith(quantity: newQuantity);
      emit(ProductLoaded(productList));
    }
  }

  // Delete a product

  void addProduct() {
    emit(ProductLoading());

    final defaultQuantity = int.tryParse(defaultQuantityController.text) ?? 0;
    final barcode = barcodeController.text;

    // Validate inputs
    // if (defaultQuantity <= 0 || barcode.isEmpty) {
    //   emit(ProductError("Invalid input!"));
    //   return;
    // }

    // // Create a new product
    // final newProduct = ProductModel(
    //   name: "Product from Barcode $barcode",
    //   price: 0.0,
    //   barcodeNumber: int.tryParse(barcode) ?? 0,
    //   quantity: defaultQuantity.toDouble(),
    // );

    //await Future.delayed(const Duration(seconds: 2));

    // Find the product by barcode
    productList = [
      productList.firstWhere(
        (product) => product.barcodeNumber.toString() == barcode.trim(),
        orElse: () => throw Exception('Product not found'),
      )
    ];

    emit(ProductLoaded(productList));

    //productList.add(newProduct);
    key = UniqueKey();

    ///emit(ProductLoaded(productList));

    // Clear the controllers
    defaultQuantityController.clear();
    barcodeController.clear();
  }

  Future<pw.Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData);
  }

  pw.Widget _productTable(pw.Font regularFont) {
    return pw.Table(
      tableWidth: pw.TableWidth.max,
      border: pw.TableBorder.all(
          style: pw.BorderStyle.none), // Add borders to the table
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // Products column width
        1: const pw.FlexColumnWidth(2), // Quantity column width
        2: const pw.FlexColumnWidth(2), // Price column width
        3: const pw.FlexColumnWidth(2), // Total column width
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('المنتجات',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: regularFont, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('الكمية',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: regularFont, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('السعر',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: regularFont, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('الاجمالي',
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                      font: regularFont, fontWeight: pw.FontWeight.bold)),
            ),
          ].reversed.toList(),
        ),
        _productTableRow('منتج 1', 4, 300, regularFont),
        _productTableRow('منتج 2', 1, 100, regularFont),
        _productTableRow('منتج 3', 1, 100, regularFont),
      ],
    );
  }

  pw.TableRow _productTableRow(
      String itemName, int quantity, double price, pw.Font regularFont) {
    double total = quantity * price;
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(itemName,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: regularFont)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(quantity.toString(),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: regularFont)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(price.toStringAsFixed(2),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: regularFont)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(total.toStringAsFixed(2),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: regularFont)),
        ),
      ].reversed.toList(),
    );
  }

  pw.Widget dottedDivider() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: List.generate(
          160,
          (index) => pw.Text(
                '- ',
                style: const pw.TextStyle(
                  fontSize: 5, // Adjust size for dot thickness
                  color: PdfColors.black, // Customize dot color if needed
                ),
              )),
    );
  }

  pw.Widget _summary(pw.Font regularFont) {
    return pw.Column(
      children: [
        dottedDivider(),
        _summaryRow('الإجمالي: ', 1200, regularFont),
        dottedDivider(),
        _summaryRow('الضرائب:   ', 200, regularFont),
        dottedDivider(),
        _summaryRow('المجموع:', 1400, regularFont),
        dottedDivider(),
        _summaryRow('المبلغ المدفوع:', 1400, regularFont),
        dottedDivider(),
        _summaryRow('الباقي:       ', 0, regularFont),
      ],
    );
  }

  pw.Widget _summaryRow(String label, double value, pw.Font regularFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 15),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  value.toStringAsFixed(2),
                  style: pw.TextStyle(font: regularFont),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(label,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(font: regularFont)),
          ),
        ],
      ),
    );
  }

  pw.Widget _footer(pw.Font regularFont) {
    return pw.Column(
      children: [
        pw.Center(
            child: pw.Text('5345-5435-977',
                style: pw.TextStyle(fontSize: 12, font: regularFont))),
        pw.Center(
            child: pw.Text('العنوان: طريق الملك فهد',
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(fontSize: 12, font: regularFont))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Container(
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: pw.Text(
            'شروط الإرجاع 7 أيام من تاريخ الفاتورة خلال 14 يوم عيوب الصناعة مع\n وجدوا إيصال الشراء',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
                fontSize: 12,
                font: regularFont,
                color: PdfColor.fromHex('#525252')),
            textAlign: pw.TextAlign.center,
          ),
        )),
      ],
    );
  }

  pw.Widget _invoiceDetails(pw.Font regularFont) {
    const labelColor = PdfColor.fromInt(0xFF0C69C0); // Custom label color
    const valueColor = PdfColor.fromInt(0xFF525252); // #525252 color for values

    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(3),
      },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        // First row
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.RichText(
                textDirection: pw.TextDirection.rtl,
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'الكاشير: ',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: labelColor,
                      ),
                    ),
                    pw.TextSpan(
                      text: 'مدير النظام',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.RichText(
                textDirection: pw.TextDirection.rtl,
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'تاريخ: ',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: labelColor,
                      ),
                    ),
                    pw.TextSpan(
                      text: '10/10/2024',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Second row
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.RichText(
                textDirection: pw.TextDirection.rtl,
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'رقم النقطة: ',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: labelColor,
                      ),
                    ),
                    pw.TextSpan(
                      text: '2',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.RichText(
                textDirection: pw.TextDirection.rtl,
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'الوقت: ',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: labelColor,
                      ),
                    ),
                    pw.TextSpan(
                      text: '10:24:21',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Third row
        pw.TableRow(
          children: [
            pw.SizedBox(),
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.RichText(
                textDirection: pw.TextDirection.rtl,
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'اسم العميل: ',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: labelColor,
                      ),
                    ),
                    pw.TextSpan(
                      text: 'إسلام سليمان - شركة المجد للصناعة',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Empty cell to align properly
          ],
        ),
      ],
    );
  }

  Future<pw.Widget> _logoPlaceholder(pw.Font regularFont) async {
    Uint8List data =
        (await rootBundle.load('qasr_logo.png')).buffer.asUint8List();

    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
      // decoration: pw.BoxDecoration(
      //   border: pw.Border.all(color: PdfColors.grey300),
      //   borderRadius: pw.BorderRadius.circular(5),
      // ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 20),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Container(
                    // decoration: pw.BoxDecoration(
                    //   border: pw.Border.all(color: PdfColor.fromHex('#819AA7'), width: 2),
                    //   borderRadius: pw.BorderRadius.circular(8),
                    // ),
                    child: pw.Image(
                      pw.MemoryImage(
                        data,
                      ),
                      height: 100,
                      width: 150,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'فاتورة ضريبية مبسطة: #2455',
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: regularFont,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'إسم التاجر قصر الأواني',
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: regularFont,
                    color: const PdfColor.fromInt(0xFF0C69C0),
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'رقم الفاتورة 1225498494',
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: regularFont,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      'الرقم الضريبي 1225498494',
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: regularFont,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<pw.Widget> _qrCodePlaceholder() async {
    Uint8List data =
        (await rootBundle.load('assets/qrcode.png')).buffer.asUint8List();

    return pw.Center(
      child: pw.Container(
        child: pw.Image(
          pw.MemoryImage(
            data,
          ),
          fit: pw.BoxFit.contain,
        ),
      ),
    );
  }

// Print order functionality
  Future<void> generateInvoice(BuildContext context) async {
    final pdf = pw.Document();

    //final pw.Font boldFont = await loadFont('assets/Cairo-Bold.ttf');
    final pw.Font regularFont = await loadFont('assets/Cairo-Regular.ttf');
    //final pw.Font lightFont = await loadFont('assets/Cairo-Light.ttf');

    final pw.Widget qrCodeWidget = await _qrCodePlaceholder();
    final pw.Widget logoWidget = await _logoPlaceholder(regularFont);

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              logoWidget,
              dottedDivider(),
              pw.SizedBox(height: 10),
              _invoiceDetails(regularFont),
              dottedDivider(),
              pw.SizedBox(height: 20),
              _productTable(
                  regularFont), // Automatically splits table across pages
              pw.SizedBox(height: 10),
              _summary(regularFont),
              pw.SizedBox(height: 20),
              _footer(regularFont),
              pw.SizedBox(height: 10),
              qrCodeWidget,
            ],
          ),
        ],
      ),
    );

    // Save PDF to a file

    // Preview the PDF
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(doc: pdf),
        ),
      );
    }
  }

// Calculate the total price of products
  double calculateTotal() {
    return productList.fold(
        0, (sum, product) => sum + (product.price * product.quantity));
  }
}
