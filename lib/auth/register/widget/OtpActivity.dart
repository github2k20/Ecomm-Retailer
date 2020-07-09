import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:my_app/auth/register/widget/RegisterActivity.dart';
import 'package:toast/toast.dart';
import 'package:my_app/auth/login/widget/LoginActivity.dart';
import 'package:my_app/auth/register/api/RegisterApi.dart';

class RegisterOTP extends StatefulWidget {
  final String mobileNumber;
  final int receivedOTP;
  String otp_code;
  final String name;
  final String password;
  final String shopName;
  final String phn;

  RegisterOTP(this.mobileNumber, this.receivedOTP,this.name,this.phn,this.password,this.shopName) {}

  @override
  _RegisterOTPState createState() => _RegisterOTPState(mobileNumber, receivedOTP);
}

editClicked(BuildContext context) {
  Navigator.of(context).pushReplacement(new MaterialPageRoute<Null>(
    builder: (BuildContext context) {
      return RegisterActivity();
    },
  ));
}

class _RegisterOTPState extends State<RegisterOTP> {
  bool _isSignUpButtonClicked = false;
  String _mobileNumber;
  int _receivedOTP;
  String otp_code;
  bool isOTPVerified = true;
  bool shouldShowResendButton = false;

  _RegisterOTPState(String mobileNumber, int receivedOTP) {
    _mobileNumber = mobileNumber;
    _receivedOTP = receivedOTP;
    startTimer();
  }

  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              _start = 30;
              shouldShowResendButton = true;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  resendOtpClicked(String mobileNumber) {
    Register api= new Register();
    api.getOTP(mobileNumber)
        .then((value) => {_receivedOTP = value, startTimer()});
    setState(() {
      shouldShowResendButton = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Scaffold(
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[headerWidget(), otpFeildAutoFill()],
                          )),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: verifyNowButton(context))
                ],
              ),
            )),
      ),
    );
  }

  Widget headerWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
//        CommonHeaderLayoutForSignUpScreen.horizontal_vahak_logo(),
//        CommonHeaderLayoutForSignUpScreen.thirtythousand_trusted_transporter(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//              Flexible(
//                child: CommonHeaderLayoutForSignUpScreen.rectangle_layout(
//                    'assets/images/otp.svg'),
//              ),
//              SizedBox(
//                width: 100,
//              ),
                  Visibility(
                    visible: shouldShowResendButton ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Text("00 : " + "$_start",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Metropolisemibold',
                          letterSpacing: -0.18,
                          color: Colors.indigo,
                    ),
                  ),
                    ),
                  )
          ],
              ),
            ),
              SizedBox(
                  height: 50,
                ),
            Text('Enter the OTP sent to:',style: TextStyle(
              fontSize: 18,
              fontFamily: 'Metropolisemibold',
              letterSpacing: -0.18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            )),
            Container(
              //  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: <Widget>[

                    Text(
                     '+91 ' + _mobileNumber,
                      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Metropolisemibold',
        letterSpacing: -0.18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () => {editClicked(context)},
                      child: new Text('Edit',style: TextStyle(
                        fontFamily: 'Metropolisemibold',
                        letterSpacing: -0.18,
                        color: Colors.indigo,
                      )),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otpFeildAutoFill() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
          alignment: Alignment.center,
          child: TextFormField(
            keyboardType: TextInputType.number,
            focusNode: FocusNode(canRequestFocus: true),
            onChanged: (code) => {otp_code = code},
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Metropolismedium',
                letterSpacing: -0.09,
                color: Colors.black),
            maxLength: 4,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Please Enter The OTP Provided',
              errorText: isOTPVerified ? null : 'Please enter a valid OTP',
//              errorStyle: TextStyling.phnumb_error_text_style,
//              hintStyle: TextStyling.phone_numb_hint_text_colour_style(false),
            ),
          ),
        ),
        Visibility(
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: Text('Didn\'t Receive OTP?'
                ),
              ),
              InkWell(
                onTap: () => {resendOtpClicked(_mobileNumber)},
                child: new Text(
                  'Resend OTP',
                  style:TextStyle(
                      fontSize: 18,
                      fontFamily: 'Metropolismedium',
                      letterSpacing: -0.09,
                      color: Colors.redAccent),
                ),
              ),
            ],
          ),
          visible: shouldShowResendButton == false ? false : true,
        )
      ],
    );
  }

  Widget verifyNowButton(BuildContext _context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 3),
        width: MediaQuery.of(context).size.width * 100,
        height: 50,
        child: RaisedButton(
            disabledColor: Colors.redAccent,
            onPressed:_isSignUpButtonClicked?null: () => {
              setState(() {
                verifyNowClicked(_context);
              })
            },
            color:_isSignUpButtonClicked?Colors.redAccent[300]: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: _isSignUpButtonClicked,
                  child: Container(
                    alignment: Alignment.center,
                    // color: ThemeColor.text_white_colour,
                    child: CircularProgressIndicator(
                      backgroundColor:
                     Colors.white,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.redAccent),
                      strokeWidth: 3,
                    ),
                    height: 25,
                    width: 25,
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: _isSignUpButtonClicked
                      ? EdgeInsets.only(left: 20)
                      : EdgeInsets.only(left: 0),
                  child: new Text(
                    _isSignUpButtonClicked
                        ? 'Please Wait'
                        : "Verify Now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Metropolismedium',
                        letterSpacing: -0.09,
                      fontWeight: FontWeight.bold,
                        color: Colors.white,
                  ),
                ),
                ),
              ],
            ))
//        child: new Text(
//          Strings.verify_now,
//          textAlign: TextAlign.center,
//          style: TextStyling.blue_button_text_style(false),
//        ),

    );
  }

  void verifyNowClicked(BuildContext _context) async{
    print(otp_code);

    // startTimer();
      if (otp_code == _receivedOTP.toString()) {
        setState(() {
          isOTPVerified = true;
          _isSignUpButtonClicked=true;
        });
        Register api=new Register();
        var statusCode=await api.RegisterUser(widget.name,widget.phn,widget.password, widget.shopName);
        if(statusCode==200)
          {
            Toast.show(
                "User registered!", context, duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
            Navigator.of(context).pushReplacement(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return LoginActivity();
              },
            ));
          }
        else if(statusCode==400) {
          Toast.show(
              "User already registered!", context, duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM);
          Navigator.of(context).pushReplacement(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return RegisterActivity();
            },
          ));
        }
        else
          {
            Toast.show(
                "Registration Failed. Invalid Phone number or password", context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
            Navigator.of(context).pushReplacement(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return RegisterActivity();
              },
            ));
          }

      } else {
        setState(() {
          isOTPVerified = false;
        });
      }
  }
}
