import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdmobService {
  static AdmobService _admobService;

  AdmobService._internal();

  static AdmobService getInstance() {
    if (_admobService == null) {
      _admobService = AdmobService._internal();
    }
    return _admobService;
  }

  static BannerAd loginBannerAd,
      signUpBannerAd,
      otpVerificationBannerAd,
      phoneRegisterBannerAd,
      resetPasswordBannerAd,
      createTournamentBannerAd,
      homeBannerAd,
      profileBannerAd,
      scheduleTournamentBannerAd;

  String getAdmobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9325743141236395~5636228036';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9325743141236395~1699415664';
    }
    return null;
  }

  static String _getBannerAdId() {
    if (Platform.isIOS) {
      return BannerAd.testAdUnitId;
    } else if (Platform.isAndroid) {
      return BannerAd.testAdUnitId;
    }
    return null;
  }

  static BannerAd _getLoginBannerAd() {
    if (loginBannerAd == null) {
      loginBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return loginBannerAd;
  }

  static BannerAd _getOtpVerificationBannerAd() {
    if (otpVerificationBannerAd == null) {
      otpVerificationBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return otpVerificationBannerAd;
  }

  static BannerAd _getPhoneRegisterBannerAd() {
    if (phoneRegisterBannerAd == null) {
      phoneRegisterBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return phoneRegisterBannerAd;
  }

  static BannerAd _getRegisterBannerAd() {
    if (signUpBannerAd == null) {
      signUpBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return signUpBannerAd;
  }

  static BannerAd _getResetPasswordBannerAd() {
    if (resetPasswordBannerAd == null) {
      resetPasswordBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return resetPasswordBannerAd;
  }

  static BannerAd _getCreateTournamentBannerAd() {
    if (createTournamentBannerAd == null) {
      createTournamentBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return createTournamentBannerAd;
  }

  static BannerAd _getHomeBannerAd() {
    if (homeBannerAd == null) {
      homeBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return homeBannerAd;
  }

  static BannerAd _getProfileBannerAd() {
    if (profileBannerAd == null) {
      profileBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return profileBannerAd;
  }

  static BannerAd _getScheduleTournamentBannerAd() {
    if (scheduleTournamentBannerAd == null) {
      scheduleTournamentBannerAd =
          new BannerAd(adUnitId: _getBannerAdId(), size: AdSize.banner);
    }
    return scheduleTournamentBannerAd;
  }

  void showHomeBannerAd() {
    homeBannerAd = _getHomeBannerAd();
    homeBannerAd
      ..load()
      ..show(
        anchorOffset: 60.0,
      );
  }

  void hideHomeBannerAd() async {
    if (homeBannerAd != null) {
      await homeBannerAd.dispose();
    }
    homeBannerAd = null;
  }

  void showLoginBannerAd() {
    loginBannerAd = _getLoginBannerAd();
    loginBannerAd
      ..load()
      ..show();
  }

  void hideLoginBannerAd() async {
    if (loginBannerAd != null) {
      await loginBannerAd.dispose();
    }
    loginBannerAd = null;
  }

  void showRegisterBannerAd() {
    signUpBannerAd = _getRegisterBannerAd();
    signUpBannerAd
      ..load()
      ..show();
  }

  void hideRegisterBannerAd() async {
    if (signUpBannerAd != null) {
      await signUpBannerAd.dispose();
    }
    signUpBannerAd = null;
  }

  void showOtpVerificationBannerAd() {
      otpVerificationBannerAd = _getOtpVerificationBannerAd();
    otpVerificationBannerAd
      ..load()
      ..show();
  }

  void hideOtpVerificationBannerAd() async {
    if (otpVerificationBannerAd != null) {
      await otpVerificationBannerAd.dispose();
    }
    otpVerificationBannerAd = null;
  }

  void showPhoneRegisterAd() {
    phoneRegisterBannerAd = _getPhoneRegisterBannerAd();
    phoneRegisterBannerAd
      ..load()
      ..show();
  }

  void hidePhoneRegisterBannerAd() async {
    if (phoneRegisterBannerAd != null) {
      await phoneRegisterBannerAd.dispose();
    }
    phoneRegisterBannerAd = null;
  }

  void showResetPasswordBannerAd() {
    resetPasswordBannerAd = _getResetPasswordBannerAd();
    resetPasswordBannerAd
      ..load()
      ..show();
  }

  void hideResetPasswordBannerAd() async {
    if (resetPasswordBannerAd != null) {
      await resetPasswordBannerAd.dispose();
    }
    resetPasswordBannerAd = null;
  }

  void showCreateTournamentBannerAd() {
      createTournamentBannerAd = _getCreateTournamentBannerAd();
    createTournamentBannerAd
      ..load()
      ..show();
  }

  void hideCreateTournamentBannerAd() async {
    if (createTournamentBannerAd != null) {
      await createTournamentBannerAd.dispose();
    }
    createTournamentBannerAd = null;
  }

  void showProfileBannerAd() {
    profileBannerAd = _getProfileBannerAd();
    profileBannerAd
      ..load()
      ..show(
        anchorOffset: 60.0,
      );
  }

  void hideProfileBannerAd() async {
    if (profileBannerAd != null) {
      await profileBannerAd.dispose();
    }
    profileBannerAd = null;
  }

  void showScheduleTournamentBannerAd() {
    scheduleTournamentBannerAd = _getScheduleTournamentBannerAd();
    scheduleTournamentBannerAd
      ..load()
      ..show(
        anchorOffset: 150.0,
      );
  }

  void hideScheduleTournamentBannerAd() async {
    if (scheduleTournamentBannerAd != null) {
      await scheduleTournamentBannerAd.dispose();
    }
    scheduleTournamentBannerAd = null;
  }
}
