class FullAdsOption {
  const FullAdsOption({
    this.useNull = false,
    this.useEmpty = false,
    this.useUnAttributed = false,
    this.maxFull = false,
  });

  factory FullAdsOption.fromJson(Map<String, dynamic> map) {
    return FullAdsOption(
      useNull: map['useNull'] as bool? ?? false,
      useEmpty: map['useEmpty'] as bool? ?? false,
      useUnAttributed: map['useUnAttributed'] as bool? ?? false,
      maxFull: map['maxFull'] as bool? ?? false,
    );
  }

  final bool useNull;
  final bool useEmpty;
  final bool useUnAttributed;
  final bool maxFull;

  Map<String, dynamic> toJson() {
    return {
      'useNull': useNull,
      'useEmpty': useEmpty,
      'useUnAttributed': useUnAttributed,
      'maxFull': maxFull,
    };
  }
}
