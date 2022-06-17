import 'dart:async';
import 'package:flutter/material.dart';
import 'registerationPages/signInPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'mainPages/homePage.dart';
import './networkHandler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  NetworkHandler networkHandler = NetworkHandler();
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  Widget page = SignInPage();
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkLogin();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => page)));
  }

  void checkLogin() async {
    String token = await storage.read(
        key:
            "token"); // check the tocken is available or not and go to home page

    if (token != null) {
      // while (page != HomePage() || page != SignInPage()) {
      Timer(
          Duration(seconds: 5),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => page)));
      setState(() {
        page = Container(
            color: Color(int.parse(bgColor)),
            child: Center(child: CircularProgressIndicator()));
      });

      var response = await networkHandler.get("/church/getAccountStatus");
      if (response == "active") {
        setState(() {
          page = HomePage();
        });
      } else {
        await storage.delete(key: "token");
        setState(() {
          page = SignInPage();
        });
      }
      //   Timer(Duration(seconds: 10), () => checkLogin());
      // }
    } else {
      setState(() {
        page = SignInPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(int.parse(bgColor)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/pilasaLogo.png"),
          )),
    );
  }
}
