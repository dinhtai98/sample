import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoadingWidget({
    required this.child,
    this.isLoading = true,
  }) : super(key: null);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: child,
      );
    } else {
      return child;
    }
  }
}
