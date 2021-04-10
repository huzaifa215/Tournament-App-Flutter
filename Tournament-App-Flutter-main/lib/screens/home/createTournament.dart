import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/AppTheme.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:tournament_app/model/Tournament.dart';
import 'package:intl/intl.dart';
import 'package:tournament_app/services/admob_service.dart';

class CreateTournament extends StatefulWidget {
  final EndUser endUser;

  CreateTournament({Key key, @required this.endUser});

  @override
  _CreateTournamentState createState() => _CreateTournamentState(endUser);
}

class _CreateTournamentState extends State<CreateTournament> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  EndUser endUser;
  double width, height;
  TextEditingController nameController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController scoringController = new TextEditingController();
  TextEditingController numberOfCourtsController = new TextEditingController();
  TextEditingController typeOfCourtsController = new TextEditingController();
  TextEditingController numberOfPlayersController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  bool emptyName = false,
      emptyPlace = false,
      emptyDate = false,
      emptyScoring = false,
      emptyNumberOfCourts = false,
      emptyTypeOfCourts = false,
      emptyNumberOfPlayers = false,
      emptyTime = false;
  final admobService = AdmobService.getInstance();

  _CreateTournamentState(this.endUser);


  @override
  void initState() {
    super.initState();
    admobService.showCreateTournamentBannerAd();
  }


  @override
  void dispose() {
    admobService.hideCreateTournamentBannerAd();
    admobService.showScheduleTournamentBannerAd();
    super.dispose();
  }

  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                body: Container(
                  color: customAppTheme.bgLayer2,
                  child: ListView(
                    padding: Spacing.top(48),
                    children: [
                      Container(
                        margin: Spacing.fromLTRB(24, 0, 24, 0),
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            MdiIcons.chevronLeft,
                            color: themeData.colorScheme.onBackground,
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "Create Tournament",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.headline5,
                                    color: customAppTheme.colorSuccess,
                                    fontWeight: 600)),
                          ]),
                        ),
                      ),
                      Container(
                        margin: Spacing.fromLTRB(24, 8, 24, 0),
                        child: Text(
                          "We need to know some details",
                          textAlign: TextAlign.center,
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              color: themeData.colorScheme.onBackground,
                              muted: true),
                        ),
                      ),
                      Container(
                        margin: Spacing.fromLTRB(40, 40, 40, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextField(
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyName = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyName = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: nameController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText:
                                  emptyName ? "Name can't be empty" : null,
                                  hintText: 'Enter Tournament Name',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyPlace = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyPlace = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: placeController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText:
                                  emptyPlace ? "Place can't be empty" : null,
                                  hintText: 'Place',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onTap: ()async{
                                _selectDate(context);
                              },
                              readOnly: true,
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyDate = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyDate = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: dateController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: emptyDate
                                      ? "Date can't be empty"
                                      : null,
                                  hintText: 'Date',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onTap: ()async{
                                selectStartTime(context);
                              },
                              readOnly: true,
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyTime = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyTime = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: timeController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: emptyTime
                                      ? "Time can't be empty"
                                      : null,
                                  hintText: 'Time',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyScoring = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyScoring = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: scoringController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: emptyScoring
                                      ? "Scoring can't be empty"
                                      : null,
                                  hintText: 'Scoring',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onTap: ()async{
                                showNumberPickerDialog(
                                    context, numberOfCourtsController);
                              },
                              readOnly: true,
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyNumberOfCourts = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyNumberOfCourts = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: numberOfCourtsController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: emptyNumberOfCourts
                                      ? "Number Of Courts can't be empty"
                                      : null,
                                  hintText: 'Number Of Courts',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyTypeOfCourts = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyTypeOfCourts = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: typeOfCourtsController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: emptyTypeOfCourts
                                      ? "Type of courts can't be empty"
                                      : null,
                                  hintText: 'Type Of Courts',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            TextField(
                              onTap: ()async{
                                showNumberPickerDialog(
                                    context, numberOfPlayersController);
                              },
                              readOnly: true,
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  setState(() {
                                    emptyNumberOfPlayers = true;
                                  });
                                } else {
                                  setState(() {
                                    emptyNumberOfPlayers = false;
                                  });
                                }
                              },
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: Colors.black),
                              controller: numberOfPlayersController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: emptyNumberOfPlayers
                                      ? "Number Of Players can't be empty"
                                      : null,
                                  hintText: 'Number Of Players',
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6,
                                      color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white30,
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey))),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            RaisedButton(
                              color: customAppTheme.colorSuccess,
                              child: Text("Create"),
                              onPressed: () {
                                if (nameController.text.isEmpty &&
                                    placeController.text.isEmpty &&
                                    dateController.text.isEmpty &&
                                    timeController.text.isEmpty &&
                                    scoringController.text.isEmpty &&
                                    numberOfCourtsController.text.isEmpty &&
                                    typeOfCourtsController.text.isEmpty &&
                                    numberOfPlayersController.text.isEmpty) {
                                  setState(() {
                                    emptyName = true;
                                    emptyPlace = true;
                                    emptyDate = true;
                                    emptyTime=true;
                                    emptyScoring = true;
                                    emptyTypeOfCourts = true;
                                    emptyNumberOfCourts = true;
                                    emptyNumberOfPlayers = true;
                                  });
                                } else if (nameController.text.isEmpty) {
                                  emptyName = true;
                                } else if (placeController.text.isEmpty) {
                                  emptyPlace = true;
                                } else if (dateController.text.isEmpty) {
                                  emptyDate = true;
                                }else if (timeController.text.isEmpty) {
                                  emptyTime = true;
                                } else if (scoringController.text.isEmpty) {
                                  emptyScoring = true;
                                } else
                                if (numberOfCourtsController.text.isEmpty) {
                                  emptyNumberOfCourts = true;
                                } else
                                if (typeOfCourtsController.text.isEmpty) {
                                  emptyTypeOfCourts = true;
                                } else
                                if (numberOfPlayersController.text.isEmpty) {
                                  emptyNumberOfPlayers = true;
                                } else {
                                  createTournament();
                                }
                              },
                            ),
                            SizedBox(
                              height: height * 0.07,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
      },
    );
  }

  Widget singleChoice({String title}) {
    return Container(
      padding: Spacing.fromLTRB(24, 16, 0, 16),
      decoration: BoxDecoration(
          color: customAppTheme.bgLayer1,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8))),
      child: Text(
        title,
        style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
            color: themeData.colorScheme.onBackground, fontWeight: 500),
      ),
    );
  }


  //Function to show number picker dialog
  void showNumberPickerDialog(BuildContext context,
      TextEditingController controller) async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 40,
          title: new Text("Pick a number"),
          initialIntegerValue: 10,
        );
      },
    ).then((int value) {
      if (value != null) {
        setState(() {
          controller.text = value.toString();
        });
      }
    }
    );
  }

  //Function to show date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      if (picked != null) {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      } else {

      }
    }
  }

  //Function to create a tournament in firebase database
  void createTournament() {
    showLoaderDialog(context);
    DateTime now = DateTime.now();
    String formattedDate =
    DateFormat('kk:mm:ss \n EEE d MMM')
        .format(now);
    List<Player> list = new List();
    list.add(new Player(id: FirebaseAuth.instance.currentUser.uid,name: endUser.name,picture: endUser.picture));
    CollectionReference
    tournamentsCollectionReference =
    FirebaseFirestore.instance
        .collection("tournaments");
    String id=tournamentsCollectionReference.doc().id;
    Tournament tournament = new Tournament(
      documentId: id,
        name: nameController.text,
        date: dateController.text,
        time: timeController.text,
        numberOfCourts: numberOfCourtsController.text,
        numberOfPlayers:
        numberOfPlayersController.text,
        place: placeController.text,
        scoring: scoringController.text,
        typeOfCourts: typeOfCourtsController.text,
        createdDateAndTime: formattedDate,
        playersList: list
    );
    tournamentsCollectionReference.doc(id)
        .set(tournament.toJson())
        .then((value) => print("Tournament Created"))
        .catchError((error) => print("error $error"));
    Navigator.of(context,rootNavigator: true).pop();
    showToast("Tournament Created");
    Navigator.pop(context);
  }

  //Function to show loader widget
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
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

  //Function to show time picker dialog
  Future<Null> selectStartTime(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timePicked != null) {
      setState(() {
        timeController.text = timePicked.format(context).toString();
        emptyTime = false;
      });
    }
  }

}
