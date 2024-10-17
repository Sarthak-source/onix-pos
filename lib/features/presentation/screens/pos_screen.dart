import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_pos/core/common_widgets/custom_text_icon_button.dart';
import 'package:onix_pos/features/presentation/cubits/product_cubit.dart';
import 'package:onix_pos/features/presentation/widgets/tail_end_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../core/style/app_colors.dart';
import '../../../core/style/app_text_styles.dart';
import '../cubits/product_state.dart';
import '../widgets/product_header.dart';

class ProductOrderScreen extends StatelessWidget {
  const ProductOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..fetchProducts(),
      child: const Scaffold(
        //appBar: AppBar(title: const Text("Product Order")),
        body: ProductOrderView(),
      ),
    );
  }
}

class ProductOrderView extends StatelessWidget {
  const ProductOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 40;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const HeaderComponent(),
          const SizedBox(height: 16),
          // Product List Table
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              final productCubit = context.read<ProductCubit>();
              if (state is ProductLoading) {
                return PlutoGrid(
                  columns: context.read<ProductCubit>().column(),
                  rows: context
                      .read<ProductCubit>()
                      .plutoRow(), // Call to refresh rows
                  // ...
                );
              } else if (state is ProductLoaded) {
                return SizedBox(
                  height: rowHeight *
                      context.read<ProductCubit>().column().length *
                      1,
                  child: PlutoGrid(
                    key: productCubit.key,
                    columns: context.read<ProductCubit>().column(),
                    rows: context.read<ProductCubit>().plutoRow(),
                    configuration: PlutoGridConfiguration(
                      enableMoveDownAfterSelecting: true,
                      style: PlutoGridStyleConfig(
                        rowHeight: rowHeight,
                        gridBorderRadius: BorderRadius.circular(4),
                        cellTextStyle: AppTextStyles.styleRegular12(context,
                            color: kTextColor),
                        columnTextStyle: AppTextStyles.styleRegular12(context,
                            color: whiteColor),
                        iconSize: 12,
                        defaultColumnFilterPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        iconColor: dividerColor,
                        activatedColor: whiteColor,
                        activatedBorderColor: kPrimaryColor,
                        disabledIconColor: dividerColor,
                        borderColor: dividerColor,
                        gridBorderColor: transparent,
                      ),
                      scrollbar: const PlutoGridScrollbarConfig(
                        scrollbarThickness: 5,
                        scrollBarColor: kCardGreenColor,
                        scrollbarThicknessWhileDragging: 5,
                      ),
                    ),
                    rowColorCallback: (rowColorContext) {
                      if (rowColorContext.rowIdx % 2 == 0) {
                        return whiteColor;
                      }
                      return kColapsColor;
                    },
                  ),
                );
              } else if (state is ProductError) {
                return Center(child: Text(state.message));
              }

              return const Center(child: Text('No products available.'));
            },
          ),

          const SizedBox(height: 16),
          CustomDateRangePicker(),
          const SizedBox(height: 16),
          // Print Button
          CustomTextIconButton(
            onPressed: () {
              context.read<ProductCubit>().generateInvoice(context);
            },
            title: "Print",
            iconColor: Colors.white,
            icon: Icons.print, // You can use any icon you prefer
            iconSize: 16, // Adjust the icon size as needed
            width: 80, // Set a width for the button
            height: 35, // Set a height for the button
            txtColor: Colors.white, // Set the text color
            bgColor:
                kSkyDarkColor, // Set the background color (assuming kPrimaryColor is defined in your colors)
            borderColor:
                Colors.transparent, // Optional: Set border color if needed
          ),
        ],
      ),
    );
  }
}
