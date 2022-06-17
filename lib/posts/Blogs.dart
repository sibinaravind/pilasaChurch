import 'package:pilasa_church/Model/addBlogModels.dart';
import 'package:pilasa_church/Model/superModel.dart';
import "package:flutter/material.dart";
import '../NetworkHandler.Dart';

class Blogs extends StatefulWidget {
  Blogs({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson({"data": response});
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.black,
                        color: Color(int.parse(item.color)),
                        elevation: 10,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.content,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: InkWell(
                                onTap: () async {
                                  final ConfirmAction action =
                                      await _asyncConfirmDialog(
                                          context,
                                          'Post Delete',
                                          'Do you really want to delete this post.',
                                          'Delete');
                                  if (action == ConfirmAction.Accept) {
                                    Map<String, String> datas = {
                                      "_id": item.id,
                                    };
                                    var response = await networkHandler.post(
                                        "/church/deletePost", datas);
                                    if (response.statusCode == 200 ||
                                        response.statusCode == 201) {
                                      setState(() {
                                        data.removeWhere(
                                            (canMass) => canMass.id == item.id);
                                      });
                                    }
                                  }
                                },
                                child: CircleAvatar(
                                    backgroundColor: Color(int.parse(bgColor)),
                                    child: Icon(
                                      Icons.delete,
                                      color: Color(int.parse(titleColor)),
                                      size: 30,
                                    )),
                              ),
                            ),
                            Positioned(
                                bottom: 2,
                                child: SizedBox(
                                    height: 20,
                                    child: Text(
                                        'Posted On:  ' +
                                            '${item.created.day}/${item.created.month}/${item.created.year}',
                                        style: TextStyle(color: Colors.blue))))
                          ],
                        ),
                      ),
                    ))
                .toList(),
          )
        : Center(
            child: Text("No active posts.. "),
          );
  } //data.map is used to map the values in the data table as newsfeed
}

class Blog {}

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
