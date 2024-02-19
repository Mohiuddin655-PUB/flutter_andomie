import 'package:flutter/material.dart';

/// Signature for a callback that returns a [Future<bool>].
typedef OnLoading = Future<bool> Function();

/// Signature for a callback that takes no arguments and returns [void].
typedef OnLoad = void Function();

/// Utility class for handling pagination in a [ListView].
class Pagination {
  final ScrollController controller;
  final double preload;
  final OnLoad onLoad;
  final OnLoading onLoading;

  /// Constructor for [Pagination].
  /// - [controller]: Scroll controller for the associated [ListView].
  /// - [onLoad]: Callback to be triggered when loading more items is required.
  /// - [onLoading]: Asynchronous callback to determine if loading is in progress.
  /// - [preload]: The distance from the end at which preloading should be triggered.
  Pagination({
    required this.controller,
    required this.onLoad,
    required this.onLoading,
    this.preload = 1000,
  }) {
    controller.addListener(_checker);
  }

  /// Internal method to check and trigger loading or preloading.
  void _checker() {
    onLoading().onError((_, __) => false).then((value) {
      if (!value) {
        if (preload > 0) {
          _preloader();
        } else {
          _loader();
        }
      }
    });
  }

  /// Internal method to trigger loading when reaching the end.
  void _loader() {
    if (controller.position.atEdge) {
      if (controller.position.pixels != 0) {
        onLoad();
      }
    }
  }

  /// Internal method to trigger preloading when approaching the end.
  void _preloader() {
    final pixels = controller.position.pixels;
    final extend = controller.position.maxScrollExtent - preload;
    if (pixels != 0 && pixels >= extend) {
      onLoad();
    }
  }
}

/// Extension of [ScrollController] with additional pagination functionality.
class PaginationController extends ScrollController {
  /// Method to enable pagination for the associated [ListView].
  /// - [preload]: The distance from the end at which preloading should be triggered.
  /// - [onLoad]: Callback to be triggered when loading more items is required.
  /// - [onLoading]: Asynchronous callback to determine if loading is in progress.
  void paginate({
    double preload = 1000,
    required OnLoad onLoad,
    required OnLoading onLoading,
  }) {
    Pagination(
      controller: this,
      preload: preload,
      onLoad: onLoad,
      onLoading: onLoading,
    );
  }
}
