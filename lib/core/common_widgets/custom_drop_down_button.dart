import 'package:flutter/cupertino.dart';
import 'package:onix_pos/core/common_widgets/size_ext.dart';
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/core/style/app_text_styles.dart';


class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    this.height,
    this.width,
    required this.label,
    this.selectedValue,
    this.bgColor,
    this.isRequired = false,
    this.borderColor,
  });

  final double? width;
  final double? height;
  final String label;
  final bool isRequired;
  final Color? borderColor;
  final Color? bgColor;
  final String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      constraints: BoxConstraints(minHeight: height ?? 35, maxHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(
            selectedValue ?? '',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.styleLight12(context),
          ),),

          Container(
            padding: const EdgeInsets.only(left: 2,right: 2,bottom: 8),
            child:  const Icon(
              CupertinoIcons.chevron_down,
              size: 10,
              color: kTextFiledColor,
            ),
          )
        ],
      ),
    );
  }
}