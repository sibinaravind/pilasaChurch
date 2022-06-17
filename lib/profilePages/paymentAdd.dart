import 'dart:async';
import 'package:flutter/material.dart';
import '../NetworkHandler.Dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../payment/calenderView.dart';
import '../payment/recentPayment.dart';
import '../payment/paymentByName.dart';

class PaymentAdd extends StatefulWidget {
  PaymentAdd({Key key, this.id, this.churchName}) : super(key: key);
  final String id;
  final String churchName;
  @override
  _PaymentAddState createState() => _PaymentAddState();
}

class _PaymentAddState extends State<PaymentAdd> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //you can put anything like refetching post or data from internet
  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    // fetchMass();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amtController = TextEditingController();
  TextEditingController _amt2Controller = TextEditingController();
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  bool circular = false;
  bool dateCheck = false;
  bool amtCheck = false;
  bool firstClick = true;
  var rupees = 0;
  List<dynamic> listdata = [];
  @override
  void initState() {
    // displayWidget = mainWidget();
    super.initState();
    listdata = [];
    fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(int.parse(titleColor)),
          title: Text('Payments'),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.calendar_today,
                    ),
                  ),
                  onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CalenderView(
                                  id: widget.id,
                                  churchName: widget.churchName,
                                )))
                      }),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(int.parse(titleColor)),
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            {
              {
                showModalBottomSheet(
                    // isScrollControlled: true,
                    context: context,
                    builder: (builder) => bottomsheet());
              }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Balance:  " + rupees.toString() + " INR",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecentPayemt()))
                      },
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(width: 3, color: Colors.green)),
                      elevation: 10,
                      child: Text(
                        "withdraw",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (firstClick) {
                          setState(() {
                            firstClick = false;
                          });
                          if (rupees < 100) {
                            setState(() {
                              firstClick = true;
                            });
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red[400],
                                content:
                                    Text("Minimum 100 INR Require to withdraw"),
                                duration: Duration(seconds: 2)));
                          } else {
                            final ConfirmAction action =
                                await _asyncConfirmDialog(
                                    context,
                                    'Withdraw Amount',
                                    'Want to withdraw   ' +
                                        rupees.toString() +
                                        "  INR   to your registered account?",
                                    'Withdraw');
                            print("Confirm Action $action");
                            if (action == ConfirmAction.Accept) {
                              Map<String, String> data = {
                                "amount": rupees.toString(),
                              };
                              var response = await networkHandler.post(
                                  "/church/addWithdrawRequests", data);
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                setState(() {
                                  firstClick = true;
                                  rupees = 0;
                                });
                                // ignore: deprecated_member_use
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: Colors.green[400],
                                    content: Text(
                                        "The request was successfully generated and the amount will be credited within 7 days"),
                                    duration: Duration(seconds: 5)));
                              } else {
                                setState(() {
                                  firstClick = true;
                                });
                              }
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
                Divider(height: 10, thickness: 3, color: Colors.grey),
                // massDisplay(context),
                SizedBox(
                  height: 10,
                ),
                paymentDisplay(context),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ));
  }

  Widget bottomsheet() {
    String _errText1;
    bool _firstclick = true;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Center(
                child: Text("New Insert",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                validator: (value) {
                  if (value.isEmpty) return "Name can't be empty";
                  return null;
                },
                // ignore: deprecated_member_use
                // autovalidate: true,
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.teal,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[300], width: 3)),
                    helperStyle: TextStyle(color: Colors.grey[400]),
                    labelText: "Name to Display",
                    errorText: _errText1)),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Date",
                  style: TextStyle(color: Colors.blue),
                ),
                Checkbox(
                  focusColor: Colors.grey,
                  checkColor: Colors.green,
                  activeColor: Color(int.parse(bgColor)),
                  value: dateCheck,
                  onChanged: (newValue) {
                    setState(() => {dateCheck = newValue});
                    updated();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "NB:Tick the date Checkbox if payment depends on the date",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ),
            Row(
              children: <Widget>[
                Text(
                  "Fixed Amount",
                  style: TextStyle(color: Colors.blue),
                ),
                Checkbox(
                  focusColor: Colors.grey,
                  checkColor: Colors.green,
                  activeColor: Color(int.parse(bgColor)),
                  value: amtCheck,
                  onChanged: (bool newValue) {
                    setState(() => {amtCheck = newValue});
                    updated();
                  },
                ),
              ],
            ),
            Container(
                child: amtCheck
                    ? TextFormField(
                        validator: (value) {
                          if (value.isEmpty) return "Amount Can't be empty";
                          return null;
                        },
                        // ignore: deprecated_member_use
                        //autovalidate: true,
                        controller: _amtController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.teal,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red[300], width: 3)),
                            helperStyle: TextStyle(color: Colors.grey[400]),
                            labelText: "Amount",
                            errorText: _errText1))
                    : Text(" ")),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                if (_nameController.text != '') {
                  if ((amtCheck == true) && (_amtController.text == '')) {
                    setState(() {
                      _errText1 = 'please fill the details';
                    });
                  } else {
                    if (_firstclick) {
                      setState(() {
                        _firstclick = false;
                      });
                      Map<String, String> data = {
                        "name": _nameController.text,
                        "date":
                            dateCheck.toString() == "false" ? "true" : "false",
                        "amount": amtCheck ? _amtController.text : "false"
                      };
                      var response =
                          await networkHandler.post("/church/addPayment", data);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Navigator.of(context).pop();
                        setState(() {
                          _nameController.text = " ";
                          _amtController.text = " ";
                          listdata.add(data);
                        });
                      } else {
                        setState(() {
                          _firstclick = true;
                        });
                      }
                    }
                  }
                } else {
                  setState(() {
                    _errText1 = 'please fill the details';
                  });
                }
              },
              child: Text("Add"),
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> updated() async {
    Navigator.pop(context);
    showModalBottomSheet(context: context, builder: (builder) => bottomsheet());
  }

  void fetchPayments() async {
    var response = await networkHandler.get("/church/paymentList");
    setState(() {
      rupees = response["balance"];
      listdata = response["payments"];
    });
    print(listdata);
  }

  Widget paymentDisplay(BuildContext context) {
    return Column(
        children: listdata
            .map((item) => listdata.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PaymentByName(type: item['name'])))
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(
                                    item['amount'] != 'false'
                                        ? item['amount']
                                        : ' ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () => {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder) =>
                                              editPaymentMethod(
                                                  item['name'], item['amount']))
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red[300],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: InkWell(
                                    onTap: () async {
                                      final ConfirmAction action =
                                          await _asyncConfirmDialog(
                                              context,
                                              'Delete This Item?',
                                              'This will delete the item permanently',
                                              'Delete');
                                      print("Confirm Action $action");
                                      if (action == ConfirmAction.Accept) {
                                        Map<String, String> data = {
                                          "name": item['name'],
                                        };
                                        var response =
                                            await networkHandler.post(
                                                "/church/deletePayment", data);
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          setState(() {
                                            listdata.removeWhere((canPay) =>
                                                canPay['name'] == item['name']);
                                          });
                                        }
                                      }
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
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

  Widget editPaymentMethod(String name, String amount) {
    String errText2;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // textDirection: TextDirection.ltr,
          children: <Widget>[
            Center(
                child: Text("Edit Payment Type ",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(int.parse(titleColor)),
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 20,
            ),
            Text(
              name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Amount:    " + amount,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return "Amount can't be empty";
                return null;
              },
              // ignore: deprecated_member_use
              //autovalidate: true,
              controller: _amt2Controller,
              decoration:
                  InputDecoration(labelText: "New Amount", errorText: errText2),
            ),
            SizedBox(
              height: 10,
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () async {
                if (_amt2Controller.text == '' ||
                    int.parse(_amt2Controller.text) < 0) {
                  setState(() {
                    errText2 = "Please enter the Updated Amount";
                  });
                } else {
                  Map<String, String> data = {
                    "newAmt": _amt2Controller.text,
                    "name": name,
                  };
                  var response =
                      await networkHandler.post("/church/editPayment", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Navigator.of(context).pop();
                    setState(() {
                      _amt2Controller.text = '';
                    });
                  }
                  fetchPayments();
                }
              },
              child: Text("Update Payment"),
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
