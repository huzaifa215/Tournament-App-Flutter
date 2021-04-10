import 'package:email_auth/email_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tournament_app/screens/auth/Login.dart';
import 'package:tournament_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';


class OTPVerificationByEmail extends StatefulWidget {
  @override
  _OTPVerificationByEmailState createState() => _OTPVerificationByEmailState();
}

class _OTPVerificationByEmailState extends State<OTPVerificationByEmail> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _OTPController = TextEditingController();

  String get _email => _emailController.text;
  String get _OTP => _OTPController.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _OTPFocusNode = FocusNode();

  //TODO:sending the OTP message on the email
  void _sendOTP() async {
    EmailAuth.sessionName = "test Session";
    var res = await EmailAuth.sendOtp(receiverMail: _email);
    if (res) {
      print("OTP Send");
    }
    else{
      print("Problem in sending OTP");
    }
  }
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

  //TODO:Verify the OTP that is send on the email on yours
  void _verifyOTP() async {
    var res = EmailAuth.validate(receiverMail: _email, userOTP: _OTP);
    if (res) {
      print("OPT Verify");
      Login();
    }
    else{
      print("invalid OTP");
      Navigator.of(context,rootNavigator: true).pop();
      showToast("Invalid otp");
    }
  }

  List<Widget> _builtChildern() {
    return [
      // email field input
      _buildemail(),
      SizedBox(
        height: 8.0,
      ),
      // OTP text feild
      _buildOTP(),
      SizedBox(
        height: 8.0,
      ),
      SizedBox(
        height: 8.0,
      ),

      FlatButton(
          padding: EdgeInsets.symmetric(
              vertical: MySize.size8,
              horizontal:
              MySize.size32),
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                  MySize.size4)
          ),
          child: Text("Verify",
              style:TextStyle(
                  fontWeight: FontWeight.w600,
                  )),
      onPressed: _verifyOTP,
      )
      // TODO: Flat button have no prominant boder
    ];
  }

  void _emailEditingComplete() {
    // TODO: keep track on the next widget or the widgets to follow the flow
    FocusScope.of(context).requestFocus(_OTPFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    // how much space should be occupy  at the mainaxis  means jitna space ye chilern arry le ge uthe ne jagah  he occupay ho ge
    children: _builtChildern(),
    ),
    )
  );
  }



  TextField _buildemail() {
    return TextField(
      // TODO: what ever will be written in the textfield it aotumaticcaly edited in the controller
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: "test@test.com",
          //TODO: written as a power on the email
          suffixIcon:TextButton(
            child: Text("Send OTP"),
            onPressed : _sendOTP,
          )
      ),
      //autocorrect: false,//TODO: used to enable the keyboard suggestion
      keyboardType: TextInputType.emailAddress,
      //TODO: Show that keyboard that is suitable for emails
      textInputAction: TextInputAction.next,
      // TODO: show the button that on which we click move to the password section
      onEditingComplete: _emailEditingComplete,
    );
  }


  TextField _buildOTP() {
    return TextField(
      controller: _OTPController,
      focusNode: _OTPFocusNode,
      onEditingComplete: _verifyOTP,
      decoration:
      InputDecoration(labelText: 'OTP Code', hintText: "Enter the OTP"),
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
    );
  }
}



