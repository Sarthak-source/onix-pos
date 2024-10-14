
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onix_pos/core/common_widgets/custom_drop_down_button.dart';
import 'package:onix_pos/core/common_widgets/custom_drop_down_with_textForm.dart';
import 'package:onix_pos/core/common_widgets/size_ext.dart';
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/core/style/app_text_styles.dart';

export 'package:dropdown_button2/dropdown_button2.dart';


class CustomDropDownWithTextForm extends StatefulWidget {

  const CustomDropDownWithTextForm({
    super.key,
    this.width,
    this.height,
    this.labelText,
    this.errorText,
    this.isRequired = false,
    this.enableSearch = false,
    this.fillColor,
    this.suffixIcon,
    this.type,
    this.validator,
    this.prefixIcon,
    this.label,
    this.readOnly = false,
    this.textInputFormatter,
    this.bgColor,
    this.onChanged,
    this.selectedItem,
    this.borderColor,
    this.onMenuStateChange,
    required this.hint,
    required this.list,
  });
  final String hint;
  final String? labelText;
  final String? errorText;
  final Widget? label;
  final TextInputType? type;
  final List<TextInputFormatter>? textInputFormatter;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Color? fillColor;
  final IconData? prefixIcon;
  final bool readOnly;
  final bool enableSearch;
  final bool isRequired;
  final double? width;
  final double? height;
  final List<String> list;
  final String? selectedItem;
  final Function(String? value)? onChanged;
  final Function(bool)? onMenuStateChange;
  final Color? borderColor;
  final Color? bgColor;

  @override
  State<CustomDropDownWithTextForm> createState() => _CustomDropDownWithTextFormState();
}
class _CustomDropDownWithTextFormState extends State<CustomDropDownWithTextForm> {
  TextEditingController? searchCont;

  @override
  void initState() {
    searchCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchCont!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<String>(
          
          isExpanded: true,
          decoration: InputDecoration(
            constraints: BoxConstraints(
                minHeight: widget.height ?? 40, maxHeight: 60),
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.hint,
                      style: AppTextStyles.styleLight12(
                        context,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: widget.isRequired ? ' *' : '  ',
                      style: AppTextStyles.styleLight12(context,
                          color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
            floatingLabelStyle: AppTextStyles.styleLight12(context),
            helperStyle: AppTextStyles.styleLight12(context),
            labelStyle: AppTextStyles.styleLight12(context, color: kBlackText),
            hintStyle: AppTextStyles.styleLight12(context, color: kTextFieldColor),
            errorStyle: AppTextStyles.styleLight12(context,
                color: kButtonRedDark, fontSize: 8),
            filled: true,
            isDense: true,
            fillColor: widget.readOnly ? kColapsColor : widget.fillColor ?? whiteColor,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kButtonRedDark,
                )),
          ),
          customButton: CustomDropDownButton(
            isRequired: widget.isRequired,
            width: widget.width,
            selectedValue: widget.selectedItem,
            label: widget.hint,
          ),
          items: widget.list.map((String item) =>
              DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                      height: 40,
                      width: context.width,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: dividerColor))
                      ),
                      child: Center(
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.styleLight12(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  )
              )).toList(),
          value: widget.selectedItem,
          onChanged: widget.readOnly ? null : widget.onChanged,
          // onChanged: widget.onChanged,
          dropdownStyleData: DropdownStyleData(
            maxHeight: context.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: whiteColor,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all<double>(6),
              thumbVisibility: WidgetStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.zero
          ),
          dropdownSearchData: !widget.enableSearch
              ? null
              : DropdownSearchData(
            searchController: searchCont,
            searchInnerWidgetHeight: 100,
            searchInnerWidget: Container(
              height: 40,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                style: AppTextStyles.styleLight12(context),
                textInputAction: TextInputAction.done,
                controller: searchCont,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'search_for_item',
                  hintStyle: AppTextStyles.styleLight12(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          validator: (value) {
            if (value == null) {
              return 'this_right_is_required';
            }
            return null;
          },
        ),
      ),
    );
  }
}