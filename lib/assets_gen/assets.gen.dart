// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/coin-stack.svg
  String get coinStack => 'assets/icons/coin-stack.svg';

  /// File path: assets/icons/google.svg
  String get google => 'assets/icons/google.svg';

  /// File path: assets/icons/history.svg
  String get history => 'assets/icons/history.svg';

  /// File path: assets/icons/premium.svg
  String get premium => 'assets/icons/premium.svg';

  /// List of all assets
  List<String> get values => [coinStack, google, history, premium];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/employ_images
  $AssetsImagesEmployImagesGen get employImages =>
      const $AssetsImagesEmployImagesGen();

  /// Directory path: assets/images/offer_card
  $AssetsImagesOfferCardGen get offerCard => const $AssetsImagesOfferCardGen();

  /// Directory path: assets/images/onboarding_images
  $AssetsImagesOnboardingImagesGen get onboardingImages =>
      const $AssetsImagesOnboardingImagesGen();
}

class $AssetsImagesEmployImagesGen {
  const $AssetsImagesEmployImagesGen();

  /// File path: assets/images/employ_images/listener_verification_image.png
  AssetGenImage get listenerVerificationImage => const AssetGenImage(
    'assets/images/employ_images/listener_verification_image.png',
  );

  /// List of all assets
  List<AssetGenImage> get values => [listenerVerificationImage];
}

class $AssetsImagesOfferCardGen {
  const $AssetsImagesOfferCardGen();

  /// File path: assets/images/offer_card/offert_card_img.gif
  AssetGenImage get offertCardImg =>
      const AssetGenImage('assets/images/offer_card/offert_card_img.gif');

  /// List of all assets
  List<AssetGenImage> get values => [offertCardImg];
}

class $AssetsImagesOnboardingImagesGen {
  const $AssetsImagesOnboardingImagesGen();

  /// File path: assets/images/onboarding_images/carousel_im1.png
  AssetGenImage get carouselIm1 =>
      const AssetGenImage('assets/images/onboarding_images/carousel_im1.png');

  /// File path: assets/images/onboarding_images/carousel_im2.png
  AssetGenImage get carouselIm2 =>
      const AssetGenImage('assets/images/onboarding_images/carousel_im2.png');

  /// File path: assets/images/onboarding_images/carousel_im3.png
  AssetGenImage get carouselIm3 =>
      const AssetGenImage('assets/images/onboarding_images/carousel_im3.png');

  /// File path: assets/images/onboarding_images/girl_sketch1.png
  AssetGenImage get girlSketch1 =>
      const AssetGenImage('assets/images/onboarding_images/girl_sketch1.png');

  /// File path: assets/images/onboarding_images/girl_sketch2.png
  AssetGenImage get girlSketch2 =>
      const AssetGenImage('assets/images/onboarding_images/girl_sketch2.png');

  /// File path: assets/images/onboarding_images/user_name_screen_image.png
  AssetGenImage get userNameScreenImage => const AssetGenImage(
    'assets/images/onboarding_images/user_name_screen_image.png',
  );

  /// List of all assets
  List<AssetGenImage> get values => [
    carouselIm1,
    carouselIm2,
    carouselIm3,
    girlSketch1,
    girlSketch2,
    userNameScreenImage,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
