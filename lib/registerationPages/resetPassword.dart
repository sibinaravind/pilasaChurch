import 'dart:convert';
import "package:flutter/material.dart";
import 'registration.dart';
import '../NetworkHandler.dart';
import 'signInPage.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key, this.id, this.username}) : super(key: key);
  final String id;
  final String username;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();
  bool firstClick = true;
  String errorText;
  bool validate = false;
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(int.parse(bgColor)),
          ),
          child: Form(
            key: _globalkey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Image.asset("assets/pilasaLogo.png"),
                  ),
                  SizedBox(height: 30),
                  // Text(
                  //   "Sign In",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.bold,
                  //     letterSpacing: 2,
                  //     color: Color(int.parse(titleColor)),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  codeTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  rePasswordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (firstClick) {
                            Map<String, String> data = {
                              "username": widget.username,
                            };
                            setState(() {
                              firstClick = false;
                              circular = false;
                            });
                            var response = await networkHandler.post(
                                "/church/resendCode", data);
                            if (response.statusCode != 200) {
                              setState(() {
                                firstClick = true;
                              });
                            } else {
                              setState(() {
                                firstClick = true;
                              });
                            }
                          }
                        },
                        child: Text(
                          "Resend Code?",
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registration()));
                        },
                        child: Text(
                          "New User?",
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        circular = true;
                        print(circular);
                      });
                      if (_globalkey.currentState.validate()) {
                        Map<String, String> data = {
                          "_id": widget.id,
                          "code": _codeController.text,
                          "password": _passwordController.text,
                        };
                        var response = await networkHandler.post(
                            "/church/reset-password", data);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          showAlertDialog(context);
                          setState(() {
                            validate = true;
                            circular = false;
                          });
                        } else {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          setState(() {
                            validate = false;
                            errorText = output["msg"];
                            circular = false;
                          });
                        }
                      }
                      // login logic End here
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(int.parse(titleColor)),
                      ),
                      child: Center(
                        child: circular
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white70,
                              )
                            : Text(
                                "Reset",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  // Divider(
                  //   height: 50,
                  //   thickness: 1.5,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget codeTextField() {
    return TextFormField(
      controller: _codeController,
      validator: (value) {
        if (value.isEmpty) return "code ";
        return null;
      },
      decoration: InputDecoration(
          errorText: validate ? null : errorText,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color((int.parse(titleColor))),
              width: 2,
            ),
          ),
          labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
          labelText: "Code",
          helperText: "Enter the Code Got in email"),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value.isEmpty) return "Password can't be empty";
        if (value.length < 8)
          return "Password should conatin min of 8 character";
        return null;
      },
      obscureText: vis,
      decoration: InputDecoration(
        errorText: validate ? null : errorText,
        suffixIcon: IconButton(
          color: Color((int.parse(titleColor))),
          icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              vis = !vis;
            });
          },
        ),
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color((int.parse(titleColor))),
            width: 2,
          ),
        ),
        labelText: "New password",
      ),
    );
  }

  Widget rePasswordTextField() {
    return TextFormField(
      controller: _rePasswordController,
      validator: (value) {
        if (value.isEmpty) return "Password can't be empty";
        if (value != _passwordController.text) return "Password Should be Same";
        return null;
      },
      obscureText: vis,
      decoration: InputDecoration(
        errorText: validate ? null : errorText,
        suffixIcon: IconButton(
          color: Color((int.parse(titleColor))),
          icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              vis = !vis;
            });
          },
        ),
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color((int.parse(titleColor))),
            width: 2,
          ),
        ),
        labelText: "Re enter Password",
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 10,
      title: Text('Pilasa'),
      contentTextStyle: TextStyle(
          color: Color(int.parse(titleColor)),
          fontSize: 16,
          fontWeight: FontWeight.bold),
      content: const Text(
          '  Your password is Successfully updated . Enjoy our service'),
      actions: <Widget>[
        // ignore: deprecated_member_use
        RaisedButton(
            elevation: 5,
            color: Colors.blue,
            child: const Text(
              'Ok',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false);
            }),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
