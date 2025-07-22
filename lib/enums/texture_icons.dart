class TextureIcons {
  static const none = TextureIcons('');
  static const checkMark = TextureIcons("✔");
  static const checkMarkGrey = TextureIcons("✔️");
  static const checkMarkBoxGreen = TextureIcons("✅");
  static const checkMarkBoxGrey = TextureIcons("☑️");
  static const crossMarkRed = TextureIcons("❌");
  static const crossMark = TextureIcons("✖");
  static const crossMarkGrey = TextureIcons("✖️");
  static const crossMarkBlocked = TextureIcons("🚫");
  static const circleRadio = TextureIcons("🔘");
  static const circleWhite = TextureIcons("⚪");
  static const circleBlack = TextureIcons("⚫");
  static const circleRed = TextureIcons("🔴");
  static const circleGreen = TextureIcons("🟢");

  final String icon;

  bool get isNone => icon.isEmpty;

  const TextureIcons(this.icon);
}
