import "package:flutter/material.dart";
import '../NetworkHandler.dart';
import 'package:pilasa_church/profilePages/paymentAdd.dart';

class AccountAdd extends StatefulWidget {
  @override
  _AccountAddState createState() => _AccountAddState();
}

class _AccountAddState extends State<AccountAdd> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _accountNumController = TextEditingController();
  TextEditingController _reaccountNumController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();
  bool firstClick = true;
  String errorText;
  bool validate = false;
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(int.parse(titleColor)),
        title: Text(
          "Payment Account",
        ),
        centerTitle: true,
      ),
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
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  nameTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  accountTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  reaccountTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  ifscTextField(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "NB: The bank details you provide will be used to provide you. Please check the details before proceeding ",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    // onTap: () async {
                    //   print("haiii");
                    //   setState(() {
                    //     circular = true;
                    //     print(circular);
                    //   });
                    //   if (_globalkey.currentState.validate()) {
                    //     Map<String, String> data = {
                    //       // "_id": widget.id,
                    //       // "code": _codeController.text,
                    //       // "password": _passwordController.text,
                    //     };
                    //     var response = await networkHandler.post(
                    //         "/church/reset-password", data);
                    //     if (response.statusCode == 200 ||
                    //         response.statusCode == 201) {
                    //       // showAlertDialog(context);
                    //       setState(() {
                    //         validate = true;
                    //         circular = false;
                    //       });
                    //     } else {
                    //       Map<String, dynamic> output =
                    //           json.decode(response.body);
                    //       setState(() {
                    //         validate = false;
                    //         errorText = output["msg"];
                    //         circular = false;
                    //       });
                    //     }
                    //   }
                    // login logic End here
                    // },
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
                              : InkWell(
                                  onTap: () async {
                                    if (_globalkey.currentState.validate()) {
                                      final ConfirmAction action =
                                          await _asyncConfirmDialog(
                                              context,
                                              'Insert Account',
                                              'Recommend cross-checking the values before proceeding',
                                              'Confirm');
                                      print("Confirm Action $action");
                                      if (action == ConfirmAction.Accept) {
                                        Map<String, String> data = {
                                          "accNo": _accountNumController.text,
                                          "accName": _nameController.text,
                                          "ifsc": _ifscController.text
                                        };
                                        var response =
                                            await networkHandler.post(
                                                "/church/updatePaymentaccount",
                                                data);
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentAdd()));
                                        } else {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      Colors.red[400],
                                                  content: Text(
                                                      "Process failed try later"),
                                                  duration:
                                                      Duration(seconds: 5)));
                                        }
                                      }
                                    }
                                  },
                                  child: Center(
                                    child: Text("Insert Account",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )),
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

  Widget nameTextField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) {
        if (value.isEmpty) return "Name Can't be empty ";
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
        labelText: "Account Holder Name",
      ),
    );
  }

  Widget accountTextField() {
    return TextFormField(
      controller: _accountNumController,
      validator: (value) {
        if (value.isEmpty) return "Account Number can't be empty";
        if (value.length < 8) return "Please enter the Valid input";
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        errorText: validate ? null : errorText,
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color((int.parse(titleColor))),
            width: 2,
          ),
        ),
        labelText: "Account Number",
      ),
    );
  }

  Widget reaccountTextField() {
    return TextFormField(
      controller: _reaccountNumController,
      validator: (value) {
        if (value.isEmpty) return "Account number can't be empty";
        if (value != _accountNumController.text)
          return "Account number Should be Same";
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        errorText: validate ? null : errorText,
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color((int.parse(titleColor))),
            width: 2,
          ),
        ),
        labelText: "Re enter Account number",
      ),
    );
  }

  Widget ifscTextField() {
    return TextFormField(
      controller: _ifscController,
      validator: (value) {
        if (value.isEmpty) return "IFSC code can't be empty";
        return null;
      },
      // obscureText: vis,
      decoration: InputDecoration(
        errorText: validate ? null : errorText,
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color((int.parse(titleColor))),
            width: 2,
          ),
        ),
        labelText: "IFSC code",
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept }
Future<ConfirmAction> _asyncConfirmDialog(
    BuildContext context, String title, String body, String btnText) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Color(0xffaa3a3a)),
        ),
        content: Text("              " + body),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(width: 3, color: Colors.blue[200])),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(width: 3, color: Colors.blue[200])),
            child: Text(btnText),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}
