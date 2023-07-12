part of '../utils.dart';

class AppNavigator {
  static const String screen = "screen";
  static const String next = "next";
  static const String data = "data";

  static Future<T?> load<T extends Object?, R extends Object?>(
    BuildContext context,
    dynamic route, {
    String? name,
    Map<String, dynamic>? arguments,
    Flag flag = Flag.none,
    RoutePredicate? predicate,
    R? result,
    AnimType type = AnimType.slideLeft,
  }) {
    if (flag == Flag.replacement) {
      if (route is String) {
        return Navigator.pushReplacementNamed(
          context,
          route,
          result: result,
          arguments: arguments,
        );
      } else if (route is Widget) {
        return Navigator.pushReplacement(
          context,
          result: result,
          AppRoute<T>(
            name: name,
            arguments: arguments,
            child: route,
          ),
        );
      } else {
        return Navigator.pushNamed(context, "error");
      }
    } else if (flag == Flag.clear) {
      if (route is String) {
        return Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          predicate ?? (value) => false,
          arguments: arguments,
        );
      } else if (route is Widget) {
        return Navigator.pushAndRemoveUntil(
            context,
            AppRoute<T>(
              name: name,
              arguments: arguments,
              child: route,
            ),
            predicate ?? (route) => false);
      } else {
        return Navigator.pushNamed(context, "error");
      }
    } else {
      if (route is String) {
        return Navigator.pushNamed(
          context,
          route,
          arguments: arguments,
        );
      } else if (route is Widget) {
        return Navigator.push(
          context,
          AppRoute<T>(
            name: name,
            arguments: arguments,
            child: route,
          ),
        );
      } else {
        return Navigator.pushNamed(context, "error");
      }
    }
  }
}

class AppRoute<T> extends PageRouteBuilder<T> {
  final String? name;
  final int? animationTime;
  final AnimType animationType;
  final Map<String, dynamic>? arguments;
  final Widget child;

  AppRoute({
    this.name,
    this.animationTime,
    this.arguments,
    this.animationType = AnimType.slideRight,
    required this.child,
  }) : super(pageBuilder: (context, a1, a2) => child);

  @override
  RouteSettings get settings {
    return RouteSettings(
      name: name ?? super.settings.name,
      arguments: arguments ?? super.settings.arguments,
    );
  }

  @override
  Duration get transitionDuration => animationTime != null
      ? Duration(milliseconds: animationTime ?? 300)
      : super.transitionDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Anim(animation, secondaryAnimation).select(child, animationType);
  }
}

class Anim {
  final Animation<double> primary;
  final Animation<double> secondary;

  const Anim(
    this.primary, [
    Animation<double>? secondary,
  ]) : secondary = secondary ?? primary;

  Widget select(Widget view, AnimType type) {
    switch (type) {
      case AnimType.none:
        return slideLeft(view);
      case AnimType.card:
        return slideLeft(view);
      case AnimType.diagonal:
        return slideLeft(view);
      case AnimType.fade:
        return fade(view);
      case AnimType.inAndOut:
        return slideLeft(view);
      case AnimType.shrink:
        return slideLeft(view);
      case AnimType.spin:
        return slideLeft(view);
      case AnimType.split:
        return slideLeft(view);
      case AnimType.slideLeft:
        return slideLeft(view);
      case AnimType.slideRight:
        return slideRight(view);
      case AnimType.slideDown:
        return slideRight(view);
      case AnimType.slideUp:
        return slideRight(view);
      case AnimType.swipeLeft:
        return slideRight(view);
      case AnimType.swipeRight:
        return slideRight(view);
      case AnimType.windmill:
        return slideRight(view);
      case AnimType.zoom:
        return slideRight(view);
    }
  }

  Widget slideLeft(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget slideRight(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget slideRightWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(
        opacity: primary.value,
        child: view,
      ),
    );
  }

  Widget fade(Widget view) {
    return Opacity(
      opacity: primary.value,
      child: view,
    );
  }
}

enum Flag {
  none,
  clear,
  replacement,
}

enum AnimType {
  none,
  card,
  diagonal,
  fade,
  inAndOut,
  shrink,
  spin,
  split,
  slideLeft,
  slideRight,
  slideDown,
  slideUp,
  swipeLeft,
  swipeRight,
  windmill,
  zoom;
}
