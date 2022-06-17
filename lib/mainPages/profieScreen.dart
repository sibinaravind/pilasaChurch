import 'dart:io';
import 'dart:async';
import "package:flutter/material.dart";
import 'package:pilasa_church/profilePages/announcement.dart';
import 'package:pilasa_church/profilePages/accountAdd.dart';
import 'package:pilasa_church/profilePages/paymentAdd.dart';
import '../NetworkHandler.Dart';
import '../booking/bookingCalender.dart';
import '../posts/Blogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //you can put anything like refetching post or data from internet
  Future<void> _handleRefresh() {
    Blogs(
      url: "/church/getPosts",
    );
    final Completer<void> completer = Completer<void>();

    setState(() {});
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  NetworkHandler networkHandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  String id;
  String churchName = ' Jesus loves You';
  String churchPlace = 'Jesus loves You';
  String churchabout = 'Jesus loves you';
  ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  PickedFile _imageFile2;
  String respon;
  @override
  void initState() {
    super.initState();
    fetchChurch();
  }

  void fetchChurch() async {
    var response = await networkHandler.get("/church/getchurch");
    Map<String, dynamic> output = response;
    setState(() {
      id = output["_id"];
      churchName = output["churchname"];
      churchPlace = output["place"];
      churchabout = output["about"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: LiquidPullToRefresh(
          color: Color(int.parse(titleColor)),
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          child: Center(
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: _imageFile2 == null
                          ? null
                          : Image.file(File(_imageFile2.path),
                              fit: BoxFit.cover),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 25.0, // soften the shadow
                            spreadRadius: 5.0, //extend the shado
                          )
                        ],
                        image: DecorationImage(
                            image: NetworkHandler()
                                .getImage("/uploads/churchImages/$id.jpg"),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(80),
                            bottomRight: Radius.circular(80)),
                        color: Colors.white,
                      ),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Positioned(
                      top: 20.0,
                      right: 20.0,
                      child: InkWell(
                        onTap: () => {
                          showModalBottomSheet(
                              // isScrollControlled: true,
                              context: context,
                              builder: (builder) => bottomSheet())
                        },
                        child: CircleAvatar(
                            backgroundColor: Color(int.parse(bgColor)),
                            child: Icon(
                              Icons.edit,
                              color: Color(int.parse(titleColor)),
                              size: 30,
                            )),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80)),
                    color: Color(0xff30384c),
                    // color: Color(int.parse(titleColor)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        churchName != null ? churchName : " ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        churchPlace != null ? churchPlace : " ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        churchabout != null ? churchabout : " ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 3,
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          RaisedButton(
                            elevation: 10,
                            child: Text(
                              "Booking",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeCalendarPage()))
                            },
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            elevation: 10,
                            child: Text(
                              "Announcement ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Announcement(
                                        id: id,
                                        churchName: churchName,
                                      )))
                            },
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            elevation: 10,
                            child: Text(
                              "Payments",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () async {
                              var response = await networkHandler
                                  .get("/church/CheckPaymentAccount");
                              // var result = json.decode(response.body);
                              // print(result);
                              if (response == "Actiavted") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PaymentAdd(
                                          id: id,
                                          churchName: churchName,
                                        )));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AccountAdd()));
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.blueGrey[700],
                  thickness: 5,
                  height: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                Blogs(
                  url: "/church/getPosts",
                )
              ],
            ),
          ),
        ));
  }

  Widget bottomSheet() {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          // textDirection: TextDirection.ltr,
          children: <Widget>[
            Center(
                child: Text("Update Church Image",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // ignore: deprecated_member_use
                FlatButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
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
                      takePhoto(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image),
                    label: Text("Gallery")),
              ],
            ),
            churchImage(),
            // ignore: deprecated_member_use
            RaisedButton(
                child: Text("Update Profile Pic"),
                color: Colors.yellow,
                elevation: 10,
                onPressed: () async {
                  Navigator.pop(context);
                  if (_imageFile != null) {
                    print(_imageFile.path);
                    ImageProperties properties =
                        await FlutterNativeImage.getImageProperties(
                            _imageFile.path);
                    File compressedFile =
                        await FlutterNativeImage.compressImage(_imageFile.path,
                            quality: 50,
                            targetWidth: 600,
                            targetHeight:
                                (properties.height * 600 / properties.width)
                                    .round());
                    print(compressedFile.path);
                    // setState(() {
                    //   _imageFile = null;
                    // });
                    // ignore: deprecated_member_use
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.green[400],
                        content: Text("Image Successfully updated "),
                        duration: Duration(seconds: 5)));
                    var response = await networkHandler.patchImage(
                        "/church/Update-church-image/$id", compressedFile.path);
                    if (response.statusCode == 200) {
                      setState(() {
                        _imageFile2 = _imageFile;
                        _imageFile = null;
                      });
                    }
                    setState(() {
                      // _networkImage = NetworkHandler()
                      //     .getImage("/uploads/churchImages/$id.jpg");
                    });
                  }
                })
          ],
        ),
      ),
    );
  }

  takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    setState(() {
      _imageFile = pickedFile;
      //_fileimage = pickedFile;
    });
    Navigator.pop(context);
    showModalBottomSheet(context: context, builder: (builder) => bottomSheet());
  }

  Widget churchImage() {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Center(
            child: Stack(children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  height: 150.0,
                  width: MediaQuery.of(context).size.width,
                  child: _imageFile == null
                      ? Image.asset("assets/pilasaLogo.png")
                      : Image.file(File(_imageFile.path))),
            ]),
          );
        });
  }
}
