import 'package:flutter/material.dart';
import 'package:onix_pos/core/common_widgets/custom_drop_down_with_textForm.dart';
import 'package:onix_pos/core/common_widgets/custom_textfiled_purchase.dart';
import 'package:onix_pos/core/common_widgets/flexible_wrap_widgets.dart';
import 'package:onix_pos/core/common_widgets/size_ext.dart';

class CustomDateRangePicker extends StatelessWidget {
  
   CustomDateRangePicker({super.key});
    final TextEditingController _dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return FlexibleWrapWidget(
      itemWidth: context.width*0.4, // Set an appropriate width for each item
      spacing: 16, // Add spacing between the items
      children: [
        // Custom TextField (e.g., a date picker)
        CustomTextFieldPurchase(
          isDatePicker: true, // Enable date picker overlay
          controller: _dateController,
          hint: 'تاريخ الإنتهاء',
          prefixIcon: Icons.calendar_today,
          onTap: () {
            // Custom handling logic if needed
          },
        ),
        
        // Custom Dropdown (replacing with CustomDropDownWithTextForm)
        CustomDropDownWithTextForm(
          hint: 'المقطع التحليلي',
          list: const ['Option 1', 'Option 2'],  // Replace with actual data
          onChanged: (value) {
            // Handle dropdown value change
          },
          selectedItem: null,  // Set initial selected value if needed
        ),
      ],
    );
  }
}
