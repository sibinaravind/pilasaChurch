import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../NetworkHandler.Dart';
import '../Model/paymentModel.dart';
import '../Model/paymentListModel.dart';
import 'dart:convert';

class CalenderView extends StatefulWidget {
  CalenderView({Key key, this.id, this.churchName}) : super(key: key);
  final String id;
  final String churchName;
  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  String comment = "loading...";
  NetworkHandler networkHandler = NetworkHandler();

  CalendarController _controller;
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  String displayDate = ' ';
  PaymentListModel bookingList = PaymentListModel();
  List<PaymentModel> listdata;
  List<PaymentModel> reverse;
  String _selectedDay =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  @override
  void initState() {
    displayDate = _selectedDay;
    super.initState();
    listdata = [];
    _controller = CalendarController();
    fetchMass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(titleColor)),
        title: Text('Payments'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            calender(),
            Divider(height: 10, thickness: 3, color: Colors.grey),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                _selectedDay,
                style: TextStyle(
                    color: Color(int.parse(titleColor)),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
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
                          DataCell(Text(item.type)),
                          DataCell(Text(item.amt.toString())),
                        ],
                        onSelectChanged: (newValue) async {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => paymentDeatils(
                                    item.type,
                                    _selectedDay,
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
                                    item.type,
                                    _selectedDay,
                                    item.name,
                                    item.amt.toString(),
                                  ));
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  void fetchMass() async {
    Map<String, dynamic> data = {"date": _selectedDay};
    var response =
        await networkHandler.post2("/church/viewPaymentByDate", data);
    bookingList = PaymentListModel.fromJson({"payments": response});
    setState(() {
      listdata = bookingList.payments.reversed.toList();
    });
    print(listdata);
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

  Widget calender() {
    return TableCalendar(
      initialSelectedDay: DateTime.now(),
      startDay: DateTime.now().subtract(Duration(days: 29)),
      endDay: DateTime.now().add(Duration(days: 29)),
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
}
