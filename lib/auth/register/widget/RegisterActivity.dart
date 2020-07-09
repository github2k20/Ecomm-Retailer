import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:my_app/auth/login/widget/LoginActivity.dart';
import 'package:my_app/common/widgets/ReusableTextBox.dart';
import 'package:my_app/auth/register/api/RegisterApi.dart';
import 'package:my_app/auth/register/widget/OtpActivity.dart';

class RegisterActivity extends StatefulWidget {
  @override
  _RegisterActivityState createState() => _RegisterActivityState();
}

class _RegisterActivityState extends State<RegisterActivity> {

  bool _isLoading = false;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController shopNameController = new TextEditingController();
  final TextEditingController phnController = new TextEditingController();


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
            ? Center(child: CircularProgressIndicator())
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
      child: Text("Register",
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
          ReusableTextBox(nameController,Icons.perm_identity, "Name"),
          SizedBox(height: 30.0),
          ReusableTextBox(shopNameController,Icons.edit, "Shop Name"),
          SizedBox(height: 30.0),
          ReusableTextBox(phnController,Icons.phone, "Phone Number"),
          SizedBox(height: 30.0),
          ReusableTextBox(passwordController,Icons.lock, "Password",true),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Container buttonSection() {
    return Container(
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
      child: RaisedButton(
        color: Colors.white,
        onPressed: () async{
          if ((phnController.text != "") && (nameController.text != "") &&
              (passwordController.text != "") &&
              (shopNameController.text != "")) {
            setState(() {
              _isLoading = true;
            });
            Register api= new Register();
            int otp=await api.getOTP( phnController.text);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) => RegisterOTP(phnController.text,otp,nameController.text, phnController.text,passwordController.text, shopNameController.text)), (
                Route<dynamic> route) => false);
//           var responseCode= await api.RegisterUser(nameController.text, phnController.text,
//                passwordController.text, shopNameController.text);
//           registerResult(responseCode);
          }
          else {
            Toast.show(
                "Registration Failed. Invalid Phone number or password", context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
            setState(() {
              _isLoading = false;
              nameController.text = '';
              phnController.text = '';
              passwordController.text = '';
              shopNameController.text = '';
            });
          }
        },
        child: Text("Register", style: TextStyle(color: Colors.black)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

}



