import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/AppTheme.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/Tournament.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:intl/intl.dart';
import 'package:tournament_app/services/admob_service.dart';
import 'package:tournament_app/screens/home/createTournament.dart';

class ScheduleTournament extends StatefulWidget {
  final EndUser endUser;

  ScheduleTournament({Key key, @required this.endUser});

  @override
  _ScheduleTournamentState createState() => _ScheduleTournamentState(endUser);
}

class _ScheduleTournamentState extends State<ScheduleTournament> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  EndUser endUser;
  DateTime now = new DateTime.now();

  int selectedDate = 1;

  List<Tournament> listOfTournaments = new List();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('tournaments');
  double height, width;
  List<List<Tournament>> list = new List();
  List<Tournament> listZero = new List();
  List<Tournament> listOne = new List();
  List<Tournament> listTwo = new List();
  List<Tournament> listThree = new List();
  List<Tournament> listFour = new List();
  final admobService = AdmobService.getInstance();

  _ScheduleTournamentState(this.endUser);

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                floatingActionButton:
                    (endUser.role.toString().toLowerCase() == 'organizer')
                        ? FloatingActionButton(
                            onPressed: () {
                              admobService.hideScheduleTournamentBannerAd();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateTournament(
                                            endUser: endUser,
                                          )));
                            },
                            backgroundColor: themeData.colorScheme.primary,
                            child: Icon(
                              MdiIcons.plus,
                              color: themeData.colorScheme.onPrimary,
                            ),
                          )
                        : null,
                body: Container(
                  color: customAppTheme.bgLayer1,
                  child: ListView(
                    padding: Spacing.top(48),
                    children: [
                      Container(
                        margin: Spacing.fromLTRB(24, 0, 24, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText2,
                                      letterSpacing: 0,
                                      color: themeData.colorScheme.onBackground,
                                      fontWeight: 500),
                                ),
                                Text(
                                  now.day.toString() +
                                      " " +
                                      DateFormat('EEEE').format(now),
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText1,
                                      color: themeData.colorScheme.onBackground,
                                      fontWeight: 600),
                                ),
                              ],
                            ),
                            Container(
                              child: Icon(
                                MdiIcons.calendarOutline,
                                size: MySize.size22,
                                color: themeData.colorScheme.onBackground,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: Spacing.top(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            singleDateWidget(
                                date:
                                    "${now.subtract(Duration(days: 1)).day}\n${DateFormat('EEEE').format(now.subtract(Duration(days: 1))).substring(0, 3)}",
                                index: 0),
                            singleDateWidget(
                                date:
                                    "${now.day}\n${DateFormat('EEEE').format(now).substring(0, 3)}",
                                index: 1),
                            singleDateWidget(
                                date:
                                    "${now.add(Duration(days: 1)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 1))).substring(0, 3)}",
                                index: 2),
                            singleDateWidget(
                                date:
                                    "${now.add(Duration(days: 2)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 2))).substring(0, 3)}",
                                index: 3),
                            singleDateWidget(
                                date:
                                    "${now.add(Duration(days: 3)).day}\n${DateFormat('EEEE').format(now.add(Duration(days: 3))).substring(0, 3)}",
                                index: 4),
                          ],
                        ),
                      ),
                      Container(
                        margin: Spacing.fromLTRB(24, 24, 24, 0),
                        child: Text(
                          "Tournaments You Can Join",
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle1,
                              color: themeData.colorScheme.onBackground,
                              muted: true,
                              fontWeight: 600),
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
                              listZero.clear();
                              listOne.clear();
                              listTwo.clear();
                              listThree.clear();
                              listFour.clear();
                              snapshot.data.docs.forEach((element) {
                                Tournament tournament =
                                    new Tournament.fromJson(element.data());
                                bool flag = false;
                                tournament.playersList.forEach((element) {
                                  if (element.id ==
                                      FirebaseAuth.instance.currentUser.uid) {
                                    flag = true;
                                  }
                                });
                                if (flag == false) {
                                  if (DateTime.parse(tournament.date).day ==
                                      now.subtract(Duration(days: 1)).day) {
                                    listZero.add(tournament);
                                  } else if (DateTime.parse(tournament.date)
                                          .day ==
                                      now.day) {
                                    listOne.add(tournament);
                                  } else if (DateTime.parse(tournament.date)
                                          .day ==
                                      now.add(Duration(days: 1)).day) {
                                    listTwo.add(tournament);
                                  } else if (DateTime.parse(tournament.date)
                                          .day ==
                                      now.add(Duration(days: 2)).day) {
                                    listThree.add(tournament);
                                  } else if (DateTime.parse(tournament.date)
                                          .day ==
                                      now.add(Duration(days: 3)).day) {
                                    listFour.add(tournament);
                                  }
                                }
                              });
                            }
                            switch (selectedDate) {
                              case 0:
                                return (listZero.isNotEmpty)
                                    ? Container(
                                        height: height * 0.7,
                                        margin: Spacing.fromLTRB(24, 24, 24, 0),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: listZero.length,
                                            itemBuilder:
                                                (BuildContext context, int i) =>
                                                    Card(
                                                      margin: Spacing.top(24),
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            await showTournamentDetailsDialog(
                                                                listZero[i]);
                                                            setState(() {});
                                                          },
                                                          child: singleActivityWidget(
                                                              time: listZero[i]
                                                                  .time,
                                                              iconData:
                                                                  'assets/images/tennis.png',
                                                              title: listZero[i]
                                                                  .name,
                                                              description:
                                                                  listZero[i]
                                                                      .typeOfCourts)),
                                                    )),
                                      )
                                    : Container(
                                        height: height * 0.5,
                                        child: Center(
                                            child: Text("No tournament found")),
                                      );
                                break;
                              case 1:
                                return (listOne.isNotEmpty)
                                    ? Container(
                                        height: height * 0.7,
                                        margin: Spacing.fromLTRB(24, 24, 24, 0),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: listOne.length,
                                            itemBuilder: (BuildContext context,
                                                    int i) =>
                                                Card(
                                                  margin: Spacing.top(24),
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        await showTournamentDetailsDialog(
                                                            listOne[i]);
                                                        setState(() {});
                                                      },
                                                      child: singleActivityWidget(
                                                          time: listOne[i].time,
                                                          iconData:
                                                              'assets/images/tennis.png',
                                                          title:
                                                              listOne[i].name,
                                                          description: listOne[
                                                                  i]
                                                              .typeOfCourts)),
                                                )),
                                      )
                                    : Container(
                                        height: height * 0.5,
                                        child: Center(
                                            child: Text("No tournament found")),
                                      );
                                break;
                              case 2:
                                return (listTwo.isNotEmpty)
                                    ? Container(
                                        height: height * 0.7,
                                        margin: Spacing.fromLTRB(24, 24, 24, 0),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: listTwo.length,
                                            itemBuilder: (BuildContext context,
                                                    int i) =>
                                                Card(
                                                  margin: Spacing.top(24),
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        await showTournamentDetailsDialog(
                                                            listTwo[i]);
                                                        setState(() {});
                                                      },
                                                      child: singleActivityWidget(
                                                          time: listTwo[i].time,
                                                          iconData:
                                                              'assets/images/tennis.png',
                                                          title:
                                                              listTwo[i].name,
                                                          description: listTwo[
                                                                  i]
                                                              .typeOfCourts)),
                                                )),
                                      )
                                    : Container(
                                        height: height * 0.5,
                                        child: Center(
                                            child: Text("No tournament found")),
                                      );
                                break;
                              case 3:
                                return (listThree.isNotEmpty)
                                    ? Container(
                                        height: height * 0.7,
                                        margin: Spacing.fromLTRB(24, 24, 24, 0),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: listThree.length,
                                            itemBuilder:
                                                (BuildContext context, int i) =>
                                                    Card(
                                                      margin: Spacing.top(24),
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            await showTournamentDetailsDialog(
                                                                listThree[i]);
                                                            setState(() {});
                                                          },
                                                          child: singleActivityWidget(
                                                              time: listThree[i]
                                                                  .time,
                                                              iconData:
                                                                  'assets/images/tennis.png',
                                                              title:
                                                                  listThree[i]
                                                                      .name,
                                                              description:
                                                                  listThree[i]
                                                                      .typeOfCourts)),
                                                    )),
                                      )
                                    : Container(
                                        height: height * 0.5,
                                        child: Center(
                                            child: Text("No tournament found")),
                                      );
                                break;
                              case 4:
                                return (listFour.isNotEmpty)
                                    ? Container(
                                        height: height * 0.7,
                                        margin: Spacing.fromLTRB(24, 24, 24, 0),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: listFour.length,
                                            itemBuilder:
                                                (BuildContext context, int i) =>
                                                    Card(
                                                      margin: Spacing.top(24),
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            await showTournamentDetailsDialog(
                                                                listFour[i]);
                                                            setState(() {});
                                                          },
                                                          child: singleActivityWidget(
                                                              time: listFour[i]
                                                                  .time,
                                                              iconData:
                                                                  'assets/images/tennis.png',
                                                              title: listFour[i]
                                                                  .name,
                                                              description:
                                                                  listFour[i]
                                                                      .typeOfCourts)),
                                                    )),
                                      )
                                    : Container(
                                        height: height * 0.5,
                                        child: Center(
                                            child: Text("No tournament found")),
                                      );
                                break;
                            }
                            return Container(
                              width: 0,
                              height: 0,
                            );
                          })
                    ],
                  ),
                )));
      },
    );
  }

  Widget singleDateWidget({String date, @required int index}) {
    if (selectedDate == index) {
      return InkWell(
        onTap: () {
          setState(() {
            selectedDate = index;
          });
        },
        child: Container(
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size6)),
            color: themeData.colorScheme.primary,
          ),
          padding: Spacing.fromLTRB(0, 8, 0, 14),
          child: Column(
            children: [
              Text(
                date,
                style: AppTheme.getTextStyle(themeData.textTheme.caption,
                    fontWeight: 600,
                    color: themeData.colorScheme.onPrimary,
                    height: 1.9),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: Spacing.top(12),
                height: MySize.size8,
                width: MySize.size8,
                decoration: BoxDecoration(
                    color: themeData.colorScheme.onPrimary,
                    shape: BoxShape.circle),
              )
            ],
          ),
        ),
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          selectedDate = index;
          listZero.clear();
          listOne.clear();
          listTwo.clear();
          listThree.clear();
          listFour.clear();
        });
      },
      child: Container(
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size6)),
            color: customAppTheme.bgLayer1,
            boxShadow: [
              BoxShadow(
                color: customAppTheme.shadowColor,
                blurRadius: MySize.size10,
                spreadRadius: MySize.size2,
                offset: Offset(0, MySize.size8),
              )
            ]),
        padding: Spacing.fromLTRB(0, 8, 0, 14),
        child: Column(
          children: [
            Text(
              date,
              style: AppTheme.getTextStyle(themeData.textTheme.caption,
                  fontWeight: 600,
                  color: themeData.colorScheme.onBackground,
                  height: 1.9),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget singleActivityWidget(
      {String time, String iconData, String title, String description}) {
    return Container(
      child: Row(
        children: [
          Container(
              width: MySize.size72,
              child: Text(
                time,
                style: AppTheme.getTextStyle(
                  themeData.textTheme.caption,
                  muted: true,
                  letterSpacing: 0,
                ),
              )),
          Expanded(
            child: Container(
              padding: Spacing.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
                  color: customAppTheme.bgLayer1,
                  boxShadow: [
                    BoxShadow(
                        color: customAppTheme.shadowColor,
                        blurRadius: MySize.size8,
                        offset: Offset(0, MySize.size8))
                  ]),
              child: Row(
                children: [
                  Container(
                    padding: Spacing.all(8),
                    child: Image(
                      width: MySize.size72,
                      height: MySize.size72,
                      image: AssetImage('$iconData'),
                    ),
                  ),
                  Container(
                    margin: Spacing.left(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 600),
                        ),
                        Text(
                          description,
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.caption,
                              fontSize: 12,
                              color: themeData.colorScheme.onBackground,
                              fontWeight: 500,
                              muted: true),
                        ),
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
                    child: Text("Enroll"),
                    onPressed: () {
                      tournament.playersList.add(new Player(
                          id: FirebaseAuth.instance.currentUser.uid,
                          picture: endUser.picture,
                          name: endUser.name));
                      collectionReference
                          .doc(tournament.documentId)
                          .set(tournament.toJson())
                          .then((value) => print("Person Added"))
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
                                      backgroundImage: (list[i].picture != null)
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
