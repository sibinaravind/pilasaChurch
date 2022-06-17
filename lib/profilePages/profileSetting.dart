import "package:flutter/material.dart";
import '../NetworkHandler.Dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../registerationPages/signInPage.dart';

class ProfileSetting extends StatefulWidget {
  ProfileSetting({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  final networkHandler = NetworkHandler();
  final storage = FlutterSecureStorage();
  bool circular = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _globalKey =
      GlobalKey<FormState>(); // the global key only validater the form widget
  TextEditingController _phone = TextEditingController();
  TextEditingController _priestName = TextEditingController();
  TextEditingController _priestPhone = TextEditingController();
  TextEditingController _about = TextEditingController();
  TextEditingController _email = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    var response = await networkHandler.get("/church/update-church");
    Map<String, dynamic> output = response;
    setState(() {
      _phone.text = output["phone"];
      _about.text = output["about"];
      _priestName.text = output["priestName"];
      _priestPhone.text = output["priestPhone"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(int.parse(titleColor)),
          title: Text('Profile Settings'),
          centerTitle: true,
        ),
        backgroundColor: Color(int.parse(bgColor)),
        body: Form(
          key: _globalKey, //pass the global key for validation
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              children: <Widget>[
                Text(
                  "Update Details",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(int.parse(titleColor))),
                ),
                SizedBox(
                  height: 5,
                ),
                churchPhoneTextField(),
                SizedBox(
                  height: 5,
                ),
                priestNameTextField(),
                SizedBox(
                  height: 5,
                ),
                priestPhoneTextField(),
                SizedBox(
                  height: 5,
                ),
                aboutTextField(),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    setState(() {
                      circular = true;
                    });
                    if (_globalKey.currentState.validate()) {
                      Map<String, String> data = {
                        "phone": _phone.text,
                        "priestName": _priestName.text,
                        "priestPhone": _priestPhone.text,
                        "about": _about.text
                      };
                      var response = await networkHandler.post(
                          "/church/update-church", data);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        // ignore: deprecated_member_use
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.green[400],
                            content: Text("Successfully updated"),
                            duration: Duration(seconds: 2)));
                        setState(() {
                          circular = false;
                        });
                      } else {
                        // ignore: deprecated_member_use
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.red[400],
                            content: Text("Failed to update. Try later"),
                            duration: Duration(seconds: 2)));
                        setState(() {
                          circular = false;
                        });
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
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
                            : Text("Update Details",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 3,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Delete Account",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(int.parse(titleColor))),
                ),
                Text(
                  "                  If sure, please enter your registered email address in the text field below",
                  style: TextStyle(
                      fontSize: 12, letterSpacing: 2, color: Colors.grey),
                ),
                emailTextField(),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    final ConfirmAction action = await _asyncConfirmDialog(
                        context,
                        'Delete Account',
                        'Do you want to leave the Pilasa family?',
                        'Delete Account');
                    if (action == ConfirmAction.Accept) {
                      print("Haiii");
                      Map<String, String> datas = {
                        "username": _email.text,
                      };
                      var response = await networkHandler.post(
                          "/church/deleteAccount", datas);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        await storage.delete(key: "token");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                            (route) => false);
                      } else {
                        // ignore: deprecated_member_use
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.red[400],
                            content:
                                Text("Failed to delete Account. try later"),
                            duration: Duration(seconds: 2)));
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(int.parse(titleColor)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text("Delete Account",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                )
              ]),
        ));
  }

  Widget churchPhoneTextField() {
    return TextFormField(
        controller: _phone,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Church Phone Number",
          helperText:
              "You can make it empty, if not interested to display to pilasa Users",
        ));
  }

  Widget priestNameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Priest Name can't be empty ";
          return null;
        },
        controller: _priestName,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Priest Name",
        ));
  }

  Widget priestPhoneTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "phone Number can't be  empty";
          if (value.length < 10) return "please enter valid phone Number";
          return null;
        },
        controller: _priestPhone,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Priest Phone Number",
        ));
  }

  Widget aboutTextField() {
    return TextFormField(
        controller: _about,
        maxLines: 2,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300], width: 3)),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "About",
            hintText: "Tell  something about church "));
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _email,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color((int.parse(titleColor))),
            width: 2,
          ),
        ),
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
        labelText: "Registed Email Id",
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
