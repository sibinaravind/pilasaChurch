import 'package:flutter/material.dart';
import '../NetworkHandler.Dart';
import '../payment/recentPayment.dart';

class PaymentRequests extends StatefulWidget {
  @override
  _PaymentRequestsState createState() => _PaymentRequestsState();
}

class _PaymentRequestsState extends State<PaymentRequests> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //you can put anything like refetching post or data from internet

  NetworkHandler networkHandler = NetworkHandler();
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
          title: Text('Payments Requests'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Total Amount :  " + rupees.toString() + " INR",
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
        ));
  }

  void fetchPayments() async {
    var response = await networkHandler.get("/church/withdrawRequestList");
    setState(() {
      rupees = response["totAmt"];
      listdata = response["requests"];
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
                      Padding(
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
                                child: Text(item['date'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text(item['amount'].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              item['status'] == "pending"
                                  ? Text(item['status'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red))
                                  : Text(item['status'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green)),
                              SizedBox(
                                width: 10,
                              ),
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
}
