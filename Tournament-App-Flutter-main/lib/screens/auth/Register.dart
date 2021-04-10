import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tournament_app/screens/auth/OTPVerificationByEmail.dart';
import 'package:tournament_app/services/admob_service.dart';
import 'package:tournament_app/AppThemeNotifier.dart';
import 'package:tournament_app/model/endUser.dart';
import 'package:tournament_app/model/userFacebook.dart';
import 'package:tournament_app/screens/auth/Login.dart';
import 'package:tournament_app/screens/auth/phoneRegister.dart';
import 'package:tournament_app/screens/home/TournamentFullApp.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../AppTheme.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool emailRegister = true;
  ThemeData themeData;
  bool emptyEmail = false,
      emptyName = false,
      emptyPassword = false,
      shortPassword = false,
      emptyNumber = false,
      shortNumber = false,
      emptyAge = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String get emailotp=> emailController.text;


  String signUpResult;

  bool _passwordHide = true;
  String userNumber;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/user.birthday.read"
    ],
  );
  EndUser endUser;

  CollectionReference usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  final admobService = AdmobService.getInstance();

  @override
  void initState() {
    super.initState();
    admobService.showRegisterBannerAd();
    admobService.hideHomeBannerAd();
    admobService.hideScheduleTournamentBannerAd();
    admobService.hideOtpVerificationBannerAd();
    admobService.hideProfileBannerAd();
    admobService.hideCreateTournamentBannerAd();
    admobService.hideResetPasswordBannerAd();
    admobService.hideLoginBannerAd();
    admobService.hidePhoneRegisterBannerAd();

  }

  @override
  void dispose() {
    admobService.hideRegisterBannerAd();
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    passwordController.dispose();
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
                            "Sign up",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.headline5,
                                fontWeight: 600,
                                letterSpacing: 0),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size32),
                          child: TextFormField(
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
                            controller: nameController,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              errorText:
                                  emptyName ? "Name can't be empty" : null,
                              hintText: "Username",
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText1,
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
                                MdiIcons.accountOutline,
                                size: MySize.size22,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        (emailRegister == true)
                            ? Container(
                                margin: EdgeInsets.only(top: MySize.size16),
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
                                    errorText: emptyEmail
                                        ? "Email can't be empty"
                                        : null,
                                    hintText: "Email address",
                                    hintStyle: AppTheme.getTextStyle(
                                        themeData.textTheme.subtitle2,
                                        letterSpacing: 0.1,
                                        color:
                                            themeData.colorScheme.onBackground,
                                        fontWeight: 500),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                themeData.colorScheme.surface,
                                            width: 1.2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                themeData.colorScheme.surface,
                                            width: 1.2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                themeData.colorScheme.surface,
                                            width: 1.2)),
                                    prefixIcon: Icon(
                                      MdiIcons.emailOutline,
                                      size: MySize.size22,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {
                              showPickerDate(context);
                            },
                            controller: ageController,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              errorText: emptyAge ? "Age can't be empty" : null,
                              hintText: "Age",
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
                                MdiIcons.information,
                                size: MySize.size22,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        (emailRegister == true)
                            ? Container(
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
                                        if (text.length < 6) {
                                          setState(() {
                                            shortPassword = true;
                                          });
                                        } else {
                                          shortPassword = false;
                                        }
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
                                        : (shortPassword
                                            ? "Password must be at least 6 characters long"
                                            : null),
                                    hintStyle: AppTheme.getTextStyle(
                                        themeData.textTheme.subtitle2,
                                        letterSpacing: 0.1,
                                        color:
                                            themeData.colorScheme.onBackground,
                                        fontWeight: 500),
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                themeData.colorScheme.surface,
                                            width: 1.2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                themeData.colorScheme.surface,
                                            width: 1.2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                            color:
                                                themeData.colorScheme.surface,
                                            width: 1.2)),
                                    prefixIcon: Icon(
                                      MdiIcons.lockOutline,
                                      size: MySize.size22,
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
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: Row(
                            children: <Widget>[
                              (emailRegister == true)
                                  ? ClipOval(
                                      child: Material(
                                        color: Colors.grey,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withAlpha(100),
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
                                            setState(() {
                                              emailRegister = false;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Material(
                                        color: Colors.grey,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withAlpha(100),
                                          highlightColor:
                                              themeData.colorScheme.primary,
                                          // inkwell color
                                          child: SizedBox(
                                              width: MySize.size36,
                                              height: MySize.size36,
                                              child: Icon(MdiIcons.email,
                                                  color: Colors.white,
                                                  size: MySize.size20)),
                                          onTap: () {
                                            setState(() {
                                              emailRegister = true;
                                            });
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
                                        await handleSignIn();
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
                                        offset: Offset(0, 3),
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
                                      if (nameController.text.isEmpty &&
                                          ((emailRegister == true)
                                              ? (emailController.text.isEmpty &&
                                                  passwordController
                                                      .text.isEmpty)
                                              : (null)) &&
                                          ageController.text.isEmpty) {
                                        setState(() {
                                          emptyName = true;
                                          if (emailRegister == true) {
                                            emptyEmail = true;
                                            emptyPassword = true;
                                          } else {
                                            emptyNumber = true;
                                          }
                                          emptyAge = true;
                                        });
                                      } else if (nameController.text.isEmpty) {
                                        setState(() {
                                          emptyName = true;
                                        });
                                      } else if (emailRegister == true) {
                                        if (emailController.text.isEmpty) {
                                          setState(() {
                                            emptyEmail = true;
                                          });
                                        } else if (passwordController
                                            .text.isEmpty) {
                                          setState(() {
                                            emptyPassword = true;
                                          });
                                        } else if (passwordController
                                                .text.length <
                                            6) {
                                          setState(() {
                                            shortPassword = true;
                                          });
                                        }
                                      }
                                      if (ageController.text.isEmpty) {
                                        setState(() {
                                          emptyAge = true;
                                        });
                                      } else {
                                        if (emailRegister == true) {
                                          showLoaderDialog(context);
                                          signUpResult = await signUp(
                                              nameController.text,
                                              emailController.text,
                                              passwordController.text,
                                              null,
                                              ageController.text);
                                          if (signUpResult == ("Success")) {
                                            Navigator.of(context,rootNavigator: true).pop();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OTPVerificationByEmail()),(route)=>false);
                                          } else {
                                            Navigator.of(context,rootNavigator: true).pop();
                                            showToast(signUpResult);
                                          }
                                        } else {
                                          EndUser endUser = new EndUser(
                                              phone: null,
                                              picture: null,
                                              name: nameController.text,
                                              id: null,
                                              email: null,
                                              country: null,
                                              birthday: ageController.text);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhoneRegister(
                                                        endUser: endUser,
                                                      )));
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "CREATE",
                                          style: AppTheme.getTextStyle(
                                              themeData.textTheme.bodyText2,
                                              fontWeight: 700,
                                              color:
                                                  themeData.colorScheme.primary,
                                              letterSpacing: 0.5),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MySize.size16),
                                          child: Icon(
                                            MdiIcons.arrowRight,
                                            color:
                                                themeData.colorScheme.primary,
                                            size: 18,
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
                          margin: EdgeInsets.only(top: 16),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                "I have an account",
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

  //Function to sign up a user using email and password
  Future<String> signUp(String name, String email, String password, String age,
      String phone) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      setDisplayName(name);
      endUser = new EndUser(
        birthday: ageController.text,
        country: null,
        picture: null,
        email: email,
        name: name,
        id: _firebaseAuth.currentUser.uid,
        phone: null,
        role: 'player'
      );
      await usersCollectionReference
          .doc(_firebaseAuth.currentUser.uid)
          .set(endUser.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("error $error"));
      signOut();
      return "Success";

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  //Function to set firebase username of a user
  Future<void> setDisplayName(String name) async {
    User user = FirebaseAuth.instance.currentUser;
    user.updateProfile(displayName: name);
  }

  //Function to sign out user
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  //Function to sign in user using google
  Future<void> handleSignIn() async {
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
              : null,role: 'player');
      //Linking google with firebase
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      usersCollectionReference
          .doc(_firebaseAuth.currentUser.uid)
          .set(endUser.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("error $error"));
      Navigator.of(context).pop('dialog');
      if (endUser != null) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentFullApp(
                      endUser: endUser,
                    )));
      } else {
        showToast("Failed to login");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        String email = e.email;
        AuthCredential pendingCredential = e.credential;
        // Fetch a list of what sign-in methods exist for the conflicting user
        List<String> userSignInMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
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
              await _firebaseAuth.signInWithCredential(credential);

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
          DocumentSnapshot documentSnapshot = await usersCollectionReference
              .doc(_firebaseAuth.currentUser.uid)
              .get();
          endUser = EndUser.fromMap(documentSnapshot.data());
          Navigator.of(context).pop('dialog');
          if (endUser != null) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TournamentFullApp(
                          endUser: endUser,
                        )));
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
          birthday: userFacebook.birthday,role: 'player');
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      await _firebaseAuth.signInWithCredential(credential);
      usersCollectionReference
          .doc(_firebaseAuth.currentUser.uid)
          .set(endUser.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("error $error"));
      Navigator.of(context).pop('dialog');
      if (endUser != null) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentFullApp(
                      endUser: endUser,
                    )));
      } else {
        showToast("Failed to login");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        String email = e.email;
        AuthCredential pendingCredential = e.credential;
        // Fetch a list of what sign-in methods exist for the conflicting user
        List<String> userSignInMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
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
              await _firebaseAuth.signInWithCredential(credential);

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
          usersCollectionReference
              .doc(_firebaseAuth.currentUser.uid)
              .set(endUser.toJson())
              .then((value) => print("User Added"))
              .catchError((error) => print("error $error"));
          Navigator.of(context).pop('dialog');
          if (endUser != null) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TournamentFullApp(
                          endUser: endUser,
                        )));
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

  //Function to show date picker
  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("Select Data"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ageController.text = (picker.adapter as DateTimePickerAdapter)
                  .value
                  .month
                  .toString() +
              "/" +
              (picker.adapter as DateTimePickerAdapter).value.day.toString() +
              "/" +
              (picker.adapter as DateTimePickerAdapter).value.year.toString();
        }).showDialog(context);
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

  //TODO:sending the OTP message on the email

}
