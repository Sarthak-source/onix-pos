// ignore_for_file: unnecessary_const

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_pos/core/common_widgets/custom_textfiled_purchase.dart';
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/features/presentation/cubits/product_cubit.dart';

import '../../../core/common_widgets/custom_text_icon_button.dart';

class HeaderComponent extends StatelessWidget {
  const HeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return Container(
            color: barCodeColor,
            width: MediaQuery.of(context).size.width,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final productCubit = context.read<ProductCubit>();

        return BarcodeKeyboardListener(
          onBarcodeScanned: (barcode) {
            productCubit.barcodeController.text = barcode;
            productCubit.fetchProductByBarcode(barcode); // Call cubit method
          },
          child: Container(
            color: barCodeColor,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final buttonWidth = constraints.maxWidth * 0.1;
                  final defaultQuantityWidth = constraints.maxWidth * 0.2;
                  final barcodeWidth = constraints.maxWidth * 0.65;
                  const spacerWidth = 10.0;

                  return Row(
                    children: [
                      SizedBox(
                        width: buttonWidth,
                        child: CustomTextIconButton(
                          onPressed: () {
                            log('message 1');
                            bool isBarcodeValid = productCubit.isValidBarcode(
                                productCubit.barcodeController.text);
                            double? quantity = double.tryParse(productCubit
                                .defaultQuantityController.text
                                .trim());

// Check if barcode is valid and quantity is a valid non-zero number
                            if (isBarcodeValid &&
                                (quantity != null && quantity > 0)) {
                              log('message 2');
                              productCubit.addProduct();
                            } else {
                              log('message 3');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Invalid barcode or quantity is 0'),
                                  duration: Duration(
                                      seconds:
                                          2), // How long the Snackbar will be visible
                                ),
                              );
                            }
                          },
                          title: 'إضافة',
                          icon: Icons.add,
                          iconSize: 16.0,
                          txtColor: whiteColor,
                          iconColor: whiteColor,
                          bgColor: homeButtonColor,
                          width: 100.0,
                          height: 40.0,
                        ),
                      ),
                      const SizedBox(width: spacerWidth),
                      SizedBox(
                        width: defaultQuantityWidth,
                        child: CustomTextFieldPurchase(
                          controller: productCubit.defaultQuantityController,
                          hint: 'الكمية الإفتراضية',
                          labelText: 'الكمية الإفتراضية',
                          elevation: 0,
                          type: TextInputType.number,
                          isRequired: true,
                          textInputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: spacerWidth),
                      SizedBox(
                        width: barcodeWidth,
                        child: CustomTextFieldPurchase(
                          controller: productCubit.barcodeController,
                          hint: 'رقم الباركود',
                          labelText: 'رقم الباركود',
                          elevation: 0,
                          isRequired: true,
                          onChanged: (v) {
                            if (productCubit.isValidBarcode(v)) {
                              productCubit.defaultQuantityController.text = '1';
                            } else {
                              // Optionally handle invalid barcode (e.g., show an error message)
                              productCubit.defaultQuantityController.text = '';
                              //print('Invalid barcode');
                            }
                          },
                          suffixIcon: BarcodeKeyboardListener(
                            onBarcodeScanned: (barcode) {
                              productCubit.barcodeController.text = barcode;
                            },
                            child: const Icon(Icons.qr_code),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
