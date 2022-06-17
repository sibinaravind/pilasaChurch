import 'package:pilasa_church/superPosts/BlogCard.dart';
import 'package:pilasa_church/Model/superModel.dart';
import "package:flutter/material.dart";
import '../NetworkHandler.Dart';
import './BlogCard.dart';

class SuperBlog extends StatefulWidget {
  SuperBlog({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _SuperBlogState createState() => _SuperBlogState();
}

class _SuperBlogState extends State<SuperBlog> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List data;
  bool len = false;
  // initilaizing empty array to not show error if not have any elemnts

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler
        .get(widget.url); // widget.url is used to access data through given url
    data = response.map<dynamic>((m) => m['imgName'] as String).toList();
    setState(() {
      if (data.length > 0) {
        len = true;
      }
    });
    // setState(() {
    //   data = superModel.data;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return len
        ? Column(
            children: data
                .map((item) => BlogCard(
                      imgName: item,
                      networkHandler: networkHandler,
                    ))
                .toList(),
          )
        : Center(
            child: Text("No posts found"),
          );
  } //data.map is used to map the values in the data table as newsfeed
}

class Blog {}
