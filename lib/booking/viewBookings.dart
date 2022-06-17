import 'package:flutter/material.dart';
import '../NetworkHandler.Dart';
import '../Model/bookingModel.dart';
import '../Model/bookingListModel.dart';

class ViewBookings extends StatefulWidget {
  ViewBookings({Key key, this.selDay, this.time}) : super(key: key);
  final String selDay;
  final String time;
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<ViewBookings> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  NetworkHandler networkHandler = NetworkHandler();
  BookingListModel bookingList = BookingListModel();
  List<BookingModel> listdata;
  @override
  void initState() {
    listdata = [];
    super.initState();
    fetchMass();
  }

  void fetchMass() async {
    Map<String, dynamic> data = {
      "date": widget.selDay,
      "time": widget.time,
    };
    var response = await networkHandler.post2("/church/viewBooking", data);
    bookingList = BookingListModel.fromJson({"data": response});
    setState(() {
      listdata = bookingList.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse(titleColor)),
          title: Text(widget.selDay + " massbooking"),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: DataTable(
            columns: [
              DataColumn(
                  label: Text('Name',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Phone',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
            rows: listdata
                .map(
                  (item) => DataRow(cells: [
                    DataCell(Text(
                      item.belivers,
                    )),
                    DataCell(Text(item.phone)),
                  ]),
                )
                .toList(),
          ),
        ));
  }
}
