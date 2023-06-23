part of '../utils.dart';

class ColorConfig extends ColorState {
  final int primary;
  final int? secondary;
  final int? activated, inactivated, enabled, disabled, focused, unfocused;

  const ColorConfig({
    required this.primary,
    this.secondary,
    this.activated,
    this.inactivated,
    this.enabled,
    this.disabled,
    this.focused,
    this.unfocused,
  }) : super(activeValue: primary, inactiveValue: secondary);

  factory ColorConfig.fromCode({
    required int primary,
    int? secondary,
    int? activated,
    int? inactivated,
    int? enabled,
    int? disabled,
    int? focused,
    int? unfocused,
  }) {
    return ColorConfig(
      primary: primary,
      secondary: secondary,
      activated: activated,
      inactivated: inactivated,
      enabled: enabled,
      disabled: disabled,
      focused: focused,
      unfocused: unfocused,
    );
  }

  factory ColorConfig.of({
    required dynamic primary,
    dynamic secondary,
    dynamic activated,
    dynamic inactivated,
    dynamic enabled,
    dynamic disabled,
    dynamic focused,
    dynamic unfocused,
  }) {
    return ColorConfig(
      primary: primary is Color
          ? primary.value
          : primary is int
              ? primary
              : 0,
      secondary: secondary is Color
          ? secondary.value
          : secondary is int
              ? secondary
              : 0,
      activated: activated is Color
          ? activated.value
          : activated is int
              ? activated
              : 0,
      inactivated: inactivated is Color
          ? inactivated.value
          : inactivated is int
              ? inactivated
              : 0,
      enabled: enabled is Color
          ? enabled.value
          : enabled is int
              ? enabled
              : 0,
      disabled: disabled is Color
          ? disabled.value
          : disabled is int
              ? disabled
              : 0,
      focused: focused is Color
          ? focused.value
          : focused is int
              ? focused
              : 0,
      unfocused: unfocused is Color
          ? unfocused.value
          : unfocused is int
              ? unfocused
              : 0,
    );
  }

  factory ColorConfig.fromColor({
    required Color primary,
    Color? secondary,
    Color? activated,
    Color? inactivated,
    Color? enabled,
    Color? disabled,
    Color? focused,
    Color? unfocused,
  }) {
    return ColorConfig(
      primary: primary.value,
      secondary: secondary?.value,
      activated: activated?.value,
      inactivated: inactivated?.value,
      enabled: enabled?.value,
      disabled: disabled?.value,
      focused: focused?.value,
      unfocused: unfocused?.value,
    );
  }

  Color get activatedColor => activatedColorState.active;

  Color get inactivatedColor => activatedColorState.inactive;

  Color get enabledColor => enabledColorState.active;

  Color get disabledColor => enabledColorState.inactive;

  Color get focusedColor => focusedColorState.active;

  Color get unfocusedColor => focusedColorState.inactive;

  ColorState get activatedColorState {
    return ColorState(
      activeValue: activated ?? primary,
      inactiveValue: inactivated ?? secondary ?? primary,
    );
  }

  ColorState get enabledColorState {
    return ColorState(
      activeValue: enabled ?? primary,
      inactiveValue: disabled ?? secondary ?? primary,
    );
  }

  ColorState get focusedColorState {
    return ColorState(
      activeValue: focused ?? primary,
      inactiveValue: unfocused ?? secondary ?? primary,
    );
  }
}

class ColorState extends Color {
  final int activeValue;
  final int? inactiveValue;

  const ColorState({
    required this.activeValue,
    this.inactiveValue,
  }) : super(activeValue);

  factory ColorState.of({
    required dynamic active,
    dynamic inactive,
  }) {
    final a = active is Color
        ? active.value
        : active is int
            ? active
            : 0;
    final b = inactive != null
        ? inactive is Color
            ? inactive.value
            : inactive is int
                ? inactive
                : 0
        : a;
    return ColorState(
      activeValue: a,
      inactiveValue: b,
    );
  }

  factory ColorState.fromColor({
    required Color active,
    Color? inactive,
  }) {
    final a = active.value;
    final b = inactive?.value;
    return ColorState(
      activeValue: a,
      inactiveValue: b,
    );
  }

  Color get active => Color(activeValue);

  Color get inactive => Color(inactiveValue ?? activeValue);

  Color detect(bool activated) => activated ? active : inactive;
}
