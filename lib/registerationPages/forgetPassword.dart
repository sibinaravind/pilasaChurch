import 'dart:convert';
import "package:flutter/material.dart";
import '../NetworkHandler.dart';
import 'resetPassword.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Image.asset("assets/pilasaLogo.png"),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Forget Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(int.parse(titleColor)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  usernameTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        validate = false;
                        circular = false;
                      });
                      Map<String, String> data = {
                        "username": _usernameController.text,
                      };
                      var response = await networkHandler.post(
                          "/church/forget-password", data);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Map<String, dynamic> output =
                            json.decode(response.body);
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResetPassword(
                              id: output["_id"],
                              username: _usernameController.text),
                        ));
                      } else {
                        Map<String, dynamic> output =
                            json.decode(response.body);
                        setState(() {
                          validate = false;
                          errorText = output["msg"];
                          circular = false;
                        });
                      }
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
                                "Send OTP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameTextField() {
    return TextFormField(
      controller: _usernameController,
      validator: (value) {
        if (value.isEmpty) return "Email can't be empty";
        if ((!value.contains("@")) || (!value.contains(".")))
          return "Invalid Email id";
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
        labelText: "Email Id",
        helperText: "you will get Reset code in email",
      ),
    );
  }
}
