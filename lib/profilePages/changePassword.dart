import 'dart:convert';

import "package:flutter/material.dart";
import 'package:pilasa_church/registerationPages/signInPage.dart';
import '../NetworkHandler.Dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasword extends StatefulWidget {
  @override
  _ChangePaswordState createState() => _ChangePaswordState();
}

class _ChangePaswordState extends State<ChangePasword> {
  bool vis = true;
  bool vis1 = true;
  bool validate = false;
  String errorText;
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  final networkHandler = NetworkHandler();
  bool circular = false;
  final storage = FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _globalKey =
      GlobalKey<FormState>(); // the global key only validater the form widget
  TextEditingController _currentPasword = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _rePassword = TextEditingController();
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(int.parse(titleColor)),
          title: Text(" Change Password"),
          centerTitle: true,
        ),
        backgroundColor: Color(int.parse(bgColor)),
        body: Center(
          child: Form(
            key: _globalKey, //pass the global key for validation
            child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  currentPasswordField(),
                  SizedBox(
                    height: 20,
                  ),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  rePasswordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                      });
                      if (_globalKey.currentState.validate()) {
                        Map<String, String> data = {
                          "currpassword": _currentPasword.text,
                          "password": _password.text,
                        };
                        var response = await networkHandler.post(
                            "/church/change-password", data);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          setState(() {
                            circular = false;
                          });
                          await storage.delete(key: "token");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                              (route) => false);
                        } else if (response.statusCode == 403 ||
                            response.statusCode == 500) {
                          Map<String, dynamic> result =
                              json.decode(response.body);
                          setState(() {
                            circular = false;
                          });
                          // ignore: deprecated_member_use
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.red[300],
                              content: Text(result["msg"]),
                              duration: Duration(seconds: 2)));
                        }
                      } else {
                        setState(() {
                          circular = false;
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(int.parse(titleColor)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: circular
                              ? CircularProgressIndicator()
                              : Text("Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ));
  }

  Widget currentPasswordField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "password can't be  empty";
          if (value.length < 8) return "Invalid Password";
          if (value == _password.text) return "Set a new Password";
          return null;
        },
        //autovalidate: true,
        obscureText: vis1,
        controller: _currentPasword,
        decoration: InputDecoration(
          errorText: validate ? null : errorText,
          suffixIcon: IconButton(
              color: Color((int.parse(titleColor))),
              icon: Icon(vis1 ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis1 = !vis1;
                });
              }),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Current Password",
        ));
  }

  Widget passwordTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "password can't be  empty";
          if (value.length < 8)
            return "password must contain  min of 8  character";
          return null;
        },
        //  autovalidate: true,
        obscureText: vis,
        controller: _password,
        decoration: InputDecoration(
          errorText: validate ? null : errorText,
          suffixIcon: IconButton(
              color: Color((int.parse(titleColor))),
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              }),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "New Password",
        ));
  }

  Widget rePasswordTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Password can't be  empty";
          if (value != _password.text) return "Password must be same";
          return null;
        },
        //: true,
        obscureText: vis,
        controller: _rePassword,
        decoration: InputDecoration(
          errorText: validate ? null : errorText,
          suffixIcon: IconButton(
              color: Color((int.parse(titleColor))),
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              }),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Reenter password",
        ));
  }
}
