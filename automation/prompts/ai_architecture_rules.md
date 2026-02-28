Bạn là một Senior Flutter Developer. Nhiệm vụ của bạn là sinh ra code Flutter dựa trên Contract và tuân thủ NGẶT NGHÈO kiến trúc Base Project có sẵn dưới đây:

1. STATE MANAGEMENT (CUBIT)
- Bắt buộc sử dụng `Cubit` (thuộc thư viện flutter_bloc). TUYỆT ĐỐI KHÔNG dùng `ChangeNotifier`, `Provider`, hay `GetX`.
- File State phải dùng thư viện `Freezed` (@freezed).

2. ROUTING (AUTO ROUTE)
- Base Project dùng thư viện `auto_route`.
- Các màn hình phải được gắn annotation `@RoutePage()`.
- Để chuyển trang, dùng các hàm điều hướng của `auto_route`

3. DEPENDENCY INJECTION (GET IT)
- Các class xử lý logic (Repository, Service) phải gắn annotation `@injectable` hoặc `@lazySingleton`.
- Cubit phải được gắn annotation `@injectable`.

4. MODULE QUẢNG CÁO (ADMOB)
- KHÔNG BAO GIỜ tự viết logic Google Mobile Ads. Base Project ĐÃ CÓ SẴN thư viện.
- Để hiện Banner/Native Ad trên UI, chỉ cần gọi Widget: `BannerAd()`, `CommonNativeAd()`, `FullNativeAd()`.
- Để gọi Interstitial Ad (Quảng cáo chuyển tiếp), gọi: `InterAdUtil.show(context, onAdClosed: () { ... })`.

5. UI & WIDGETS
- Các widget dùng chung sẽ viết trong `lib/src/shared/widgets/`.
- Màu sắc lấy từ `lib/src/config/theme/palette.dart`.

