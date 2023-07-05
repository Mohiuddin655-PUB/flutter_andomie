part of '../utils.dart';

class IconConfig extends IconState {
  final int primary;
  final int? secondary;
  final int? activated, inactivated, enabled, disabled, focused, unfocused;

  const IconConfig({
    required this.primary,
    this.secondary,
    this.activated,
    this.inactivated,
    this.enabled,
    this.disabled,
    this.focused,
    this.unfocused,
  }) : super(activeValue: primary, inactiveValue: secondary);

  factory IconConfig.of({
    required dynamic primary,
    dynamic secondary,
    dynamic activated,
    dynamic inactivated,
    dynamic enabled,
    dynamic disabled,
    dynamic focused,
    dynamic unfocused,
  }) {
    return IconConfig(
      primary: primary is IconData
          ? primary.codePoint
          : primary is int
              ? primary
              : 0,
      secondary: secondary is IconData
          ? secondary.codePoint
          : secondary is int
              ? secondary
              : 0,
      activated: activated is IconData
          ? activated.codePoint
          : activated is int
              ? activated
              : 0,
      inactivated: inactivated is IconData
          ? inactivated.codePoint
          : inactivated is int
              ? inactivated
              : 0,
      enabled: enabled is IconData
          ? enabled.codePoint
          : enabled is int
              ? enabled
              : 0,
      disabled: disabled is IconData
          ? disabled.codePoint
          : disabled is int
              ? disabled
              : 0,
      focused: focused is IconData
          ? focused.codePoint
          : focused is int
              ? focused
              : 0,
      unfocused: unfocused is IconData
          ? unfocused.codePoint
          : unfocused is int
              ? unfocused
              : 0,
    );
  }

  IconData get activatedColor => activatedColorState.active;

  IconData get inactivatedColor => activatedColorState.inactive;

  IconData get enabledColor => enabledColorState.active;

  IconData get disabledColor => enabledColorState.inactive;

  IconData get focusedColor => focusedColorState.active;

  IconData get unfocusedColor => focusedColorState.inactive;

  IconState get activatedColorState {
    return IconState(
      activeValue: activated ?? primary,
      inactiveValue: inactivated ?? secondary ?? primary,
    );
  }

  IconState get enabledColorState {
    return IconState(
      activeValue: enabled ?? primary,
      inactiveValue: disabled ?? secondary ?? primary,
    );
  }

  IconState get focusedColorState {
    return IconState(
      activeValue: focused ?? primary,
      inactiveValue: unfocused ?? secondary ?? primary,
    );
  }
}

class IconState extends IconData {
  final int activeValue;
  final int? inactiveValue;

  const IconState({
    required this.activeValue,
    this.inactiveValue,
    super.fontFamily,
    super.fontPackage,
    super.matchTextDirection,
  }) : super(activeValue);

  factory IconState.of({
    required dynamic active,
    dynamic inactive,
  }) {
    final a = active is IconData
        ? active.codePoint
        : active is int
            ? active
            : 0;
    final b = inactive != null
        ? inactive is IconData
            ? inactive.codePoint
            : inactive is int
                ? inactive
                : 0
        : a;
    return IconState(
      activeValue: a,
      inactiveValue: b,
    );
  }

  factory IconState.fromIcon({
    required IconData active,
    IconData? inactive,
  }) {
    final a = active.codePoint;
    final b = inactive?.codePoint;
    return IconState(
      activeValue: a,
      inactiveValue: b,
    );
  }

  IconData get active => IconData(activeValue);

  IconData get inactive => IconData(inactiveValue ?? activeValue);

  IconData detect(bool activated) => activated ? active : inactive;
}
