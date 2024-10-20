import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_pos/core/common_widgets/custom_textfiled_purchase.dart';
import 'package:onix_pos/core/shared_cubits/responsive_cubite/responsive_cubit.dart';
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/features/presentation/cubits/product_cubit.dart';
import 'package:onix_pos/features/presentation/cubits/product_state.dart';

import '../../../core/common_widgets/custom_text_icon_button.dart';

class HeaderComponent extends StatelessWidget {
  const HeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final productCubit = context.read<ProductCubit>();

        return BlocBuilder<ResponsiveCubit, ResponsiveState>(
          builder: (context, state) {
            final isMobile = context.read<ResponsiveCubit>().isMobile(context);
            final isTablet = context.read<ResponsiveCubit>().isTablet(context);
            final shouldStack = isMobile || isTablet;

            return BarcodeKeyboardListener(
              onBarcodeScanned: (barcode) {
                productCubit.barcodeController.text = barcode;
                productCubit
                    .fetchProductByBarcode(barcode); // Call cubit method
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
                      final barcodeWidth = (isMobile || isTablet)
                          ? (constraints.maxWidth * 0.75)
                          : (constraints.maxWidth * 0.65);
                      const spacerWidth = 10.0;

                      return shouldStack
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: defaultQuantityWidth,
                                      child: CustomTextFieldPurchase(
                                        controller: productCubit
                                            .defaultQuantityController,
                                        hint: 'الكمية الإفتراضية',
                                        labelText: 'الكمية الإفتراضية',
                                        elevation: 0,
                                        type: TextInputType.number,
                                        isRequired: true,
                                        textInputFormatter: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: spacerWidth+15),
                                    SizedBox(
                                      width: barcodeWidth,
                                      child: CustomTextFieldPurchase(
                                        controller:
                                            productCubit.barcodeController,
                                        hint: 'رقم الباركود',
                                        labelText: 'رقم الباركود',
                                        elevation: 0,
                                        isRequired: true,
                                        onChanged: (v) {
                                          if (productCubit.isValidBarcode(v)) {
                                            productCubit
                                                .defaultQuantityController
                                                .text = '1';
                                          } else {
                                            productCubit
                                                .defaultQuantityController
                                                .text = '';
                                          }
                                        },
                                        suffixIcon: BarcodeKeyboardListener(
                                          onBarcodeScanned: (barcode) {
                                            productCubit.barcodeController
                                                .text = barcode;
                                          },
                                          child: const Icon(Icons.qr_code),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  width: constraints.maxWidth,
                                  child: CustomTextIconButton(
                                    onPressed: () {
                                      log('message 1');
                                      bool isBarcodeValid = productCubit
                                          .isValidBarcode(productCubit
                                              .barcodeController.text);
                                      double? quantity = double.tryParse(
                                          productCubit
                                              .defaultQuantityController.text
                                              .trim());

                                      if (!isBarcodeValid) {
                                        log('Invalid barcode');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Invalid barcode'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else if (quantity == null ||
                                          quantity <= 0) {
                                        log('Invalid quantity');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Quantity must be greater than 0'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        log('message 2');
                                        productCubit.addProduct();
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
                              ],
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  width: defaultQuantityWidth,
                                  child: CustomTextFieldPurchase(
                                    controller:
                                        productCubit.defaultQuantityController,
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
                                        productCubit.defaultQuantityController
                                            .text = '1';
                                      } else {
                                        productCubit.defaultQuantityController
                                            .text = '';
                                      }
                                    },
                                    suffixIcon: BarcodeKeyboardListener(
                                      onBarcodeScanned: (barcode) {
                                        productCubit.barcodeController.text =
                                            barcode;
                                      },
                                      child: const Icon(Icons.qr_code),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: spacerWidth),
                                SizedBox(
                                  width: buttonWidth,
                                  child: CustomTextIconButton(
                                    onPressed: () {
                                      log('message 1');
                                      bool isBarcodeValid = productCubit
                                          .isValidBarcode(productCubit
                                              .barcodeController.text);
                                      double? quantity = double.tryParse(
                                          productCubit
                                              .defaultQuantityController.text
                                              .trim());

                                      if (!isBarcodeValid) {
                                        log('Invalid barcode');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Invalid barcode'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else if (quantity == null ||
                                          quantity <= 0) {
                                        log('Invalid quantity');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Quantity must be greater than 0'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } else {
                                        log('message 2');
                                        productCubit.addProduct();
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
                              ],
                            );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
