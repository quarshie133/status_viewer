import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_viewer/src/widgets/common_widgets.dart';

class AdManager {
  Future<InitializationStatus> initialization;

  AdManager(this.initialization);

  String getBannerAdUnitIdPhoto() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4395920285910847/2012752769';
    }
    return 'ca-app-pub-4395920285910847/2012752769';
  }

  String getInlineBannerAdUnitIdPhoto() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4395920285910847/7811874353';
    }
    return 'ca-app-pub-4395920285910847/7811874353';
  }

  String getInterstitialAdUnitIdPhoto() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  String getInterstitialAdUnitIdVideo() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4395920285910847/5745497103';
    }
    return 'ca-app-pub-4395920285910847/5745497103';
  }

  String getBannerAdUnitIdVideo() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4395920285910847/3529582634';
    }
    return 'ca-app-pub-4395920285910847/3529582634';
  }

  static String? getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return '';
    }
    return null;
  }

  static String? getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return '';
    }
    return null;
  }
}
