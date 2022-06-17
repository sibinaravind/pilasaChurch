import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pilasa_church/booking/viewBookings.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Model/holyMassModels.dart';
import '../Model/massListModel.dart';
import '../NetworkHandler.Dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeCalendarPage extends StatefulWidget {
  @override
  _HomeCalendarPageState createState() => _HomeCalendarPageState();
}

class _HomeCalendarPageState extends State<HomeCalendarPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //you can put anything like refetching post or data from internet
  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    fetchMass();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();

  CalendarController _controller;
  TextEditingController _newSeats = TextEditingController();
  TextEditingController _numberOfSeats = TextEditingController();
  TextEditingController _langContoller = TextEditingController();
  TextEditingController _langContoller2 = TextEditingController();
  TextEditingController _time = TextEditingController();
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  String displayDate = ' ';
  MassListModel massList = MassListModel();
  List<HolyMassModels> listdata;
  String _selectedDay =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  String _errtext;
  @override
  void initState() {
    super.initState();
    listdata = [];
    _controller = CalendarController();
    fetchMass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(int.parse(titleColor)),
        title: Text('Mass Booking'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(int.parse(titleColor)),
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          if (_numberOfSeats.text == '') {
            setState(() {
              _errtext = "Please fill the number of Seats Allowed";
            });
          } else if (_selectedDay == '') {
            setState(() {
              _errtext = "Please select the Booking day";
            });
          } else if (int.parse(_numberOfSeats.text) < 10) {
            setState(() {
              _errtext = "At least give min of 10 seats";
            });
          } else {
            showModalBottomSheet(
                context: context, builder: (builder) => bottomsheet());

            setState(() {
              _errtext = "";
            });
          }
        },
      ),
      body: LiquidPullToRefresh(
        color: Color(int.parse(titleColor)),
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              calender(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(width: 3, color: Colors.green)),
                    elevation: 10,
                    child: Text(
                      "update Seats ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => {
                      if (listdata.isEmpty)
                        {
                          // ignore: deprecated_member_use
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.red[400],
                              content: Text(
                                  "There is no Holy mass available to update"),
                              duration: Duration(seconds: 2)))
                        }
                      else
                        {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => updateSeatBottomSheet())
                        }
                    },
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(width: 3, color: Colors.green)),
                    onPressed: () async {
                      final ConfirmAction action = await _asyncConfirmDialog(
                          context,
                          'Copy Mass To next Day',
                          'This will  delete all the mass of next day of selected day and insert all the mass of today.',
                          'Copy Mass');
                      print("Confirm Action $action");
                      if (action == ConfirmAction.Accept) {
                        if (_selectedDay != '') {
                          DateTime tommorow =
                              _controller.selectedDay.add(Duration(days: 1));
                          String _nextDay =
                              '${tommorow.day}/${tommorow.month}/${tommorow.year}';
                          Map<String, String> data = {
                            "date": _selectedDay,
                            "tomorrow": _nextDay
                          };
                          var response = await networkHandler.post(
                              "/church/copyToNextDay", data);
                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.green[400],
                                content: Text("Successfully Copied"),
                                duration: Duration(seconds: 2)));
                          } else {
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text("Not Copied Try Again"),
                                duration: Duration(seconds: 2)));
                          }
                        } else {
                          // ignore: deprecated_member_use
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.red[400],
                              content: Text("Please select a Day"),
                              duration: Duration(seconds: 2)));
                        }
                      }
                    },
                    child: Text(
                      "Copy to Next Day",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "NB: Update button is for increase or decrease the seat of Holy Mass.",
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              ),
              Divider(height: 10, thickness: 3, color: Colors.grey),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  displayDate,
                  style: TextStyle(
                      color: Color(int.parse(titleColor)),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              seatsTextField(),
              SizedBox(
                height: 2,
              ),
              languageTextField(),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "NB:It is recommended to add the holy mass in time order, double tap on Mass to see bookings",
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              ),
              massDisplay(context),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomsheet() {
    String _errText1;
    bool _firstclick = true;
    return Container(
      key: _globalKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Center(
                child: Text("Add Holy Mass ",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 30,
            ),
            Text(
              _selectedDay,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _numberOfSeats.text + "    Seats",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) return "language can't be empty";
                  return null;
                },
                // ignore: deprecated_member_use
              //  autovalidate: true,
                controller: _langContoller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.teal,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[300], width: 3)),
                    helperStyle: TextStyle(color: Colors.grey[400]),
                    labelText: "Language",
                    errorText: _errText1)),
            SizedBox(
              height: 15,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) return "Time Can't be empty";
                  return null;
                },
                // ignore: deprecated_member_use
               // autovalidate: true,
                controller: _time,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.teal,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[300], width: 3)),
                    helperStyle: TextStyle(color: Colors.grey[400]),
                    labelText: "Holy Mass Time eg:7 AM",
                    errorText: _errText1)),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                if (_time.text != '') {
                  if (_langContoller.text != '') {
                    if (_firstclick) {
                      setState(() {
                        _firstclick = false;
                      });
                      HolyMassModels holyMassModels = HolyMassModels(
                          date: _selectedDay,
                          time: (_time.text).trim(),
                          lang: _langContoller.text,
                          remaining: int.parse(_numberOfSeats.text),
                          seats: int.parse(_numberOfSeats.text));
                      var response = await networkHandler.post1(
                          "/church/addMasses", holyMassModels.toJson());
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Navigator.of(context).pop();
                        setState(() {
                          _time.text = '';
                          listdata.add(holyMassModels);
                        });
                      } else {
                        setState(() {
                          _firstclick = true;
                        });
                      }
                    }
                  } else {
                    setState(() {
                      _errText1 = 'please fill the Date';
                    });
                  }
                }
              },
              child: Text("Add holy Mass"),
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }

  Widget seatsTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
          onEditingComplete: () => {},
          validator: (value) {
            if (value.isEmpty) return "seats Number Can't be empty";
            if (int.parse(value) < 10) return "At least provide 10 seats";
            return null;
          },
          keyboardType: TextInputType.number,
          controller: _numberOfSeats,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.teal,
              )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[300], width: 3)),
              helperStyle: TextStyle(color: Colors.grey[400]),
              labelText: "Number of seats",
              errorText: _errtext)),
    );
  }

  Widget languageTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
          controller: _langContoller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300], width: 3)),
            helperStyle: TextStyle(color: Colors.grey[400]),
            labelText: "The language of holy communion",
          )),
    );
  }

  Widget editMassBottomSheet(
      String time, String date, String lang, String seats) {
    String errText2;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // textDirection: TextDirection.ltr,
          children: <Widget>[
            Center(
                child: Text("Edit Holy Mass Time ",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 20,
            ),
            Text(
              date,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Total Seats:     " + seats,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Language:    " + lang,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _langContoller2,
              decoration: InputDecoration(
                  labelText: "New Language", errorText: errText2),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Time    " + time,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _time,
              decoration:
                  InputDecoration(labelText: "New Time", errorText: errText2),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                if (_time.text == '') {
                  setState(() {
                    errText2 = "Please enter the New Time";
                  });
                } else {
                  Map<String, String> data = {
                    "date": date,
                    "time": time,
                    "newTime": _time.text,
                    "lang": _langContoller2.text
                  };
                  var response =
                      await networkHandler.post("/church/editHollymass", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Navigator.of(context).pop();
                    setState(() {
                      _time.text = '';
                    });
                  }
                  fetchMass();
                }
              },
              child: Text("Update Mass time"),
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }

  void fetchMass() async {
    Map<String, dynamic> data = {
      "date": _selectedDay,
    };
    var response = await networkHandler.post2("/church/viewHollymass", data);
    if (response.isEmpty) {
      setState(() {
        displayDate = _selectedDay;
        _numberOfSeats.text = '';
      });
    }
    massList = MassListModel.fromJson({'data': response});
    setState(() {
      listdata = massList.data;
      _numberOfSeats.text = listdata[0].seats.toString();
      displayDate = listdata[0].date.toString();
    });
    massDisplay(context);
  }

  Widget massDisplay(BuildContext context) {
    return Column(
        children: listdata
            .map((item) => Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black54,
                            offset: new Offset(10.0, 10.0),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: InkWell(
                        onDoubleTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewBookings(
                                  selDay: item.date.toString(),
                                  time: item.time)))
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(item.time,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text(item.lang,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ],
                            ),
                            Text(item.remaining.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () => {
                                setState(() {
                                  _time.text = item.time;
                                  _langContoller2.text = item.lang;
                                }),
                                showModalBottomSheet(
                                    context: context,
                                    builder: (builder) => editMassBottomSheet(
                                        item.time,
                                        item.date,
                                        item.lang,
                                        item.seats.toString()))
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final ConfirmAction action =
                                    await _asyncConfirmDialog(
                                        context,
                                        'Delete This Holy mass?',
                                        'This will cancel the Holy mass and remove all Bookings.',
                                        'Delete');
                                print("Confirm Action $action");
                                if (action == ConfirmAction.Accept) {
                                  Map<String, String> data = {
                                    "date": item.date,
                                    "time": item.time,
                                  };
                                  var response = await networkHandler.post(
                                      "/church/cancelMass", data);
                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    setState(() {
                                      listdata.removeWhere((canMass) =>
                                          canMass.time == item.time);
                                    });
                                  }
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ))
            .toList());
  }

  Widget calender() {
    return TableCalendar(
      initialSelectedDay: DateTime.now(),
      startDay: DateTime.now().subtract(Duration(days: 6)),
      endDay: DateTime.now().add(Duration(days: 6)),
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
          selectedStyle: TextStyle(
              backgroundColor: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 30),
          highlightToday: true,
          todayColor: Colors.red,
          selectedColor: Colors.green,
          todayStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red)),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(22.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
        formatButtonShowsNext: false,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (date, events, dya) async {
        setState(() {
          _selectedDay = '${date.day}/${date.month}/${date.year}';
        });
        fetchMass();
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
        todayDayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
      ),
      calendarController: _controller,
    );
  }

  Widget updateSeatBottomSheet() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Center(
                child: Text("Update Seat Number",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                _selectedDay,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _numberOfSeats.text + "    Seats",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _newSeats,
              decoration:
                  InputDecoration(labelText: "New seat number which allowed"),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                if (_newSeats.text == '') {
                  // ignore: deprecated_member_use
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.red[400],
                      content: Text("Please enter new seats"),
                      duration: Duration(seconds: 2)));
                } else {
                  Map<String, String> data = {
                    "date": _selectedDay,
                    "seats": _numberOfSeats.text,
                    "newSeats": _newSeats.text,
                  };
                  var response =
                      await networkHandler.post("/church/updateSeats", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Navigator.of(context).pop();
                    setState(() {
                      _newSeats.text = '';
                    });
                    fetchMass();
                  }
                }
              },
              child: Text("Update Seat Number"),
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}

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
