import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/AppTheme.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/screens/home/home.dart';
import 'package:tournament_app/screens/home/scheduleTournament.dart';
import 'package:tournament_app/services/admob_service.dart';
import 'profile.dart';

class TournamentFullApp extends StatefulWidget {
  final EndUser endUser;

  TournamentFullApp({Key key,@required this.endUser});

  @override
  _TournamentFullAppState createState() => _TournamentFullAppState(endUser);
}

class _TournamentFullAppState extends State<TournamentFullApp>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  EndUser endUser;
  CustomAppTheme customAppTheme;

  TabController _tabController;

  final admobService = AdmobService.getInstance();

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }


  _TournamentFullAppState(this.endUser);

  @override
  void initState() {
    admobService.showScheduleTournamentBannerAd();
    admobService.hideHomeBannerAd();
    admobService.hideLoginBannerAd();
    admobService.hideOtpVerificationBannerAd();
    admobService.hideProfileBannerAd();
    admobService.hideCreateTournamentBannerAd();
    admobService.hideResetPasswordBannerAd();
    admobService.hideRegisterBannerAd();
    admobService.hidePhoneRegisterBannerAd();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    _tabController.animation.addListener(() {
      final aniValue = _tabController.animation.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
    super.initState();
  }

  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  dispose() {
    admobService.hideScheduleTournamentBannerAd();
    _tabController.dispose();
    super.dispose();
  }

  ThemeData themeData;

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        customAppTheme  = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
          home: Scaffold(
            bottomNavigationBar: BottomAppBar(
                elevation: 0,
                shape: CircularNotchedRectangle(),
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.bottomAppBarTheme.color,
                    boxShadow: [
                      BoxShadow(
                        color: customAppTheme.shadowColor,
                        blurRadius: 3,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: themeData.colorScheme.primary,
                    tabs: <Widget>[
                      Container(
                        child: (_currentIndex == 0)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.home,
                                    color: themeData.colorScheme.primary,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                        color: themeData.primaryColor,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(2.5))),
                                    height: 5,
                                    width: 5,
                                  )
                                ],
                              )
                            : Icon(
                                MdiIcons.homeOutline,
                                color: themeData.colorScheme.onBackground,
                              ),
                      ),
                      Container(
                          child: (_currentIndex == 1)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      MdiIcons.calendar,
                                      color: themeData.colorScheme.primary,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                          color: themeData.primaryColor,
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(2.5))),
                                      height: 5,
                                      width: 5,
                                    )
                                  ],
                                )
                              : Icon(
                                  MdiIcons.calendarOutline,
                                  color: themeData.colorScheme.onBackground,
                                )),
                      Container(
                          child: (_currentIndex == 2)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      MdiIcons.account,
                                      color: themeData.colorScheme.primary,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                          color: themeData.primaryColor,
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(2.5))),
                                      height: 5,
                                      width: 5,
                                    )
                                  ],
                                )
                              : Icon(
                                  MdiIcons.accountOutline,
                                  color: themeData.colorScheme.onBackground,
                                )),
                    ],
                  ),
                )),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Home(endUser: endUser,),
                ScheduleTournament(endUser: endUser,),
                Profile(endUser: endUser,),
              ],
            ),
          ),
        );
      },
    );
  }
}
