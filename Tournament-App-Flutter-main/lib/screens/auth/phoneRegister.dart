import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tournament_app/screens/auth/Login.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/services/admob_service.dart';

class PhoneRegister extends StatefulWidget {
  final EndUser endUser;

  PhoneRegister({Key key,@required this.endUser});

  @override
  _PhoneRegisterState createState() => _PhoneRegisterState(this.endUser);
}

class _PhoneRegisterState extends State<PhoneRegister> {
  EndUser endUser,newEndUser;

  _PhoneRegisterState(this.endUser);

  String verificationCode;
  TextEditingController _numberController,
      _otp1Controller,
      _otp2Controller,
      _otp3Controller,
      _otp4Controller,
      _otp5Controller,
      _otp6Controller;
  String userNumber="";
  FocusNode _otp1FocusNode,
      _otp2FocusNode,
      _otp3FocusNode,
      _otp4FocusNode,
      _otp5FocusNode,
      _otp6FocusNode;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool emptyNumber = false, shortNumber = false;

  ThemeData themeData;
  bool isInVerification = false;

  List<bool> _dataExpansionPanel = [true, false];
  CollectionReference usersCollectionReference=FirebaseFirestore.instance.collection("users");
  final admobService = AdmobService.getInstance();


  @override
  void initState() {
    super.initState();
    admobService.showPhoneRegisterAd();
    admobService.hideHomeBannerAd();
    admobService.hideScheduleTournamentBannerAd();
    admobService.hideOtpVerificationBannerAd();
    admobService.hideProfileBannerAd();
    admobService.hideCreateTournamentBannerAd();
    admobService.hideResetPasswordBannerAd();
    admobService.hideRegisterBannerAd();
    admobService.hideLoginBannerAd();
    _numberController = TextEditingController();
    _otp1Controller = TextEditingController();
    _otp2Controller = TextEditingController();
    _otp3Controller = TextEditingController();
    _otp4Controller = TextEditingController();
    _otp5Controller = TextEditingController();
    _otp6Controller = TextEditingController();
    _otp1FocusNode = FocusNode();
    _otp2FocusNode = FocusNode();
    _otp3FocusNode = FocusNode();
    _otp4FocusNode = FocusNode();
    _otp5FocusNode = FocusNode();
    _otp6FocusNode = FocusNode();

    _otp1Controller.addListener(() {
      if (_otp1Controller.text.length >= 1) {
        _otp2FocusNode.requestFocus();
      }
    });

    _otp2Controller.addListener(() {
      if (_otp2Controller.text.length >= 1) {
        _otp3FocusNode.requestFocus();
      }
    });

    _otp3Controller.addListener(() {
      if (_otp3Controller.text.length >= 1) {
        _otp4FocusNode.requestFocus();
      }
    });
    _otp4Controller.addListener(() {
      if (_otp4Controller.text.length >= 1) {
        _otp5FocusNode.requestFocus();
      }
    });
    _otp5Controller.addListener(() {
      if (_otp5Controller.text.length >= 1) {
        _otp6FocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    admobService.hidePhoneRegisterBannerAd();
    _numberController.dispose();
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();
    _otp1FocusNode.dispose();
    _otp2FocusNode.dispose();
    _otp3FocusNode.dispose();
    _otp4FocusNode.dispose();
    _otp6Controller.dispose();
    _otp5Controller.dispose();
    _otp5FocusNode.dispose();
    _otp6FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                body: Stack(
                  children: <Widget>[
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("OTP Verification",
                              style: themeData.appBarTheme.textTheme.headline6),
                          Container(
                            margin: EdgeInsets.only(
                                top: MySize.size32,
                                left: MySize.size16,
                                right: MySize.size16),
                            child: ExpansionPanelList(
                              expandedHeaderPadding: EdgeInsets.all(0),
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  _dataExpansionPanel[index] = !isExpanded;
                                });
                              },
                              animationDuration: Duration(milliseconds: 500),
                              children: <ExpansionPanel>[
                                ExpansionPanel(
                                    canTapOnHeader: true,
                                    headerBuilder:
                                        (BuildContext context, bool isExpanded) {
                                      return Container(
                                          padding: EdgeInsets.all(MySize.size16),
                                          child: Text("Number",
                                              style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle1,
                                                  fontWeight:
                                                  isExpanded ? 600 : 400)));
                                    },
                                    body: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: <Widget>[
                                          IntlPhoneField(
                                            decoration: InputDecoration(
                                              errorText: emptyNumber
                                                  ? "Number can't be empty"
                                                  : shortNumber
                                                  ? "Number must be 10 digits only"
                                                  : null,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  ),
                                                  borderSide: BorderSide.none),
                                              filled: true,
                                              fillColor:
                                              themeData.colorScheme.background,
                                              prefixIcon: Icon(
                                                MdiIcons.phoneOutline,
                                                size: 22,
                                                color: themeData
                                                    .colorScheme.onBackground
                                                    .withAlpha(200),
                                              ),
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                            initialCountryCode: 'PK',
                                            controller: _numberController,
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                letterSpacing: 0.1,
                                                color: themeData
                                                    .colorScheme.onBackground,
                                                fontWeight: 500),
                                            keyboardType: TextInputType.number,
                                            onChanged: (number) {
                                              if (number.number.isEmpty) {
                                                setState(() {
                                                  emptyNumber = true;
                                                });
                                              }
                                              else{
                                                if(number.number.length<10 || number.number.length>10){
                                                  setState(() {
                                                    emptyNumber=false;
                                                    shortNumber=true;
                                                  });
                                                }
                                                else{
                                                  userNumber=number.completeNumber;
                                                  setState(() {
                                                    emptyNumber=false;
                                                    shortNumber=false;
                                                  });

                                                }
                                              }
                                            },
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(8)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: themeData
                                                            .colorScheme.primary
                                                            .withAlpha(24),
                                                        blurRadius: 3,
                                                        offset: Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: FlatButton(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 32),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                      color: themeData
                                                          .colorScheme.primary,
                                                      splashColor: Colors.white
                                                          .withAlpha(150),
                                                      highlightColor: themeData
                                                          .colorScheme.primary,
                                                      onPressed: () {
                                                        if(_numberController.text.isEmpty){
                                                          setState(() {
                                                            emptyNumber=true;
                                                          });
                                                        }
                                                        else if(_numberController.text.length>10 || _numberController.text.length<10){
                                                          setState(() {
                                                            shortNumber=true;
                                                          });
                                                        }
                                                        else{
                                                          onSendOTP();
                                                        }
                                                      },
                                                      child: Text("Send OTP",
                                                          style:
                                                          AppTheme.getTextStyle(
                                                              themeData
                                                                  .textTheme
                                                                  .bodyText2,
                                                              fontWeight: 600,
                                                              color: themeData
                                                                  .colorScheme
                                                                  .onPrimary))),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    isExpanded: _dataExpansionPanel[0]),
                                ExpansionPanel(
                                    canTapOnHeader: true,
                                    headerBuilder:
                                        (BuildContext context, bool isExpanded) {
                                      return Container(
                                          padding: EdgeInsets.all(16),
                                          child: Text("OTP",
                                              style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle1,
                                                  fontWeight:
                                                  isExpanded ? 600 : 500)));
                                    },
                                    body: Container(
                                        padding: EdgeInsets.only(
                                            bottom: MySize.size16,
                                            top: MySize.size8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                singleDigitWidget(_otp1Controller,
                                                    _otp1FocusNode),
                                                singleDigitWidget(_otp2Controller,
                                                    _otp2FocusNode),
                                                singleDigitWidget(_otp3Controller,
                                                    _otp3FocusNode),
                                                singleDigitWidget(_otp4Controller,
                                                    _otp4FocusNode),
                                                singleDigitWidget(_otp5Controller,
                                                    _otp5FocusNode),
                                                singleDigitWidget(_otp6Controller,
                                                    _otp6FocusNode),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            MySize.size8)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: themeData
                                                            .colorScheme.primary
                                                            .withAlpha(24),
                                                        blurRadius: 3,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: FlatButton(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: MySize.size8,
                                                          horizontal:
                                                          MySize.size32),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              MySize.size4)),
                                                      color: themeData
                                                          .colorScheme.primary,
                                                      splashColor: Colors.white
                                                          .withAlpha(150),
                                                      highlightColor: themeData
                                                          .colorScheme.primary,
                                                      onPressed: () async{
                                                        try{
                                                          showLoaderDialog(context);
                                                          await firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: _otp1Controller.text+_otp2Controller.text+_otp3Controller.text+_otp4Controller.text+_otp5Controller.text+_otp6Controller.text));
                                                          newEndUser=new EndUser(birthday: endUser.birthday,email: null,country: null,id: firebaseAuth.currentUser.uid,name: endUser.name,picture: null,phone: userNumber,role: 'player');
                                                          await usersCollectionReference
                                                              .doc(newEndUser.id)
                                                              .set(endUser.toJson())
                                                              .then((value) => print("User Added"))
                                                              .catchError((error) => print("error $error"));
                                                          signOut();
                                                          Navigator.of(context,rootNavigator: true).pop();
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => Login()),(route)=>false);
                                                        }catch(e){
                                                          Navigator.of(context,rootNavigator: true).pop();
                                                          showToast("Invalid otp");
                                                        }
                                                      },
                                                      child: Text("Verify",
                                                          style: AppTheme.getTextStyle(
                                                              themeData.textTheme
                                                                  .bodyText2,
                                                              fontWeight: 600,
                                                              color: themeData
                                                                  .colorScheme
                                                                  .onPrimary))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    isExpanded: _dataExpansionPanel[1])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: MySize.size30,
                      left: MySize.size10,
                      child: BackButton(
                        color: themeData.appBarTheme.iconTheme.color,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                )));
      },
    );
  }

  //Function to recieve otp message from firebase and register
  void onSendOTP() async {
    showLoaderDialog(context);
    if (!isInVerification) {
      FocusScope.of(context).unfocus();
      setState(() {
        isInVerification = false; // use here own logic
        _dataExpansionPanel[1] = true;
      });
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
        newEndUser=new EndUser(birthday: endUser.birthday,email: null,country: null,id: firebaseAuth.currentUser.uid,name: endUser.name,picture: null,phone: userNumber,role: 'player');
        await usersCollectionReference
            .doc(newEndUser.id)
            .set(endUser.toJson())
            .then((value) => print("User Added"))
            .catchError((error) => print("error $error"));
        signOut();
        Navigator.of(context,rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Login()),(route)=>false);
        },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.of(context,rootNavigator: true).pop();
        if (e.code == 'invalid-phone-number') {
          showToast("The provided phone number is not valid.");
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        setState(() {
          verificationCode=verificationId;
        });
        Navigator.of(context,rootNavigator: true).pop();
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationCode=verificationId;
        });
        Navigator.of(context,rootNavigator: true).pop();
      },
    );
  }

  Widget singleDigitWidget(
      TextEditingController _controller, FocusNode _focusNode) {
    return Container(
      width: 36,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: MySize.size4),
      color: Colors.transparent,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: themeData
                        .inputDecorationTheme.border.borderSide.color)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: themeData
                        .inputDecorationTheme.enabledBorder.borderSide.color)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: themeData
                        .inputDecorationTheme.focusedBorder.borderSide.color)),
            helperText: ""),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
      ),
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

  //Function to sign out user
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
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
}
