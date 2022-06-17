import 'package:pilasa_church/posts/addBlog.dart';
import "package:flutter/material.dart";
import 'package:pilasa_church/profilePages/changePassword.dart';
import '../profilePages/profileSetting.dart';
import 'profieScreen.dart';
import 'homeScreen.dart';
import 'package:pilasa_church/profilePages/paymentUpdate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../registerationPages/signInPage.dart';
import 'package:pilasa_church/NetworkHandler.Dart';
import 'package:pilasa_church/profilePages/accountAdd.dart';
import 'package:pilasa_church/profilePages/paymentRequests.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  NetworkHandler networkhandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  final storage = FlutterSecureStorage();
  String username = "";
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  @override
  void initState() {
    super.initState();
    // checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 50,
        child: ListView(
          children: <Widget>[
            ListTile(
                title: Text(
                  "Profile Setting",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(
                  Icons.settings,
                  color: Color(int.parse(titleColor)),
                  size: 30,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileSetting()));
                }),
            ListTile(
                title: Text(
                  "Change Password",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(
                  Icons.security,
                  color: Color(int.parse(titleColor)),
                  size: 30,
                ),
                onTap: () {
                  // changePasswordDialog1(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangePasword()));
                }),
            ListTile(
                title: Text(
                  "My Payment Requests",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(
                  Icons.format_list_bulleted,
                  color: Color(int.parse(titleColor)),
                  size: 30,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentRequests()));
                }),
            ListTile(
                title: Text(
                  "Payment Setting",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(
                  Icons.payment,
                  color: Color(int.parse(titleColor)),
                  size: 30,
                ),
                onTap: () async {
                  var response =
                      await networkhandler.get("/church/CheckPaymentAccount");
                  // var result = json.decode(response.body);
                  // print(result);
                  if (response == "Actiavted") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentUpdate()));
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AccountAdd()));
                  }
                }),
            ListTile(
              title: Text(
                "Feedback",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(
                Icons.feedback,
                color: Color(int.parse(titleColor)),
                size: 30,
              ),
              onTap: () {
                showAlertDialog(context, "Feedback",
                    "We are happy to hear your feedback.You can send Feedback Directly to");
              },
            ),
            ListTile(
              title: Text(
                "About us",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(Icons.developer_board,
                  color: Color(int.parse(titleColor)), size: 30),
              onTap: () {
                showAlertDialog1(context);
              },
            ),
            ListTile(
              title: Text(
                "Help",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(Icons.help,
                  color: Color(int.parse(titleColor)), size: 30),
              onTap: () {
                showAlertDialog(context, "Help",
                    'We are happy to Help You. You can Contact us on');
              },
            ),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(Icons.power_settings_new,
                  color: Color(int.parse(titleColor)), size: 30),
              onTap: () {
                logout();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        excludeHeaderSemantics: true,
        brightness: Brightness.light,
        // automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Color(int.parse(titleColor)), opacity: 30, size: 40),
        backgroundColor: Color(int.parse(bgColor)),
        // flexibleSpace: Image.asset(
        //   "assets/pilasaLogo2.png",
        //   fit: BoxFit.contain,
        // ),
        title: Image.asset("assets/pilasaLogo2.png"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(int.parse(titleColor)),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Icon(Icons.add, size: 40),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Color(int.parse(titleColor)),
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.home),
                      color: currentState == 0 ? Colors.white : Colors.white54,
                      onPressed: () {
                        setState(() {
                          currentState = 0;
                        });
                      },
                      iconSize: 30),
                  IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        setState(() {
                          currentState = 1;
                        });
                      },
                      color: currentState == 1 ? Colors.white : Colors.white54,
                      iconSize: 30)
                ],
              ),
            ),
          )),
      body: widgets[currentState],
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
        (route) => false);
  }
}

class AccountUpdate {}

showAlertDialog(BuildContext context, String title, String content) {
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
      title,
      style: TextStyle(color: Color(0xffaa3a3a)),
    ),
    content: Column(
      children: <Widget>[
        Expanded(
            child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: Image.asset("assets/pilasaLogo.png"))),
        Center(
            child: Text(
          content,
          style: TextStyle(fontSize: 16, color: Color(0xff30384c)),
        )),
        SizedBox(
          height: 10,
        ),
        Text(
          "pilasa.ae@gmail.com",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
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

showAlertDialog1(BuildContext context) {
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
      " About Us",
      style: TextStyle(
          color: Color(0xffaa3a3a), fontWeight: FontWeight.bold, fontSize: 25),
    ),
    content: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "         Pilasa is developed and Managed by ",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff30384c),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Ae software consultancy Solution",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.deepOrange),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          " Pilasa is our first project and we are Focusing on Mobile App Developement,web Development , Digital Marketing and Software Consulting",
          style: TextStyle(fontSize: 16, color: Color(0xff30384c)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          " Contact us through",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff30384c)),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "pilasa.ae@gmail.com",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
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
