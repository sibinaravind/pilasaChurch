import "package:flutter/material.dart";
import '../NetworkHandler.dart';

class Announcement extends StatefulWidget {
  Announcement({Key key, this.id, this.churchName}) : super(key: key);
  final String id;
  final String churchName;
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool vis = true;
  bool firstClick = true;
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _announcement = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorText;
  bool validate = false;
  bool circular = false;
  @override
  void initState() {
    super.initState();
    fetchAnnouncement();
  }

  void fetchAnnouncement() async {
    var response = await networkHandler.get("/church/getAnnouncement");
    Map<String, dynamic> output = response;
    setState(() {
      _announcement.text = output["announcemnt"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(int.parse(titleColor)),
          title: Text(
            "Announcement",
          ),
          centerTitle: true,
          actions: <Widget>[
            Center(
              child: InkWell(
                  child: Text("Clear", style: TextStyle(fontSize: 20)),
                  onTap: () => {
                        setState(() {
                          _announcement.text = '';
                        })
                      }),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(int.parse(bgColor)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
              child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        widget.churchName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(int.parse(titleColor)),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(height: 10, thickness: 3, color: Colors.grey),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 10),
                    announcementTextField(),
                    Divider(
                      height: 50,
                      thickness: 1.5,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.yellow,
                      elevation: 10,
                      onPressed: () async {
                        if (firstClick) {
                          Map<String, String> data = {
                            "announcement": _announcement.text
                          };
                          setState(() {
                            firstClick = false;
                            circular = false;
                          });
                          var response = await networkHandler.post(
                              "/church/editAnnouncement", data);
                          if (response.statusCode != 200) {
                            setState(() {
                              firstClick = true;
                            });
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text("Error to update. Try once more"),
                                duration: Duration(seconds: 5)));
                          } else {
                            setState(() {
                              firstClick = true;
                            });
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.green[400],
                                content:
                                    Text("Announcemnet Successfully updated"),
                                duration: Duration(seconds: 5)));
                          }
                        }
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(
                          // color: Colors.,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget announcementTextField() {
    return TextFormField(
        smartDashesType: SmartDashesType.disabled,
        controller: _announcement,
        minLines: 10,
        maxLines: null,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
              width: 10.0,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300], width: 3)),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "Announcement",
            hintText: "Write a Announcement for Belivers "));
  }
}

class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}
