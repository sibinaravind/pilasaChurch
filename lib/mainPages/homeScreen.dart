import "package:flutter/material.dart";
import '../superPosts/superBlog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: ListView(children: <Widget>[
            SuperBlog(
              url: "/church/getSuperImages",
            ),
          ]),
        ));
  }
}
