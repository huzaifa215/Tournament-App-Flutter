import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/AppTheme.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/model/Tournament.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tournament_app/services/admob_service.dart';

class Profile extends StatefulWidget {
  final EndUser endUser;

  Profile({Key key, @required this.endUser});

  @override
  _ProfileState createState() => _ProfileState(endUser);
}

class _ProfileState extends State<Profile> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  User user = FirebaseAuth.instance.currentUser;
  EndUser endUser;

  int selectedDate = 1;
  DateTime birthDateTime;
  DateTime dateTime;
  int age = 0;
  String country = "";

  _ProfileState(this.endUser);

  List<Tournament> listOfTournaments = new List();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('tournaments');
  double height, width;
  @override
  void initState() {
    super.initState();
    if (endUser.birthday != null) {
      birthDateTime = new DateFormat("MM/dd/yyyy").parse(endUser.birthday);
      dateTime = DateTime.now();
      age = dateTime.year - birthDateTime.year;
      if (dateTime.month < birthDateTime.month) {
        --age;
      }
    }
    if (endUser.country != null) {
      country = endUser.country.substring(endUser.country.indexOf(',') + 1);
    }
  }


  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
                    padding: Spacing.vertical(24),
                    margin: Spacing.fromLTRB(24, 16, 24, 0),
                    decoration: BoxDecoration(
                      color: customAppTheme.bgLayer1,
                      borderRadius:
                          BorderRadius.all(Radius.circular(MySize.size8)),
                      border: Border.all(
                          color: customAppTheme.bgLayer4, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(MySize.size32)),
                          child: Image(
                            image: (endUser.picture != null)
                                ? NetworkImage(endUser.picture)
                                : AssetImage("assets/images/user.png"),
                            height: MySize.size64,
                            width: MySize.size64,
                          ),
                        ),
                        Container(
                          margin: Spacing.top(16),
                          child: Text(
                            endUser.name,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                fontWeight: 600,
                                letterSpacing: 0),
                          ),
                        ),
                        (age != 0)
                            ? Container(
                                margin: Spacing.top(8),
                                child: Text(
                                  "$age years $country",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText2,
                                      fontWeight: 500,
                                      muted: true,
                                      letterSpacing: 0),
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                        Container(
                          margin: Spacing.top(24),
                          child: Row(
                            children: [
                              (endUser.birthday != null)
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "DOB",
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.caption,
                                                color: themeData
                                                    .colorScheme.primary,
                                                muted: true),
                                          ),
                                          Container(
                                            child: RichText(
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text: endUser.birthday,
                                                    style:
                                                        AppTheme.getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            color: themeData
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight: 600)),
                                              ]),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Date Of Registration",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          color: themeData.colorScheme.primary,
                                          muted: true),
                                    ),
                                    Container(
                                      child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: DateFormat('d-MM-yyyy')
                                                  .format(user
                                                      .metadata.creationTime
                                                      .toLocal()),
                                              style: AppTheme.getTextStyle(
                                                  themeData.textTheme.bodyText1,
                                                  color: themeData
                                                      .colorScheme.onBackground,
                                                  fontWeight: 600)),
                                        ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: Spacing.fromLTRB(24, 36, 24, 0),
                    child: Text(
                      "Tournaments".toUpperCase(),
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.caption,
                        fontSize: 11.8,
                        fontWeight: 600,
                        xMuted: true,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: collectionReference.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          listOfTournaments.clear();
                          snapshot.data.docs.forEach((element) {
                            Tournament tournament =
                                new Tournament.fromJson(element.data());
                            if (tournament.playersList.isNotEmpty) {
                              bool flag = false;
                              tournament.playersList.forEach((element) {
                                if (element.id ==
                                    FirebaseAuth.instance.currentUser.uid) {
                                  flag = true;
                                }
                              });
                              if (flag == true) {
                                listOfTournaments.add(tournament);
                              }
                            }
                          });
                        }

                        return (listOfTournaments.isNotEmpty)
                            ? Container(
                                height: height * 0.5,
                                margin: Spacing.fromLTRB(24, 16, 24, 0),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: listOfTournaments.length,
                                  itemBuilder: (BuildContext context, int i) =>
                                      Card(
                                    margin: Spacing.top(24),
                                    child: GestureDetector(
                                        onTap: () async {
                                          await showTournamentDetailsDialog(
                                              listOfTournaments[i]);
                                          setState(() {});
                                        },
                                        child: tournamentWidget(
                                            type: listOfTournaments[i]
                                                .typeOfCourts,
                                            time: listOfTournaments[i].date,
                                            docName: listOfTournaments[i].name,
                                            image: "assets/images/tennis.png",
                                            clockColor:
                                                customAppTheme.colorSuccess)),
                                  ),
                                ),
                              )
                            : Container(
                          height: height*0.5,
                                child: Center(
                                    child: Text("No tournaments enrolled")));
                      })
                ],
              ),
            )));
      },
    );
  }

  Widget tournamentWidget(
      {String image,
      String docName,
      String type,
      String time,
      Color clockColor}) {
    return Container(
      padding: Spacing.fromLTRB(4, 4, 8, 4),
      decoration: BoxDecoration(
          color: customAppTheme.bgLayer1,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size12)),
          boxShadow: [
            BoxShadow(
                color: customAppTheme.shadowColor,
                blurRadius: MySize.size6,
                offset: Offset(0, MySize.size4))
          ]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size12)),
            child: Image(
              image: AssetImage(image),
              width: MySize.size72,
              height: MySize.size72,
            ),
          ),
          Expanded(
            child: Container(
              height: MySize.size72,
              margin: Spacing.left(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    docName,
                    style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600),
                  ),
                  Text(
                    type,
                    style: AppTheme.getTextStyle(themeData.textTheme.caption,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 500,
                        xMuted: true),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          MdiIcons.clock,
                          size: MySize.size16,
                          color: clockColor,
                        ),
                        Container(
                          margin: Spacing.left(4),
                          child: Text(
                            time,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.caption,
                                muted: true,
                                fontWeight: 600,
                                color: themeData.colorScheme.onBackground),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Function to show tournament details each time a tournament is clicked
  Future<void> showTournamentDetailsDialog(Tournament tournament) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        tournament.playersList.removeWhere((element) => element.id==FirebaseAuth.instance.currentUser.uid);
        return AlertDialog(
          title: Center(child: Text(tournament.name)),
          content: Container(
            width: width,
            height: height * 0.5,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text(tournament.date)),
                  RaisedButton(
                    child: Text("Delist"),
                    onPressed: () {
                      collectionReference
                          .doc(tournament.documentId)
                          .set(tournament.toJson())
                          .then((value) => print("Tournament Created"))
                          .catchError((error) => print("error $error"));
                      showToast("Success");
                      Navigator.pop(context);
                    },
                  ),
                  personsCard(tournament.playersList),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Function to show toast messages
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //Function on how to show a person list
  Widget personsCard(List<Player> list) {
    return (list.length > 0)
        ? Container(
            width: width,
            height: height * 0.4,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) => Container(
                  margin: EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                      (list[i].picture != null)
                                          ? NetworkImage(list[i].picture)
                                          : AssetImage(
                                          "assets/images/user.png"),
                                      radius: height * 0.04,
                                    )
                                  ],
                                ),
                                Container(
                                    width: width*0.3,
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[i].name,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                )),
                              ]),
                        ],
                      ),
                    )))
        : Container(
            height: height * 0.1,
            child: Center(child: Text("No person found")),
          );
  }
}
