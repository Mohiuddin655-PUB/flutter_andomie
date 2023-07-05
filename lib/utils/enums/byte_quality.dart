part of 'enums.dart';

enum ByteQuality {
  standardQualityPhoto(_mb),
  highQualityPhoto(_mb * 2),
  mediumQualityPhoto(_mb / 2),
  lowQualityPhoto(_mb / 4);

  final double value;

  const ByteQuality(this.value);

  static const double _mb = 1024 * 1024;
}
