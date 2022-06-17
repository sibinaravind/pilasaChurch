import 'package:flutter/material.dart';
import '../NetworkHandler.Dart';
import '../Model/paymentModel.dart';
import '../Model/paymentListModel.dart';
import 'dart:convert';

class PaymentByName extends StatefulWidget {
  PaymentByName({Key key, this.type}) : super(key: key);
  final String type;
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<PaymentByName> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  NetworkHandler networkHandler = NetworkHandler();
  PaymentListModel bookingList = PaymentListModel();
  List<PaymentModel> listdata;
  String comment = "loading...";

  @override
  void initState() {
    listdata = [];
    super.initState();
    fetchMass();
  }

  void fetchMass() async {
    Map<String, dynamic> data = {
      "type": widget.type,
    };
    var response =
        await networkHandler.post2("/church/viewPaymentTypeDone", data);
    bookingList = PaymentListModel.fromJson({"payments": response});
    print(bookingList);
    setState(() {
      listdata = bookingList.payments.reversed.toList();
    });
    print(listdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse(titleColor)),
          title: Text(widget.type + "  Transactions"),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Amount',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ],
              rows: listdata
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            item.name,
                          ),
                        ),
                        DataCell(Text(item.date)),
                        DataCell(Text(item.amt.toString())),
                      ],
                      onSelectChanged: (newValue) async {
                        showModalBottomSheet(
                            context: context,
                            builder: (builder) => paymentDeatils(
                                  widget.type,
                                  item.date,
                                  item.name,
                                  item.amt.toString(),
                                ));
                        Map<String, String> data = {
                          "pay_id": item.payId,
                        };
                        var response2 = await networkHandler.post(
                            "/church/getPaymentDetails", data);
                        var result = json.decode(response2.body);
                        setState(() {
                          comment = result["comment"];
                        });
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                            context: context,
                            builder: (builder) => paymentDeatils(
                                  widget.type,
                                  item.date,
                                  item.name,
                                  item.amt.toString(),
                                ));
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ));
  }

  Widget paymentDeatils(String type, String date, String name, String amt) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                type,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(int.parse(titleColor))),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Name  :\t " + name,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Amount  :\t " + amt,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Date  :\t  " + date,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Comment :\t  " + comment,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        comment = "loading...";
                      });
                    },
                    child: Text("Close",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
