import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/model/userFacebook.dart';
import 'package:tournament_app/screens/auth/ResetPassword.dart';
import 'package:tournament_app/screens/auth/Register.dart';
import 'package:tournament_app/screens/home/TournamentFullApp.dart';
import 'package:tournament_app/services/admob_service.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_app/screens/auth/OTPVerification.dart';

import '../../AppTheme.dart';
import '../../services/admob_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ThemeData themeData;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool emptyEmail = false, emptyPassword = false, shortPassword = false;
  String signInResult;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/user.birthday.read"
    ],
  );
  EndUser endUser;
  final admobService = AdmobService.getInstance();

  bool _passwordHide = true;
  CollectionReference usersCollectionReference =
      FirebaseFirestore.instance.collection("users");

  @override
  void initState() {
    super.initState();
    admobService.showLoginBannerAd();
    admobService.hideHomeBannerAd();
    admobService.hideScheduleTournamentBannerAd();
    admobService.hideOtpVerificationBannerAd();
    admobService.hideProfileBannerAd();
    admobService.hideCreateTournamentBannerAd();
    admobService.hideResetPasswordBannerAd();
    admobService.hideRegisterBannerAd();
    admobService.hidePhoneRegisterBannerAd();
    Future.delayed(Duration.zero, () {
      checkLogin();
    });
  }

  @override
  void dispose() {
    admobService.hideLoginBannerAd();
    super.dispose();
  }

  //Function to check whether a user is already signed in or not
  void checkLogin() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showLoaderDialog(context);
      DocumentSnapshot documentSnapshot =
          await usersCollectionReference.doc(user.uid).get();
      EndUser endUser = new EndUser.fromMap(documentSnapshot.data());
      if (endUser != null) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentFullApp(
                      endUser: endUser,
                    )),
            (route) => false);
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                backgroundColor: themeData.scaffoldBackgroundColor,
                body: Container(
                  padding: EdgeInsets.only(
                      left: MySize.size24, right: MySize.size24),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Sign in",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.headline5,
                                fontWeight: 600,
                                letterSpacing: 0),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: TextFormField(
                            onChanged: (text) {
                              if (text.isEmpty) {
                                setState(() {
                                  emptyEmail = true;
                                });
                              } else {
                                setState(() {
                                  emptyEmail = false;
                                });
                              }
                            },
                            controller: emailController,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              errorText:
                                  emptyEmail ? "Email can't be empty" : null,
                              hintText: "Email address",
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeData.colorScheme.surface,
                                      width: 1.2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeData.colorScheme.surface,
                                      width: 1.2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeData.colorScheme.surface,
                                      width: 1.2)),
                              prefixIcon: Icon(
                                MdiIcons.emailOutline,
                                size: 22,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: TextFormField(
                            onChanged: (text) {
                              if (text.isEmpty) {
                                setState(() {
                                  emptyPassword = true;
                                });
                              } else {
                                setState(() {
                                  emptyPassword = false;
                                });
                              }
                            },
                            controller: passwordController,
                            obscureText: _passwordHide,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              errorText: emptyPassword
                                  ? "Password can't be empty"
                                  : null,
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeData.colorScheme.surface,
                                      width: 1.2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeData.colorScheme.surface,
                                      width: 1.2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: themeData.colorScheme.surface,
                                      width: 1.2)),
                              prefixIcon: Icon(
                                MdiIcons.lockOutline,
                                size: 22,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _passwordHide = !_passwordHide;
                                  });
                                },
                                child: Icon(
                                  _passwordHide
                                      ? MdiIcons.eyeOffOutline
                                      : MdiIcons.eyeOutline,
                                  size: MySize.size22,
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassword()));
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText2,
                                  fontWeight: 500),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: Row(
                            children: <Widget>[
                              ClipOval(
                                child: Material(
                                  color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.white.withAlpha(100),
                                    highlightColor:
                                        themeData.colorScheme.primary,
                                    // inkwell color
                                    child: SizedBox(
                                        width: MySize.size36,
                                        height: MySize.size36,
                                        child: Icon(MdiIcons.phone,
                                            color: Colors.white,
                                            size: MySize.size20)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OTPVerification()));
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: MySize.size16),
                                child: ClipOval(
                                  child: Material(
                                    color: Color(0xffe33239),
                                    child: InkWell(
                                      splashColor: Colors.white.withAlpha(100),
                                      highlightColor:
                                          themeData.colorScheme.primary,
                                      // inkwell color
                                      child: SizedBox(
                                          width: MySize.size36,
                                          height: MySize.size36,
                                          child: Icon(MdiIcons.google,
                                              color: Colors.white,
                                              size: MySize.size20)),
                                      onTap: () async {
                                        showLoaderDialog(context);
                                        await _handleSignIn();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: MySize.size16),
                                child: ClipOval(
                                  child: Material(
                                    color: Color(0xff335994),
                                    child: InkWell(
                                      splashColor: Colors.white.withAlpha(100),
                                      highlightColor:
                                          themeData.colorScheme.primary,
                                      // inkwell color
                                      child: SizedBox(
                                          width: MySize.size36,
                                          height: MySize.size36,
                                          child: Center(
                                              child: Text(
                                            "F",
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.headline6,
                                                color: Colors.white,
                                                letterSpacing: 0),
                                          ))),
                                      onTap: () async {
                                        showLoaderDialog(context);
                                        await loginWithFacebook();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(MySize.size28)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeData.cardTheme.shadowColor
                                            .withAlpha(18),
                                        blurRadius: 4,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(left: MySize.size32),
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MySize.size28)),
                                    color: themeData.backgroundColor,
                                    splashColor: themeData.colorScheme.primary,
                                    highlightColor: themeData.backgroundColor,
                                    onPressed: () async {
                                      if (emailController.text.isEmpty &&
                                          passwordController.text.isEmpty) {
                                        setState(() {
                                          emptyEmail = true;
                                          emptyPassword = true;
                                        });
                                      } else if (emailController.text.isEmpty) {
                                        setState(() {
                                          emptyEmail = true;
                                        });
                                      } else if (passwordController
                                          .text.isEmpty) {
                                        setState(() {
                                          emptyPassword = true;
                                        });
                                      } else {
                                        showLoaderDialog(context);
                                        signInResult = await signIn(
                                            emailController.text,
                                            passwordController.text);
                                        if (signInResult == "true") {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TournamentFullApp(
                                                        endUser: endUser,
                                                      )),
                                              (route) => false);
                                        } else {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          showToast(signInResult);
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "NEXT",
                                          style: AppTheme.getTextStyle(
                                              themeData.textTheme.bodyText2,
                                              fontWeight: 600,
                                              color:
                                                  themeData.colorScheme.primary,
                                              letterSpacing: 0.5),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MySize.size16),
                                          child: Icon(
                                            MdiIcons.chevronRight,
                                            color:
                                                themeData.colorScheme.primary,
                                            size: MySize.size18,
                                          ),
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.only(
                                        top: MySize.size12,
                                        bottom: MySize.size12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              },
                              child: Text(
                                "I haven't an account",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  //Function to sign in user using email and password
  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot documentSnapshot =
          await usersCollectionReference.doc(_auth.currentUser.uid).get();
      endUser = EndUser.fromMap(documentSnapshot.data());
      return "true";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.code.toString();
      }
    }
  }

  //Function to sign in user using google
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signOut();
      //Get Data from google
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      //Get Birthday
      Map<String, dynamic> data = await getDateOfBirth(googleUser);
      var birthday = (data['birthdays'] != null) ? data['birthdays'][0] : null;
      endUser = new EndUser(
          id: googleUser.id.toString(),
          name: googleUser.displayName,
          email: googleUser.email,
          picture: googleUser.photoUrl,
          country: null,
          birthday: (birthday != null)
              ? (birthday['date']['day'].toString() +
                  "/" +
                  birthday['date']['month'].toString() +
                  "/" +
                  birthday['date']['year'].toString())
              : null,
          role: 'player');
      //Linking google with firebase
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      usersCollectionReference
          .doc(_auth.currentUser.uid)
          .set(endUser.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("error $error"));
      Navigator.of(context).pop('dialog');
      if (endUser != null) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentFullApp(
                      endUser: endUser,
                    )),
            (route) => false);
      } else {
        showToast("Failed to login");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        String email = e.email;
        AuthCredential pendingCredential = e.credential;
        // Fetch a list of what sign-in methods exist for the conflicting user
        List<String> userSignInMethods =
            await _auth.fetchSignInMethodsForEmail(email);
        // If the user has several sign-in methods,
        // the first method in the list will be the "recommended" method to use.
        // Since other providers are now external, you must now sign the user in with another
        // auth provider, such as Facebook.
        if (userSignInMethods.first == 'facebook.com') {
          // Create a new Facebook credential
          AccessToken accessToken = await FacebookAuth.instance.login(
              permissions: [
                'email',
                'public_profile',
                'user_birthday',
                'user_hometown'
              ]);
          final OAuthCredential credential =
              FacebookAuthProvider.credential(accessToken.token);
          //FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

          // Sign the user in with the credential
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
          DocumentSnapshot documentSnapshot =
              await usersCollectionReference.doc(_auth.currentUser.uid).get();
          endUser = EndUser.fromMap(documentSnapshot.data());
          Navigator.of(context).pop('dialog');
          if (endUser != null) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => TournamentFullApp(
                          endUser: endUser,
                        )),
                (route) => false);
          } else {
            showToast("Failed to login");
          }

          // Success! Go back to your application flow
          //return goToApplication();
        }
        Navigator.of(context).pop('dialog');
      }
    }
  }

  //Leaf function of google sign in to get dob of user
  Future<Map<String, dynamic>> getDateOfBirth(GoogleSignInAccount user) async {
    final headers = await user.authHeaders;
    final http.Response response = await http.get(
        'https://people.googleapis.com/v1/people/${user.id}?personFields=birthdays',
        headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      return null;
    }
  }

  //Function to sign in user using facebook
  Future<void> loginWithFacebook() async {
    try {
      AccessToken accessToken = await FacebookAuth.instance.login(permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_hometown'
      ]);
      final userData = await FacebookAuth.instance.getUserData(
          fields: 'email,name,picture.width(600),birthday,hometown');
      UserFacebook userFacebook = new UserFacebook.fromFacebook(userData);
      endUser = new EndUser(
          id: userFacebook.id,
          name: userFacebook.name,
          email: userFacebook.email,
          picture: userFacebook.picture.data.url,
          country: userFacebook.hometown.name,
          birthday: userFacebook.birthday,
          role: 'player');
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      await _auth.signInWithCredential(credential);
      usersCollectionReference
          .doc(_auth.currentUser.uid)
          .set(endUser.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("error $error"));
      Navigator.of(context).pop('dialog');
      if (endUser != null) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentFullApp(
                      endUser: endUser,
                    )),
            (route) => false);
      } else {
        showToast("Failed to login");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        String email = e.email;
        AuthCredential pendingCredential = e.credential;
        // Fetch a list of what sign-in methods exist for the conflicting user
        List<String> userSignInMethods =
            await _auth.fetchSignInMethodsForEmail(email);
        // If the user has several sign-in methods,
        // the first method in the list will be the "recommended" method to use.
        if (userSignInMethods.first == 'google.com') {
          // Create a new Facebook credential
          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign the user in with the credential
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
          usersCollectionReference
              .doc(_auth.currentUser.uid)
              .set(endUser.toJson())
              .then((value) => print("User Added"))
              .catchError((error) => print("error $error"));
          Navigator.of(context).pop('dialog');
          if (endUser != null) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => TournamentFullApp(
                          endUser: endUser,
                        )),
                (route) => false);
          } else {
            showToast("Failed to login");
          }

          // Success! Go back to your application flow
          //return goToApplication();
        } else if (userSignInMethods.first == 'password') {
          Navigator.of(context).pop('dialog');
          showToast("UserAlreadyExists");
        }
      } else {
        Navigator.of(context).pop('dialog');
        showToast("Failed to login");
      }
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
}
