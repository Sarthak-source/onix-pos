import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/app_colors.dart';
import '../style/app_text_styles.dart';


class CustomTextFieldPurchase extends StatefulWidget {
  const CustomTextFieldPurchase({
    super.key,
    this.width,
    this.height,
    this.labelText,
    this.nextFocus,
    this.errorText,
    this.hint,
    this.onSave,
    this.onTap,
    this.isRequired = false,
    this.fillColor,
    this.maxLines,
    this.onChanged,
    this.suffixIcon,
    this.type,
    this.validator,
    this.controller,
    this.focus,
    this.prefixIcon,
    this.elevation,
    this.label,
    this.readOnly = false,
    this.textInputFormatter,
    this.isDatePicker = false,
  });

  final String? hint;
  final bool isDatePicker;
  final String? labelText;
  final String? errorText;
  final Widget? label;
  final TextInputType? type;
  final List<TextInputFormatter>? textInputFormatter;
  final ValueChanged<String>? onSave;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final double? elevation;
  final Color? fillColor;
  final IconData? prefixIcon;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final bool readOnly;
  final int? maxLines;
  final bool isRequired;
  final double? width;
  final double? height;

  @override
  _CustomTextFieldPurchaseState createState() =>
      _CustomTextFieldPurchaseState();
}

class _CustomTextFieldPurchaseState extends State<CustomTextFieldPurchase> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Function to create the overlay entry
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    //var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0.0, size.height + 5.0), // Show date picker below the text field
          child: Material(
            elevation:widget.elevation??  4.0,
            color: Colors.white,
            child: SizedBox(
              height: 300,
              child: Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: kPrimaryColor, // Header background color
                  datePickerTheme: DatePickerThemeData(
                    dayStyle: AppTextStyles.styleLight12(
                      context,
                      color: Colors.grey,
                    ),
                    weekdayStyle: AppTextStyles.styleLight12(context,
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  colorScheme: const ColorScheme.light(
                    primary: kPrimaryColor, // Header text and icon color
                    onSurface: Colors.black, // Day number text color
                  ),
                  buttonTheme: const ButtonThemeData(
                      textTheme: ButtonTextTheme.primary // Button text color
                      ),
                ),
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (selectedDate) {
                    widget.controller?.text =
                        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                    _overlayEntry?.remove();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }


  @override
  Widget build(BuildContext context) {
    log(widget.isDatePicker.toString());
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: dividerColor.withOpacity(0.15))]),
          child: TextFormField(
            onTap: widget.isDatePicker
                ? () {
                    if (_overlayEntry == null) {
                      _showOverlay();
                    } else {
                      _removeOverlay();
                    }
                  }
                : widget.onTap,
            validator: widget.isRequired? widget.validator:null,
            controller: widget.controller,
            cursorColor: kPrimaryColor,
            focusNode: widget.focus,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines ?? 1,
            keyboardType: widget.type,
            cursorHeight: 10,
            cursorRadius: const Radius.circular(5),
            onChanged: widget.onChanged,
            inputFormatters: widget.textInputFormatter,
            style: AppTextStyles.styleLight12(context),
            decoration: InputDecoration(
              constraints:
                  BoxConstraints(minHeight: widget.height ?? 40, maxHeight: 60),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
              prefix: const Padding(padding: EdgeInsets.only(top: 20.0)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              floatingLabelStyle: AppTextStyles.styleLight12(context),
              helperStyle: AppTextStyles.styleLight12(context),
              labelStyle:
                  AppTextStyles.styleLight12(context, color: kBlackText),
              hintStyle:
                  AppTextStyles.styleLight12(context, color: kTextFieldColor),
              errorStyle: AppTextStyles.styleLight12(context,
                  color: kButtonRedDark, fontSize: 8),
              suffixIcon:
                  widget.suffixIcon ?? const SizedBox(height: 10, width: 10),
              filled: true,
              isDense: true,
              fillColor: widget.readOnly
                  ? kColapsColor
                  : widget.fillColor ?? whiteColor,
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
          )),
    );
  }
}
