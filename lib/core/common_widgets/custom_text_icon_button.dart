import 'package:flutter/material.dart';
import 'package:onix_pos/core/common_widgets/spacer.dart';
import 'package:onix_pos/core/style/app_colors.dart';
import 'package:onix_pos/core/style/app_text_styles.dart';


class CustomTextIconButton extends StatelessWidget {
  const CustomTextIconButton(
      {super.key,
      this.onPressed,
      this.title,
      this.iconSize,
      this.width,
      this.height,
      this.txtColor,
      this.bgColor,
      this.iconColor,
      this.borderColor,
      this.icon,
      this.iconCustom});
  final Function()? onPressed;
  final String? title;
  final IconData? icon;
  final Widget? iconCustom;
  final double? iconSize;
  final double? width;
  final double? height;
  final Color? txtColor;
  final Color? iconColor;
  final Color? bgColor;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: borderColor == null ? null : Border.all(color: borderColor!),
            color: bgColor ?? kPrimaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            iconCustom ?? Icon(icon, size: iconSize ?? 12, color: iconColor),
            const WSpacer(8),
            Text(title!,
                style: AppTextStyles.styleLight12(
                  context,
                  color: txtColor,
                )),
          ],
        )
      ),
    ));
  }
}
