part of '../widgets.dart';

class ViewNotifier extends StatefulWidget {
  final NotifierViewController? controller;
  final OnViewClickListener? onClick, onDoubleClick, onLongClick;
  final Widget? Function(BuildContext) onNotify;

  const ViewNotifier({
    Key? key,
    required this.onNotify,
    this.controller,
    this.onClick,
    this.onDoubleClick,
    this.onLongClick,
  }) : super(key: key);

  @override
  State<ViewNotifier> createState() => _ViewNotifierState();

  Widget? build(
    BuildContext context,
    NotifierViewController controller,
    Widget? child,
  ) {
    return child;
  }
}

class _ViewNotifierState extends State<ViewNotifier> {
  late NotifierViewController controller;

  @override
  void initState() {
    controller = widget.controller ?? NotifierViewController();
    controller.setNotifier(setState);
    initController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ViewNotifier oldWidget) {
    initController();
    super.didUpdateWidget(oldWidget);
  }

  void initController() {
    controller.onClick = widget.onClick;
    controller.onDoubleClick = widget.onDoubleClick;
    controller.onLongClick = widget.onLongClick;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.onClick?.call(context),
      onDoubleTap: () => controller.onDoubleClick?.call(context),
      onLongPress: () => controller.onLongClick?.call(context),
      child: widget.build(
        context,
        controller,
        widget.onNotify.call(context),
      ),
    );
  }
}

class NotifierViewController extends ViewController {}
