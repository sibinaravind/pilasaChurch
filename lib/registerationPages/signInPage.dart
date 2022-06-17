import 'dart:convert';
import "package:flutter/material.dart";
import 'registration.dart';
import 'emailVerify.dart';
import 'regDetailed.dart';
import 'regImage.dart';
import 'forgetPassword.dart';
import '../NetworkHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../mainPages/homePage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool vis = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage =
      new FlutterSecureStorage(); // creating instance for secure storage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  SizedBox(
                    height: 20,
                  ),
                  usernameTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  passwordTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ))
                        },
                        child: Text(
                          "Forgot Password ?",
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Registration(),
                          ));
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
                        setState(() {
                          circular = false;
                          validate = false;
                        });

                        Map<String, String> data = {
                          "username": _usernameController.text,
                          "password": _passwordController.text,
                        };
                        var response =
                            await networkHandler.post("/church/login", data);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          await storage.write(
                              key: "token", value: output["token"]);
                          setState(() {
                            validate = true;
                            circular = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (route) => false);
                        } else {
                          Map<String, dynamic> output =
                              json.decode(response.body);
                          setState(() {
                            validate = false;
                            circular = false;
                          });
                          if (response.statusCode == 403) {
                            if (output["lvl"] == "1") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EmailVertify(
                                        id: output["_id"],
                                        username: _usernameController.text)),
                              );
                            } else if (output["lvl"] == "2") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => RegDetailed(
                                          id: output["_id"],
                                        )),
                              );
                            } else if (output["lvl"] == "3") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegImage(id: output["_id"])),
                              );
                            } else if (output["status"] == "inactive") {
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  backgroundColor: Colors.green[400],
                                  content: Text(
                                      "Church Verification under process. for more, contact pilasa.a@gmail.com"),
                                  duration: Duration(seconds: 5)));
                            } else if (output["status"] == "deleted") {
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  backgroundColor: Colors.red[400],
                                  content: Text(
                                      "your account has been Deleted. Contact pilasa.ae@gmail.com for more information"),
                                  duration: Duration(seconds: 5)));
                            } else if (output["status"] == "block") {
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  backgroundColor: Colors.red[400],
                                  content: Text(
                                      "your account has been Blocked. Contact pilasa.ae@gmail.com for more information"),
                                  duration: Duration(seconds: 5)));
                            }
                          }
                          if (response.statusCode == 500) {
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text("Invalid Username or password"),
                                duration: Duration(seconds: 2)));
                          }
                        }
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
                                "Sign In",
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
        if (value.isEmpty) return "email id can't be empty";
        if ((!value.contains("@")) || (!value.contains(".")))
          return "Invalid email id id";
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
        labelText: "Email",
      ),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value.isEmpty) return "Password can't be empty";
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
        labelText: "password",
      ),
    );
  }
}
