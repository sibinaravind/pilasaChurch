import "package:flutter/material.dart";
import '../NetworkHandler.dart';
import 'regDetailed.dart';

class EmailVertify extends StatefulWidget {
  EmailVertify({Key key, this.id, this.username}) : super(key: key);
  final String id;
  final String username;
  @override
  _EmailVertifyState createState() => _EmailVertifyState();
}

class _EmailVertifyState extends State<EmailVertify> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool vis = true;
  bool firstClick = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _codeController = TextEditingController();
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
                  codeTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    elevation: 5,
                    onPressed: () async {
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
                      "Resend Code ",
                      style: TextStyle(
                        color: Color(int.parse(titleColor)),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      setState(() {
                        circular = true;
                      });
                      Map<String, String> data = {
                        "_id": widget.id,
                        "code": _codeController.text,
                      };
                      var response = await networkHandler.post(
                          "/church/verify-email", data);

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => RegDetailed(
                                    id: widget.id,
                                  )),
                        );
                      } else {
                        setState(() {
                          validate = false;
                          errorText = 'code not match';
                          circular = false;
                        });
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
                                "Verify Email",
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
        if (value.isEmpty) return "Code can't be empty";
        if (value.length < 6) return "Incorrect code";

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
        helperText: "Enter the code got on email",
      ),
    );
  }
}
