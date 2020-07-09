import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/auth/login/api/LoginApi.dart';
import 'package:my_app/screens/homescreen/HomeScreen.dart';
import 'package:toast/toast.dart';
import 'package:my_app/HomePage.dart';
import 'package:my_app/auth/register/widget/RegisterActivity.dart';
import 'package:my_app/common/widgets/ReusableTextBox.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {

  bool _isLoading = false;
  final TextEditingController phnController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  void loginResult(var response)
  {
    if (response != null) {
      setState(() {
        _isLoading = false;
      });
      Toast.show(
          "Welcome!", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => HomePage()), (
          Route<dynamic> route) => false);
    }
    else {
      setState(() {
        _isLoading = false;
        phnController.text = '';
        passwordController.text = '';
      });
      Toast.show(
          "Login Failed!", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red[200]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(),)
            : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }


  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          ReusableTextBox(phnController,Icons.phone,'Phone Number'),
          SizedBox(height: 30.0),
          ReusableTextBox(passwordController,Icons.lock,'Password',true),
        ],
      ),
    );
  }

  Container buttonSection() {
    return Container(

        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.white,
              onPressed: () async{
//                print(phnController.text);
//                print(passwordController.text);
                if ((phnController.text != "") &&
                    (passwordController.text != "")) {
                  setState(() {
                    _isLoading = true;
                  });
                  LoginApi api = new LoginApi();
                  var response = await api.LogIn(
                      phnController.text, passwordController.text);
                  loginResult(response);

                }
              },
              child: Text("Sign In", style: TextStyle(color: Colors.black)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => RegisterActivity()));
              },
              child: Text("Register", style: TextStyle(color: Colors.black)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ],
        )

    );
  }



}