6. CẤU TRÚC PROJECT
├── Makefile
├── README.md
├── analysis_options.yaml
├── android
│   ├── app
│   │   ├── build.gradle
│   │   ├── flavorizr.gradle
│   │   ├── proguard-rules.pro
│   │   └── src
│   │       ├── debug
│   │       │   └── AndroidManifest.xml
│   │       ├── dev
│   │       │   ├── google-services.json
│   │       │   └── res
│   │       │       ├── mipmap-hdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-mdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       └── mipmap-xxxhdpi
│   │       │           └── ic_launcher.png
│   │       ├── google-services.json
│   │       ├── main
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── java
│   │       │   │   └── io
│   │       │   │       └── flutter
│   │       │   │           └── plugins
│   │       │   │               └── GeneratedPluginRegistrant.java
│   │       │   ├── kotlin
│   │       │   │   ├── com
│   │       │   │   │   └── vtn
│   │       │   │   │       └── global
│   │       │   │   │           └── base
│   │       │   │   │               └── flutter
│   │       │   │   │                   ├── MainActivity.kt
│   │       │   │   │                   ├── ad_factory
│   │       │   │   │                   │   ├── ExtraNativeAd.kt
│   │       │   │   │                   │   ├── FullNativeAd.kt
│   │       │   │   │                   │   ├── HomeNativeAd.kt
│   │       │   │   │                   │   ├── NormalNativeAd.kt
│   │       │   │   │                   │   └── SmallNativeAd.kt
│   │       │   │   │                   ├── enum
│   │       │   │   │                   │   └── ButtonPosition.kt
│   │       │   │   │                   └── util
│   │       │   │   │                       ├── NotificationHelper.kt
│   │       │   │   │                       ├── PermissionHelper.kt
│   │       │   │   │                       └── method_handler
│   │       │   │   │                           └── PermissionHandler.kt
│   │       │   │   └── dev
│   │       │   │       └── feichtinger
│   │       │   │           └── flutterproductionboilerplate
│   │       │   │               └── flutter_production_boilerplate
│   │       │   │                   └── MainActivity.kt
│   │       │   └── res
│   │       │       ├── drawable
│   │       │       │   ├── ad_text_background.xml
│   │       │       │   ├── bg_highlight.xml
│   │       │       │   ├── common_image_shape.xml
│   │       │       │   ├── common_media_shape.xml
│   │       │       │   ├── ic_notification.png
│   │       │       │   ├── large_ad_button.xml
│   │       │       │   ├── launch_background.xml
│   │       │       │   ├── medium_ad_button.xml
│   │       │       │   ├── remove.png
│   │       │       │   └── small_ad_button.xml
│   │       │       ├── drawable-v21
│   │       │       │   └── launch_background.xml
│   │       │       ├── layout
│   │       │       │   ├── custom_extra_native_ad.xml
│   │       │       │   ├── custom_normal_native_ad.xml
│   │       │       │   ├── full_native_ad.xml
│   │       │       │   ├── home_native_ad.xml
│   │       │       │   └── small_native_ad.xml
│   │       │       ├── mipmap-hdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-mdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── values
│   │       │       │   ├── color.xml
│   │       │       │   └── styles.xml
│   │       │       └── values-night
│   │       │           └── styles.xml
│   │       ├── prod
│   │       │   ├── google-services.json
│   │       │   └── res
│   │       │       ├── mipmap-hdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-mdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       └── mipmap-xxxhdpi
│   │       │           └── ic_launcher.png
│   │       └── profile
│   │           └── AndroidManifest.xml
│   ├── build.gradle
│   ├── gradle
│   │   └── wrapper
│   │       ├── gradle-wrapper.jar
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   ├── key.properties
│   ├── local.properties
│   └── settings.gradle
├── assets
│   ├── icons
│   │   ├── bell.svg
│   │   ├── rates
│   │   │   ├── emotion1.png
│   │   │   ├── emotion2.png
│   │   │   ├── emotion3.png
│   │   │   ├── emotion4.png
│   │   │   ├── emotion5.png
│   │   │   ├── empty_star.svg
│   │   │   └── full_star.svg
│   │   └── update.svg
│   ├── images
│   │   ├── languages
│   │   │   ├── en.png
│   │   │   ├── es.png
│   │   │   ├── fr.png
│   │   │   ├── hi.png
│   │   │   └── pt.png
│   │   ├── logo
│   │   │   ├── logo.png
│   │   │   └── rounded_logo.png
│   │   ├── onboarding
│   │   │   ├── onboarding1.png
│   │   │   ├── onboarding2.png
│   │   │   └── onboarding3.png
│   │   ├── phone.png
│   │   ├── pink_heart.png
│   │   └── placeholder_image.png
│   ├── l10n
│   │   └── app_en.arb
│   └── lottie
│       ├── slide_left.json
│       └── tap.json
├── build.yaml
├── devtools_options.yaml
├── flavorizr.yaml
├── l10n.yaml
├── lib
│   ├── app_initializer.dart
│   ├── flavors.dart
│   ├── main.dart
│   ├── module
│   │   ├── adjust
│   │   │   ├── adjust.dart
│   │   │   ├── adjust_util.dart
│   │   │   └── model
│   │   │       ├── ad_option.dart
│   │   │       ├── adjust_event.dart
│   │   │       ├── adjust_options.dart
│   │   │       ├── adjust_token.dart
│   │   │       ├── fullads_option.dart
│   │   │       └── iap_option.dart
│   │   ├── admob
│   │   │   ├── model
│   │   │   │   ├── ad_config
│   │   │   │   │   ├── ad_config.dart
│   │   │   │   │   ├── ad_config.freezed.dart
│   │   │   │   │   └── ad_config.g.dart
│   │   │   │   └── native_all_config
│   │   │   │       ├── native_all_config.dart
│   │   │   │       ├── native_all_config.freezed.dart
│   │   │   │       └── native_all_config.g.dart
│   │   │   ├── utils
│   │   │   │   ├── enum
│   │   │   │   │   └── ad_factory.dart
│   │   │   │   ├── inter_ad_util.dart
│   │   │   │   ├── native_ad_util.dart
│   │   │   │   ├── native_all_util.dart
│   │   │   │   ├── native_full_util.dart
│   │   │   │   ├── reload_ad_util.dart
│   │   │   │   ├── reload_timer_util.dart
│   │   │   │   ├── reward_ad_util.dart
│   │   │   │   └── utils.dart
│   │   │   └── widget
│   │   │       ├── ads
│   │   │       │   ├── auto_reload_banner_ad.dart
│   │   │       │   ├── banner_ad.dart
│   │   │       │   ├── cached_native_ad.dart
│   │   │       │   ├── common_native_ad.dart
│   │   │       │   ├── full_native_ad.dart
│   │   │       │   └── native_all_ad.dart
│   │   │       └── loading
│   │   │           └── ad_loading.dart
│   │   ├── iap
│   │   │   ├── firebase_event_service.dart
│   │   │   ├── my_purchase_manager.dart
│   │   │   └── product_id.dart
│   │   ├── isolate
│   │   │   ├── isolate_controller.dart
│   │   │   └── isolate_handler.dart
│   │   ├── remote_config
│   │   │   ├── default_values
│   │   │   │   ├── dev_values.dart
│   │   │   │   └── prod_values.dart
│   │   │   └── remote_config.dart
│   │   └── tracking_screen
│   │       ├── loggable_widget.dart
│   │       └── screen_logger.dart
│   └── src
│       ├── config
│       │   ├── di
│       │   │   ├── di.config.dart
│       │   │   └── di.dart
│       │   ├── navigation
│       │   │   ├── app_router.dart
│       │   │   └── app_router.gr.dart
│       │   ├── observer
│       │   │   ├── bloc_observer.dart
│       │   │   └── route_observer.dart
│       │   └── theme
│       │       ├── dark
│       │       │   ├── component_theme
│       │       │   │   └── text_theme_dark.dart
│       │       │   └── dark_theme.dart
│       │       ├── light
│       │       │   ├── component_theme
│       │       │   │   ├── dialog_theme.dart
│       │       │   │   ├── filled_button_theme.dart
│       │       │   │   ├── icon_button_theme.dart
│       │       │   │   ├── outlined_button_theme.dart
│       │       │   │   ├── text_button_theme.dart
│       │       │   │   └── text_theme.dart
│       │       │   └── light_theme.dart
│       │       └── palette.dart
│       ├── data
│       │   ├── local
│       │   │   └── shared_preferences_manager.dart
│       │   └── models
│       │       ├── adjust_config.dart
│       │       ├── adjust_config.freezed.dart
│       │       ├── adjust_config.g.dart
│       │       ├── app_config_model.dart
│       │       ├── app_config_model.freezed.dart
│       │       └── app_config_model.g.dart
│       ├── gen
│       │   ├── assets.gen.dart
│       │   └── l18n
│       │       ├── app_localizations.dart
│       │       └── app_localizations_en.dart
│       ├── presentation
│       │   ├── app.dart
│       │   ├── home
│       │   │   ├── cubit
│       │   │   │   └── tab_cubit.dart
│       │   │   └── home_screen.dart
│       │   ├── language
│       │   │   ├── language_screen.dart
│       │   │   └── widget
│       │   │       ├── body.dart
│       │   │       └── item.dart
│       │   ├── onboarding
│       │   │   ├── onboarding_screen.dart
│       │   │   ├── utils
│       │   │   │   ├── intro_ad_util.dart
│       │   │   │   └── onboarding_controller.dart
│       │   │   └── widgets
│       │   │       ├── full_screen_native_ad.dart
│       │   │       ├── indicator.dart
│       │   │       ├── page_action.dart
│       │   │       └── page_widget.dart
│       │   ├── permission
│       │   │   ├── cubit
│       │   │   │   └── cubit.dart
│       │   │   ├── permission_screen.dart
│       │   │   └── widget
│       │   │       └── permission_body.dart
│       │   ├── setting
│       │   │   ├── setting_screen.dart
│       │   │   └── widgets
│       │   │       └── item_setting.dart
│       │   ├── splash
│       │   │   ├── splash_screen.dart
│       │   │   └── update_dialog.dart
│       │   └── uninstall
│       │       ├── uninstall_screen.dart
│       │       └── widget
│       │           ├── item_card.dart
│       │           ├── problem_page.dart
│       │           └── uninstall_page.dart
│       ├── service
│       │   └── notification_service.dart
│       └── shared
│           ├── constants
│           │   └── app_constants.dart
│           ├── cubit
│           │   ├── ad_visibility_cubit.dart
│           │   ├── language_cubit.dart
│           │   ├── rate_status_cubit.dart
│           │   ├── restorable_cubit.dart
│           │   └── value_cubit.dart
│           ├── enum
│           │   ├── intro_type.dart
│           │   └── language.dart
│           ├── extension
│           │   ├── context_extension.dart
│           │   ├── number_extension.dart
│           │   └── string_extension.dart
│           ├── global.dart
│           ├── helpers
│           │   ├── admob_consent_util.dart
│           │   ├── logger_utils.dart
│           │   ├── method_channel
│           │   │   ├── notification_channel.dart
│           │   │   └── permission_channel.dart
│           │   ├── my_completer.dart
│           │   ├── permission_util.dart
│           │   ├── shortcut_utils.dart
│           │   └── utils.dart
│           └── widgets
│               ├── button
│               │   └── custom_button.dart
│               ├── custom_appbar.dart
│               ├── custom_fade_in_image.dart
│               ├── custom_radio.dart
│               ├── custom_switch.dart
│               ├── dialog
│               │   ├── back_dialog.dart
│               │   ├── notification_permission_dialog.dart
│               │   ├── rate_dialog.dart
│               │   ├── rate_success_dialog.dart
│               │   └── rating_bar.dart
│               └── marquee_text.dart
├── missing_translations.txt
├── pubspec.lock
├── pubspec.yaml
├── run_config
│   ├── dev-fullads.run.xml
│   ├── dev-normal.run.xml
│   ├── prod-full-ads.run.xml
│   └── prod-normal.run.xml
└── scripts
├── build_aab.ps1
├── build_aab.sh
├── build_android.ps1
└── build_android.sh