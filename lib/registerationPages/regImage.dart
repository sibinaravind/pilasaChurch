import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter_native_image/flutter_native_image.dart';
import '../NetworkHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'signInPage.dart';

class RegImage extends StatefulWidget {
  RegImage({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _RegImageState createState() => _RegImageState();
}

class _RegImageState extends State<RegImage> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool churchFirstClick = true;
  bool letterFirstClick = true;
  final ImagePicker _picker = ImagePicker();
  PickedFile _imagefile;
  PickedFile _imagefile1;
  NetworkHandler networkHandler = NetworkHandler();

  String errorText;
  bool validate = false;
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(int.parse(bgColor)),
            ),
            child: (Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "We are request to upload both images , which will help us for autherization check and verification.We are taking these much field for make security strong.We look forward to your Cooperation",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Divider(color: Colors.grey, thickness: 3),
                  Text(
                    "Church Image",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold),
                  ),
                  churchImage(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Color(int.parse(titleColor)),
                        elevation: 10,
                        onPressed: () => {
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(1)))
                        },
                        child: Icon(
                          Icons.camera,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Color(int.parse(titleColor)),
                        elevation: 10,
                        onPressed: () async {
                          if (_imagefile != null) {
                            if (churchFirstClick) {
                              setState(() {
                                churchFirstClick = false;
                              });
                              ImageProperties properties =
                                  await FlutterNativeImage.getImageProperties(
                                      _imagefile.path);
                              File compressedFile =
                                  await FlutterNativeImage.compressImage(
                                      _imagefile.path,
                                      quality: 50,
                                      targetWidth: 600,
                                      targetHeight: (properties.height *
                                              600 /
                                              properties.width)
                                          .round());
                              var id = widget.id;
                              var response = await networkHandler.patchImage(
                                  "/church/add/church-image/$id",
                                  compressedFile.path);
                              if (response.statusCode == 200) {
                                // ignore: deprecated_member_use
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: Colors.green[400],
                                    content: Text(
                                        "Church Image Successfully Uploaded"),
                                    duration: Duration(seconds: 5)));
                              } else if (response.statusCode == 200) {
                                setState(() {
                                  churchFirstClick = true;
                                  _imagefile = null;
                                });
                                print(churchFirstClick);
                              }
                            }
                          } else {
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text("Please add the Image First"),
                                duration: Duration(seconds: 5)));
                          }
                        },
                        child: Icon(
                          Icons.cloud_upload,
                          size: 30,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey, thickness: 3),
                  Text(
                    "LetterPad Image",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Church Authorization letter in Church letterpad with Seal and Priest Photo",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  letterPadImage(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Color(int.parse(titleColor)),
                        elevation: 10,
                        onPressed: () => {
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(2)))
                        },
                        child: Icon(
                          Icons.camera,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Color(int.parse(titleColor)),
                        elevation: 10,
                        onPressed: () async {
                          if (_imagefile1 != null) {
                            if (letterFirstClick) {
                              setState(() {
                                letterFirstClick = false;
                              });
                              ImageProperties properties =
                                  await FlutterNativeImage.getImageProperties(
                                      _imagefile1.path);
                              File compressedFile =
                                  await FlutterNativeImage.compressImage(
                                      _imagefile1.path,
                                      quality: 50,
                                      targetWidth: 600,
                                      targetHeight: (properties.height *
                                              600 /
                                              properties.width)
                                          .round());
                              var id = widget.id;
                              var response = await networkHandler.patchImage(
                                  "/church/add/church-letterPad/$id",
                                  compressedFile.path);
                              if (response.statusCode == 200) {
                                // ignore: deprecated_member_use
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: Colors.green[400],
                                    content:
                                        Text("Letterpad Successfully Uploaded"),
                                    duration: Duration(seconds: 5)));
                              } else if (response.statusCode == 200) {
                                setState(() {
                                  letterFirstClick = true;
                                  _imagefile1 = null;
                                });
                              }
                            }
                          } else {
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text("Please add the Image First"),
                                duration: Duration(seconds: 5)));
                          }
                        },
                        child: Icon(
                          Icons.cloud_upload,
                          size: 30,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey, thickness: 3),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    elevation: 5,
                    color: Colors.green,
                    onPressed: () => {showAlertDialog(context)},
                    child: Text(
                      "Finish",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            )),
          ),
        ));
  }

  Widget bottomSheet(var num) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "choose Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera, num);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              SizedBox(
                width: 20,
              ),
              // ignore: deprecated_member_use
              FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery, num);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  takePhoto(ImageSource source, var num) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (num == 1) {
      setState(() {
        churchFirstClick = true;
        _imagefile = pickedFile;
      });
    } else {
      setState(() {
        letterFirstClick = true;
        _imagefile1 = pickedFile;
      });
    }
  }

  Widget churchImage() {
    //BuildContext context;
    return Center(
      child: Stack(children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            child: _imagefile == null
                ? Image.asset("assets/pilasaLogo.png")
                : Image.file(File(_imagefile.path))),
      ]),
    );
  }

  Widget letterPadImage() {
    //BuildContext context;
    return Center(
      child: Stack(children: <Widget>[
        Container(
            // maxRadius: 80.0,
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            child: _imagefile1 == null
                ? Image.asset("assets/pilasaLogo.png")
                : Image.file(File(_imagefile1.path))),
      ]),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 10,
      title: Text('Welcome to Pilasa family.'),
      contentTextStyle: TextStyle(
          color: Color(int.parse(titleColor)),
          fontSize: 16,
          fontWeight: FontWeight.bold),
      content: const Text(
          '   Your account will be activated within 7 days. Visit Pilasa.a@gmail.com for more information'),
      actions: <Widget>[
        // ignore: deprecated_member_use
        RaisedButton(
            elevation: 5,
            color: Colors.blue,
            child: const Text(
              'Ok',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false);
            }),
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
}
