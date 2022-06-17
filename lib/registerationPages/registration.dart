import 'dart:convert';

import "package:flutter/material.dart";
import 'emailVerify.dart';
import '../NetworkHandler.Dart';
import 'package:geolocator/geolocator.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool vis = true;
  bool validate = false;
  String errorText;
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  final networkHandler = NetworkHandler();
  bool circular = false;
  bool rememberMe = false;
  String latitudeData = "";
  String longtitudeData = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _globalKey =
      GlobalKey<FormState>(); // the global key only validater the form widget
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _rePassword = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _churchName = TextEditingController();
  TextEditingController _place = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData = '${geoposition.latitude}';
      longtitudeData = '${geoposition.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(int.parse(bgColor)),
        body: Form(
          key: _globalKey, //pass the global key for validation
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              children: <Widget>[
                SizedBox(height: 25),
                Text(
                  "Registration",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(int.parse(titleColor))),
                ),
                SizedBox(
                  height: 20,
                ),
                usernameTextField(),
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
                churchNameTextField(),
                SizedBox(
                  height: 20,
                ),
                placeTextField(),
                SizedBox(
                  height: 20,
                ),
                phoneTextField(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      focusColor: Colors.grey,
                      checkColor: Colors.green,
                      activeColor: Color(int.parse(bgColor)),
                      value: rememberMe,
                      onChanged: (newValue) {
                        setState(
                            () => {rememberMe = newValue, circular = false});
                      },
                    ),
                    InkWell(
                        onTap: () => {showAlertDialog(context)},
                        child: Text(
                          "Terms And Conditions",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (rememberMe == false) {
                      circular = false;
                      // ignore: deprecated_member_use
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.red[300],
                          content: Text(
                            'Accept Terms And condition before Proceed',
                          ),
                          duration: Duration(seconds: 2)));
                      return null;
                    }
                    setState(() {
                      circular = true;
                    });
                    if (_globalKey.currentState.validate()) {
                      Map<String, String> username = {
                        "username": _username.text.trim(),
                        "churchName": _churchName.text,
                      };
                      Map<String, String> data = {
                        "username": _username.text.trim(),
                        "password": _password.text,
                        "churchName": _churchName.text,
                        "phone": _phone.text,
                        "place": _place.text,
                        "latitude": latitudeData,
                        "longtitude": longtitudeData
                      };
                      var response = await networkHandler.post(
                          "/church/checkexistence", username);
                      Map<String, dynamic> result = json.decode(response.body);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        var res = await networkHandler.post(
                            "/church/register1", data);
                        if (res.statusCode == 200 || res.statusCode == 201) {
                          Map<String, dynamic> output = json.decode(res.body);
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EmailVertify(
                                    id: output["_id"],
                                    username: _username.text)),
                          );
                        } else {
                          setState(() {
                            circular = false;
                          });
                        }
                      } else {
                        setState(() {
                          circular = false;
                        });
                        if (response.statusCode == 403 ||
                            response.statusCode == 500) {
                          // ignore: deprecated_member_use
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.red[300],
                              content: Text(result["msg"]),
                              duration: Duration(seconds: 2)));
                        }
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
                            : Text("Register",
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

  Widget usernameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Email can't be empty cant be  empty";
          if ((!value.contains("@")) || (!value.contains(".")))
            return "Invalid Email id";
          return null;
        },
        controller: _username,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Email Id",
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
          labelText: "Set Password",
        ));
  }

  Widget rePasswordTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Password can't be  empty";
          if (value != _password.text) return "Password must be same";
          return null;
        },
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
          labelText: "repassword",
        ));
  }

  Widget churchNameTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Church Name can't be  empty";

          return null;
        },
        controller: _churchName,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300], width: 3)),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "Church Name",
            hintText: "eg:St Judes Church Mavullal "));
  }

  Widget placeTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Place can't be  empty";

          return null;
        },
        controller: _place,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Place",
        ));
  }

  Widget phoneTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "phone Number can't be  empty";
          if (value.length < 10) return "please enter valid phone Number";
          return null;
        },
        controller: _phone,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "phone",
          helperText:
              "Which will display to Pilasa users to connect to church. recommended to add",
        ));
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  // ignore: deprecated_member_use
  Widget okButton = FlatButton(
    color: Colors.green,
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Pilasa Terms And Conditions",
      style: TextStyle(
          color: Color(0xffaa3a3a), fontWeight: FontWeight.bold, fontSize: 16),
    ),
    content: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome to pilasa ",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff30384c),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "             This is an spiritual platform for Christian community. through this we intent to connect believers with the priest  and the church to follow Jesus. So priests can easily pass spiritual contents to devotees of God and it will help them to inhabit with Jesus.",
            style: TextStyle(fontSize: 14, color: Color(0xff30384c)),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "               This is an admin level application for Pilasa application. Pilasa is an application used to connect the believers with churches.",
            style: TextStyle(fontSize: 14, color: Color(0xff30384c)),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "             pilasa is brought to you by Ae Software Consultancy Solution. It’s a startup company focusing on development of mobile applications, web development, digital marketing and software consulting etc...",
            style: TextStyle(fontSize: 14, color: Color(0xff30384c)),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "                If you continue to use this Application, you are agreeing to comply with and be bound by the following terms and conditions of use. If you disagree with any part of these terms and conditions, please do not use our Application.",
            style: TextStyle(fontSize: 14, color: Color(0xff30384c)),
          ),
          SizedBox(
            height: 9,
          ),
          Text("The Services we provide",
              style: TextStyle(
                  color: Color(0xffaa3a3a),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          SizedBox(
            height: 9,
          ),
          Text(
            "1) Holy Mass Booking: Use it for pre booking of Holy Mass with special intention and normal. You can see the details of the already booked persons.\n 2)	Announcement: You can share announcement for the  parishioners.\n3)	Publish Post: You can easily share messages and spiritual content through the post.",
            style: TextStyle(fontSize: 14, color: Color(0xff30384c)),
          ),
          SizedBox(
            height: 5,
          ),
          Text("Terms And Conditions & Privacy Policies",
              style: TextStyle(
                  color: Color(0xffaa3a3a),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          SizedBox(
            height: 4,
          ),
          Text(
            " 1)	All rights reserved under pilasa developer.\n 2)	We will check the authenticity of the church before activating it. This will take a maximum of 7 days.\n3)	At the time of registration we collecting the church name, location, email address, password, contact information (phone number), church address (district, state, nation, zip code or zip code), church location, church priest information (name, phone number) , Short description(about), church Image, letter pad Image.\n4)	We collect a lot of information to protect Pilasa from abusers.\n5)	Uses email address to make your profile unique. The email id and password are the login credentials of your account.\n6)	Your data is completely secure as we store it in a password encrypted format.\n7)	The Church name, place, about and picture of the church will be displayed on the profile screen.\n8)	We require Gps location permission to locate the church.It will help believers to find the nearest church.\n9)	Setting your phone location as a church location. \n10)	Contact information, priest information and address details are used to verify the authenticity of the registered church. We will personally check this before activating the account.\n11)	Letter pad Image and church Image are not mandatory. This will speed up the verification if you upload.\n12)	About field is also not a mandatory field. Other than about filed all the fields are mandatory require to register with pilasa.\n13)	We will also use the state and nation to distinguish the data to present to user and storing purpose.\n14)	We do not display personal and contact information in public without authorized confirmation.\n15)	You can post content under your profile.\n16)	All posts will be automatically remove after 7 days.\n17)	There is no like and comment option for posts here.\n18)	You can only add holy mass for the next 7 days \n19)	You can only see bookings for the last 7 days.\n20)	We collect the date, time and language of the Holy Mass to be displayed to the believer.\n21)	You will get the names and phone numbers of the believers who book for the Holy Mass. Do not abuse those details. If we detect any misuse of such data, your account will be terminated permanently.\n22)	We have the right to remove the account without giving notice if any fraudulent activity is detected.\n23)	You can delete the account at any time. Once you have deleted the account, you will not be able to create more accounts with similar details without developer permission and verification.",
            style: TextStyle(fontSize: 14, color: Color(0xff30384c)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "For any help Contact pilasa.ae@gmail.com",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Enjoy Pilasa",
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    ),
    actions: [
      okButton,
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
