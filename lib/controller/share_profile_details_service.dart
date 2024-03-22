import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen.dart';
import 'package:talkangels/ui/angels/main/home_pages/person_details_screen.dart';
import 'package:talkangels/ui/startup/login_screen.dart';

class DynamicLinkService {
  final firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  final androidParameters = const AndroidParameters(
    packageName: "com.talkangels.talkangels",
  );
  final iosParameters = const IOSParameters(
    bundleId: "",
    appStoreId: "",
  );

  final uriPrefix = "https://talkangels.page.link";
  Future<String> createShareProfileLink({required String? angelId}) async {
    const socialMetaTagParameters = SocialMetaTagParameters(
      title: "",
      description: "",
    );
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("$uriPrefix/shareProfile?angelId=$angelId"),
      uriPrefix: uriPrefix,
      androidParameters: androidParameters,
      iosParameters: iosParameters,
      socialMetaTagParameters: socialMetaTagParameters,
    );

    final dynamicLink = await firebaseDynamicLinks.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    log("DYNAMIC_LINKS_PROFILE=====>>>>   ${dynamicLink.shortUrl.toString()}");
    return dynamicLink.shortUrl.toString();
  }

  /// App Link
  Future<String> createShareAppLink({required String? referCode}) async {
    const socialMetaTagParameters = SocialMetaTagParameters(
      title: "",
      description: "",
    );
    final dynamicShareAppLinkParams = DynamicLinkParameters(
      link: Uri.parse("$uriPrefix/refer?referCode=$referCode"),
      uriPrefix: uriPrefix,
      androidParameters: androidParameters,
      iosParameters: iosParameters,
      socialMetaTagParameters: socialMetaTagParameters,
    );

    final dynamicShareAppLink = await firebaseDynamicLinks.buildShortLink(
      dynamicShareAppLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    // shortLink = dynamicLink.shortUrl.toString();
    log("DYNAMIC_LINKS_REFER=====>>>>   ${dynamicShareAppLink.shortUrl.toString()}");
    return dynamicShareAppLink.shortUrl.toString();
  }

  Future handleDynamicLinks() async {
    final data = await firebaseDynamicLinks.getInitialLink();
    _handleDeepLink(data);

    firebaseDynamicLinks.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData);
    });
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      debugPrint('_handleDeepLink | deeplink: $deepLink');
      log("DEEPLINK===>>>   $deepLink");

      /// Profile Details
      var isProfile = deepLink.pathSegments.contains('shareProfile');

      if (isProfile) {
        var angelIdStr = deepLink.queryParameters['angelId'];

        String? angelIds = (angelIdStr?.isNotEmpty ?? false) ? angelIdStr : null;

        log("angelIds=====$angelIds");
        if (angelIds != null) {
          if (PreferenceManager().getLogin() == true) {
            if (PreferenceManager().getRole() == "user") {
              Get.offAll(() => const HomeScreen());

              Future.delayed(const Duration(seconds: 2), () async {
                Get.to(
                  () => const PersonDetailScreen(),
                  arguments: {
                    "angel_id": angelIds,
                  },
                );
              });
            } else {
              showAppSnackBar("You Have Not Show This Profile");
              Get.offAllNamed(Routes.bottomBarScreen);
            }
          } else {
            Get.offAll(() => const LoginScreen());
          }
        }
      }

      /// App Link
      var isRefer = deepLink.pathSegments.contains('refer');

      if (isRefer) {
        var referStr = deepLink.queryParameters['referCode'];

        String? referCode = (referStr?.isNotEmpty ?? false) ? referStr : null;
        log("referCode===$referCode");
        if (referCode != null) {
          if (PreferenceManager().getLogin() == true) {
            if (PreferenceManager().getRole() == "user") {
              showAppSnackBar("You Have Already Registered!");
              Get.offAllNamed(Routes.homeScreen);
            } else {
              showAppSnackBar("You Have Already Registered!");
              Get.offAllNamed(Routes.bottomBarScreen);
            }
          } else {
            Get.offAll(
              () => const LoginScreen(),
              arguments: {
                "refer_code": referCode,
              },
            );
            log("LOGIN====>>>   $referCode");
          }
        }
      }
    }
  }

  Uri urlWithQueryParams({
    required String url,
    Map<String, dynamic>? params,
  }) {
    if (params?.isNotEmpty ?? false) {
      var queryString = Uri(
        queryParameters: params!.map(
          (key, value) => MapEntry(key, "$value"),
        ),
      ).query;

      return Uri.parse("$url?$queryString");
    }
    return Uri.parse(url);
  }
}
