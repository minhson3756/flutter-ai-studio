enum IntroType {
  nativeFullAndBottomSwipe,
  nativeFullSwipe,
  nativeBottomSwipe,
  nativeBottomNoSwipe,
}

extension IntroTypeExt on IntroType {
  bool get isNativeFullAndBottomSwipe =>
      this == IntroType.nativeFullAndBottomSwipe;

  bool get isNativeFullSwipe => this == IntroType.nativeFullSwipe;

  bool get isNativeBottomSwipe => this == IntroType.nativeBottomSwipe;

  bool get isNativeBottomNoSwipe => this == IntroType.nativeBottomNoSwipe;

  bool get hasNativeFullAd =>
      this == IntroType.nativeFullAndBottomSwipe ||
      this == IntroType.nativeFullSwipe;

  bool get hasNativeBottomAd =>
      this == IntroType.nativeFullAndBottomSwipe ||
      this == IntroType.nativeBottomSwipe ||
      this == IntroType.nativeBottomNoSwipe;

  bool get enableSwipe =>
      this == IntroType.nativeFullAndBottomSwipe ||
      this == IntroType.nativeFullSwipe ||
      this == IntroType.nativeBottomSwipe;
}
