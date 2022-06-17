import "package:flutter/material.dart";
import '../NetworkHandler.Dart';

class BlogCard extends StatelessWidget {
  const BlogCard({Key key, this.imgName, this.networkHandler})
      : super(
            key:
                key); // accessing image file value whoch is passed from the previous page

  final String imgName;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        padding: EdgeInsets.all(2),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            shadowColor: Colors.black,
            color: Colors.grey[400],
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: networkHandler
                            .getImage("/uploads/superImage/$imgName"),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
        ));
  }
}
