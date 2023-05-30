part of '../widgets.dart';

class RenderTimeBuilder extends StatefulWidget {
  final Widget child;
  final Function(Duration duration) onRenderCallback;

  const RenderTimeBuilder({
    Key? key,
    required this.child,
    required this.onRenderCallback,
  }) : super(key: key);

  @override
  State<RenderTimeBuilder> createState() => _RenderTimeBuilderState();
}

class _RenderTimeBuilderState extends State<RenderTimeBuilder>
    with WidgetsBindingObserver {
  late DateTime _start;

  @override
  void initState() {
    super.initState();
    _start = DateTime.now();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onRenderCallback(DateTime.now().difference(_start));
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
