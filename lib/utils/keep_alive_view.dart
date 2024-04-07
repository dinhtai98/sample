import 'package:flutter/widgets.dart';

class KeepAliveView extends StatefulWidget {
  final Widget child;
  const KeepAliveView({
    super.key,
    required this.child,
  });

  @override
  State<KeepAliveView> createState() => _KeepAliveViewState();
}

class _KeepAliveViewState extends State<KeepAliveView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
