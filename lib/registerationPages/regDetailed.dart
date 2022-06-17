import "package:flutter/material.dart";
import '../NetworkHandler.Dart';
import 'regImage.dart';

class RegDetailed extends StatefulWidget {
  RegDetailed({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _RegDetailedState createState() => _RegDetailedState();
}

class _RegDetailedState extends State<RegDetailed> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  final networkHandler = NetworkHandler();
  bool circular = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _globalKey =
      GlobalKey<FormState>(); // the global key only validater the form widget
  TextEditingController _priestName = TextEditingController();
  TextEditingController _priestPhone = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _nation = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _about = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                  "More about the church",
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
                priestNameTextField(),
                SizedBox(
                  height: 20,
                ),
                priestPhoneTextField(),
                SizedBox(
                  height: 20,
                ),
                districtTextField(),
                SizedBox(
                  height: 20,
                ),
                stateTextField(),
                SizedBox(
                  height: 20,
                ),
                nationTextField(),
                SizedBox(
                  height: 20,
                ),
                pincodeTextField(),
                SizedBox(
                  height: 20,
                ),
                aboutTextField(),
                SizedBox(
                  height: 20,
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
                        "_id": widget.id,
                        "priestName": _priestName.text,
                        "priestPhone": _priestPhone.text,
                        "district": _district.text,
                        "state": _state.text,
                        "nation": _nation.text,
                        "pincode": _pincode.text,
                        "about": _about.text
                      };
                      var response =
                          await networkHandler.post("/church/register2", data);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => RegImage(id: widget.id)),
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
                            : Text("Next",
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
            labelText: "Priest Name"));
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
            helperText: "collecting only for church Verification"));
  }

  Widget districtTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "District can't be  empty";
          return null;
        },
        controller: _district,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "District",
        ));
  }

  Widget stateTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "State can't be  empty";

          return null;
        },
        controller: _state,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "State",
        ));
  }

  Widget nationTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Nation can't be  empty";

          return null;
        },
        controller: _nation,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
            width: 10.0,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Nation",
        ));
  }

  Widget pincodeTextField() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) return "Pincode Number Can't be empty";
          return null;
        },
        controller: _pincode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 3)),
          helperStyle: TextStyle(color: Colors.grey[400]),
          labelText: "Pincode",
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
            hintText: "Tell  something about church or a Short Description "));
  }
}
