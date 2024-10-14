import 'package:flutter/material.dart';


class FlexibleWrapWidget extends StatelessWidget {
  const FlexibleWrapWidget({super.key,
        required this.children,
        required this.itemWidth,
        this.textDirection,
        this.direction = Axis.horizontal,
        this.alignment = WrapAlignment.start,
        this.spacing = 4.0,
        this.noWrapIndex = const [],
        this.runAlignment = WrapAlignment.start,
        this.crossAxisAlignment = WrapCrossAlignment.start,
        this.verticalDirection = VerticalDirection.down,
        this.clipBehavior});

  /// The builder function to generate children with the given index and extra width.
  final List<Widget?> children;

  /// The width of each item in the wrap.
  final double itemWidth;
  final List<int> noWrapIndex;

  /// The direction to arrange the children in (horizontal or vertical).
  final Axis direction;

  /// How the children within a run should be placed in the main axis.
  final WrapAlignment alignment;

  /// The amount of spacing between the children in the main axis.
  final double spacing;

  /// How the runs themselves should be placed in the cross axis.
  final WrapAlignment runAlignment;

  /// The amount of spacing between the runs in the cross axis.
  final double runSpacing = 0.0;

  /// How the children within a run should be aligned relative to each other in the cross axis.
  final WrapCrossAlignment crossAxisAlignment;

  /// The text direction to use when laying out the children.
  final TextDirection? textDirection;

  /// The direction to use when laying out the runs (down or up).
  final VerticalDirection verticalDirection;

  /// If non-null, determines the clip behavior of the wrap.
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      double extraWidth = 0.0;
      final double widthWithSpacing = itemWidth + spacing;
      if (constraint.maxWidth.isFinite) {
        final int items = (constraint.maxWidth / widthWithSpacing).floor();
        final double remainder = constraint.maxWidth.remainder(widthWithSpacing);
        extraWidth = remainder / items;
      }
      return Wrap(
        direction: direction,
        textDirection: textDirection,
        alignment: alignment,
        spacing: spacing,
        runSpacing: spacing,
        crossAxisAlignment: crossAxisAlignment,
        verticalDirection: verticalDirection,
        runAlignment: runAlignment,
        children: List.generate(children.length, (index) {
          return SizedBox(
            width: noWrapIndex.contains(index) ? null : itemWidth + extraWidth,
            child: children[index],
          );
        }),
      );
    });
  }
}