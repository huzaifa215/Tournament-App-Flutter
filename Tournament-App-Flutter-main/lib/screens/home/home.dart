import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/AppTheme.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/screens/home/createTournament.dart';
import 'package:tournament_app/screens/auth/Login.dart';
import 'package:tournament_app/services/admob_service.dart';
import 'package:tournament_app/utils/SizeConfig.dart';

class Home extends StatefulWidget {
  final EndUser endUser;

  Home({Key key, @required this.endUser});

  @override
  _HomeState createState() => _HomeState(endUser);
}

class _HomeState extends State<Home> {
  User user = FirebaseAuth.instance.currentUser;
  EndUser endUser;
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  final admobService = AdmobService.getInstance();
  _HomeState(this.endUser);

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                body: Container(
              color: customAppTheme.bgLayer1,
              child: ListView(
                padding: Spacing.top(48),
                children: [
                  Container(
                    margin: Spacing.fromLTRB(24, 0, 24, 0),
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(MySize.size8)),
                      child: Image(
                        image: (endUser.picture != null)
                            ? NetworkImage(endUser.picture)
                            : AssetImage("assets/images/user.png"),
                        width: MySize.size44,
                        height: MySize.size44,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: Spacing.fromLTRB(24, 16, 0, 0),
                    child: Text(
                      "Hello",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.subtitle1,
                          xMuted: true,
                          color: themeData.colorScheme.onBackground),
                    ),
                  ),
                  Container(
                    margin: Spacing.left(24),
                    child: Text(
                      "${endUser.name}",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline4,
                          letterSpacing: -0.5,
                          color: themeData.colorScheme.onBackground,
                          fontWeight: 700),
                    ),
                  ),
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: RaisedButton(
                          child: Text("Logout"),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              admobService.hideScheduleTournamentBannerAd();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (context) => Login()), (route) => false);
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                        )),
                  ),
                ],
              ),
            )));
      },
    );
  }

  Widget singleHelpWidget({IconData iconData, String title, Color color}) {
    return Container(
      width: (MySize.safeWidth - MySize.getScaledSizeWidth(96)) / 3,
      padding: Spacing.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(
          color: customAppTheme.bgLayer1,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
          boxShadow: [
            BoxShadow(
                color: customAppTheme.shadowColor,
                blurRadius: MySize.size6,
                offset: Offset(0, MySize.size4))
          ]),
      child: Column(
        children: [
          Icon(
            iconData,
            color: color == null ? themeData.colorScheme.primary : color,
            size: MySize.size30,
          ),
          Container(
            margin: Spacing.top(8),
            child: Text(
              title,
              style: AppTheme.getTextStyle(themeData.textTheme.caption,
                  letterSpacing: 0,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 600),
            ),
          )
        ],
      ),
    );
  }
}
