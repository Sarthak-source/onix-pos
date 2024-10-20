import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/features/presentation/widgets/pdf_view.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pluto_grid/pluto_grid.dart';

import '../../data/models/product_model.dart';
import 'product_state.dart';

// Define Product Cubit
class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial()) {
    productListDisplay = [];
    //key = ValueKey(productListDisplay.hashCode);
  }

  late List<ProductModel> productListDisplay;

  late PlutoGridStateManager stateManagerProviders;

  UniqueKey key = UniqueKey();

  TextEditingController defaultQuantityController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();

  List<ProductModel> productList = [
    ProductModel(
        name: "Mixer 2200W",
        price: 297.00,
        barcodeNumber: 100250131070,
        quantity: 0),
    ProductModel(
        name: "Oven 80L",
        price: 629.00,
        barcodeNumber: 9788179927687,
        quantity: 0),
    ProductModel(
        name: "Cake Maker 1600W",
        price: 629.00,
        barcodeNumber: 30,
        quantity: 0),
  ];

  bool isValidBarcode(String barcode) {
    // Example validation: check if the barcode is not empty and has 13 digits
    return barcode.isNotEmpty &&
       (barcode.length >= 9 && barcode.length <= 15) &&
        RegExp(r'^[0-9]+$').hasMatch(barcode);
  }

  void addProduct() {
    emit(ProductLoading());

    final barcode = barcodeController.text.trim();
    //defaultQuantityController = TextEditingController(text: '1');

    // Check if the barcode is empty
    if (barcode.isEmpty) {
      emit(ProductError('Barcode cannot be empty.'));
      return;
    }

    // Try to find the product by barcode
    try {
      final product = productList.firstWhere(
        (product) => product.barcodeNumber.toString() == barcode,
        orElse: () => throw Exception('Product not found'),
      );

      double additionalQuantity =
          double.tryParse(defaultQuantityController.text) ?? 0.0;

      // Update the product's quantity in the main productList
      productList = productList.map((p) {
        if (p.barcodeNumber == product.barcodeNumber) {
          return p.copyWith(quantity: p.quantity + additionalQuantity);
        }
        return p;
      }).toList();

      // Check if the product already exists in productListDisplay
      final existingIndex = productListDisplay.indexWhere(
        (p) => p.barcodeNumber == product.barcodeNumber,
      );

      if (existingIndex >= 0) {
        // If product exists in productListDisplay, update its quantity
        productListDisplay[existingIndex] = product.copyWith(
          quantity: product.quantity + additionalQuantity,
        );
      } else {
        // If product does not exist, add it to productListDisplay
        productListDisplay.add(
          product.copyWith(quantity: product.quantity + additionalQuantity),
        );
      }

      emit(ProductLoaded(productListDisplay));
      
      //stateManagerProviders.notifyListeners();
      key = UniqueKey();
    } catch (e) {
      // Handle the error if no product matches the barcode
      emit(ProductError(e.toString()));
    }

    // Clear the controllers
    defaultQuantityController.clear();
    barcodeController.clear();
    //stateManagerProviders.notifyListeners(true);
  }

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
      final product = productList.firstWhere(
        (product) => product.barcodeNumber.toString() == barcode,
        orElse: () => throw Exception('Product not found'),
      );

      // Update the product's quantity in the main productList
      productList = productList.map((p) {
        if (p.barcodeNumber == product.barcodeNumber) {
          return p.copyWith(quantity: p.quantity + 1);
        }
        return p;
      }).toList();

      // Check if the product already exists in productListDisplay
      final existingIndex = productListDisplay.indexWhere(
        (p) => p.barcodeNumber == product.barcodeNumber,
      );

      if (existingIndex >= 0) {
        // If product exists in productListDisplay, update its quantity
        productListDisplay[existingIndex] = product.copyWith(
          quantity: product.quantity + 1,
        );
      } else {
        // If product does not exist, add it to productListDisplay
        productListDisplay
            .add(product.copyWith(quantity: product.quantity + 1));
      }

      emit(ProductLoaded(productListDisplay));
      key = UniqueKey();
    } catch (e) {
      // Handle the error state
      emit(ProductError(e.toString()));
    }
  }

  List<ProductModel> returnList() {
    List<ProductModel> returnList =
        productListDisplay.isEmpty ? productList : productListDisplay;
    return returnList;
  }

  Future<void> updateProductQuantity(String barcode, double newQuantity) async {
    emit(ProductLoading());
    try {
      final productIndex = productList.indexWhere(
        (product) => product.barcodeNumber.toString() == barcode,
      );

      if (productIndex >= 0) {
        // Update the quantity of the product in the main productList
        productList[productIndex] =
            productList[productIndex].copyWith(quantity: newQuantity);

        // Check if the product already exists in productListDisplay
        final existingIndex = productListDisplay.indexWhere(
          (p) => p.barcodeNumber == productList[productIndex].barcodeNumber,
        );

        if (existingIndex >= 0) {
          // If product exists in productListDisplay, update its quantity
          productListDisplay[existingIndex] =
              productList[productIndex].copyWith(quantity: newQuantity);
        } else {
          // If product does not exist, add it to productListDisplay
          productListDisplay
              .add(productList[productIndex].copyWith(quantity: newQuantity));
        }

        emit(ProductLoaded(productListDisplay)); // Emit loaded state here
        //key = UniqueKey();
      } else {
        emit(ProductError('Product not found for the provided barcode.'));
      }
    } catch (e) {
      emit(ProductError(
          'An error occurred while updating the product: ${e.toString()}'));
    }
  }

  // Method to return PlutoRow list
  List<PlutoRow> plutoRow() {
    return returnList()
        .map(
          (product) => PlutoRow(cells: {
            'name': PlutoCell(value: product.name),
            'unit': PlutoCell(value: 'pcs'),
            'quantity': PlutoCell(
                value: product.quantity,
                key: Key('${product.barcodeNumber}_quantity')),
            'price': PlutoCell(value: product.price),
            'delete': PlutoCell(value: 'delete'),
            'barcodeNumber': PlutoCell(value: product.barcodeNumber.toString()),
          }, key: Key(product.barcodeNumber.toString())),
        )
        .toList();
  }

  // Define PlutoColumn List
  List<PlutoColumn> plutoColumn() {
    return [
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
        type: PlutoColumnType.number(),
        textAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
        enableDropToResize: false,
        enableSorting: false,
        readOnly: true,
        enableEditingMode: false, // Disables editing mode for this column
        enableAutoEditing: false,

        backgroundColor: kSkyDarkColor,
        renderer: (rendererContext) {
          

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child:  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                      width: 23,
                      height: 23,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors
                              .transparent, // Make the background transparent
                          child: IconButton(
                            splashRadius:
                                25, // Set this to match the container's dimensions
                            icon: const Icon(Icons.remove),
                            iconSize:
                                16, // Adjust icon size to fit within the circle
                            padding: EdgeInsets.zero, // Remove default padding
                            constraints:
                                const BoxConstraints(), // Remove default constraints
                            onPressed: () {
                              final barcodeValue = rendererContext
                                  .row.cells['barcodeNumber']!.value;

                              final currentValue = rendererContext
                                  .row.cells['quantity']!.value as int;
                              if (currentValue > 0) {
                                rendererContext.row.cells['quantity']!.value =
                                    currentValue - 1;

                                updateProductQuantity(
                                    barcodeValue, currentValue - 1);

                                //emit(ProductDeIncrement());
                              }
                            },
                          ),
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
                      Container(
                      width: 23,
                      height: 23,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors
                              .transparent, // Make the background transparent to see the circle
                          child: IconButton(
                            splashRadius:
                                25, // Set this to match the circle's dimensions
                            icon: const Icon(Icons.add, color: kSkyDarkColor),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              final barcodeValue = rendererContext
                                  .row.cells['barcodeNumber']!.value;

                              final currentValue = rendererContext
                                  .row.cells['quantity']!.value;
                              rendererContext.row.cells['quantity']!.value =
                                  currentValue + 1;

                              updateProductQuantity(
                                  barcodeValue, currentValue + 1);

                              //emit(ProductIncrement());
                            },
                          ),
                        ),
                      ),
                    )
                    ],
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
  }

  void fetchProducts() {
    emit(ProductLoaded(returnList()));
  }

  Future<pw.Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData);
  }

  pw.Widget _productTable(pw.Font regularFont, List<ProductModel> returnList) {
    return pw.Table(
      tableWidth: pw.TableWidth.max,
      border: pw.TableBorder.all(style: pw.BorderStyle.none),
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // Products column width
        1: const pw.FlexColumnWidth(2), // Quantity column width
        2: const pw.FlexColumnWidth(2), // Price column width
        3: const pw.FlexColumnWidth(2), // Total column width
      },
      children: [
        // Header row
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
        // Product rows
        for (var product in returnList)
          _productTableRow(
              product.name, product.quantity, product.price, regularFont),
      ],
    );
  }

  pw.TableRow _productTableRow(
      String itemName, double quantity, double price, pw.Font regularFont) {
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
    const String imageUrl = 'https://i.imgur.com/Xh4atWw.png';

    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Uint8List data = response.bodyBytes;

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
    } else {
      return pw.Center(
        child: pw.Text('Failed to load image'),
      );
    }
  }

  Future<pw.Widget> _qrCodePlaceholder() async {
    const String imageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQCD0vGmt0p-HZ_Xe6LGeDbOEyWqAl6mL7hA&s';

    // Fetch the image from the web
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // If the server returns OK, get the image bytes
      Uint8List data = response.bodyBytes;

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
    } else {
      // Handle errors by returning a placeholder
      return pw.Center(
        child: pw.Text('Failed to load image'),
      );
    }
  }

// Print order functionality
  Future<void> generateInvoice(BuildContext context) async {
    log('hello');
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
              _productTable(regularFont,
                  returnList()), // Automatically splits table across pages
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
