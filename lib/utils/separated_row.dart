import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class SeparatedRow extends StatelessWidget {
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool isAddLastSeparator;

  const SeparatedRow({
    super.key,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.textBaseline,
    required this.children,
    this.separatorBuilder,
    this.isAddLastSeparator = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> separatorChildren = [];
    if (separatorBuilder != null) {
      children.forEachIndexed((index, child) {
        separatorChildren.add(child);
        if (isAddLastSeparator) {
          separatorChildren.add(separatorBuilder!.call(context, index));
        } else if (index < children.length - 1) {
          separatorChildren.add(separatorBuilder!.call(context, index));
        }
      });
    } else {
      separatorChildren = children;
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      textDirection: textDirection,
      verticalDirection: verticalDirection ?? VerticalDirection.down,
      textBaseline: textBaseline,
      children: separatorChildren,
    );
  }
}
