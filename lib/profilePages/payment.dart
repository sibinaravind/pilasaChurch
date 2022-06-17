// import "package:flutter/material.dart";
// import '../NetworkHandler.dart';
// import './accountAdd.dart';

// class Payment extends StatefulWidget {
//   Payment({Key key, this.id, this.churchName}) : super(key: key);
//   final String id;
//   final String churchName;
//   @override
//   _PaymentState createState() => _PaymentState();
// }

// class _PaymentState extends State<Payment> {
//   String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
//   String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
//   String textColor = '#f6f5f5'.replaceAll('#', '0xff');
//   bool vis = true;
//   bool firstClick = true;
//   NetworkHandler networkHandler = NetworkHandler();
//   TextEditingController _name = TextEditingController();
//   TextEditingController _accountnumber = TextEditingController();
//   TextEditingController _reaccountnumber = TextEditingController();
//   TextEditingController _ifsc = TextEditingController();

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   String errorText;
//   bool validate = false;
//   bool circular = false;
//   @override
//   void initState() {
//     super.initState();
//     // Navigator.of(context).push(MaterialPageRoute(
//     //     builder: (context) =>
//     //         AccountAdd(id: widget.id, churchName: widget.churchName)));
//     // fetchPayment();
//   }

//   void fetchPayment() async {
//     var response = await networkHandler.get("/church/getPayment");
//     Map<String, dynamic> output = response;
//     setState(() {
//       // _payment.text = output["announcemnt"];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Color(int.parse(titleColor)),
//           title: Text(
//             "Payment",
//           ),
//           centerTitle: true,
//           actions: <Widget>[
//             Center(
//               child: InkWell(
//                   child: Text("Clear", style: TextStyle(fontSize: 20)),
//                   onTap: () => {
//                         setState(() {
//                           // _payment.text = '';
//                         })
//                       }),
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               color: Color(int.parse(bgColor)),
//             ),
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
//               child: ListView(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Text(
//                         widget.churchName,
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Color(int.parse(titleColor)),
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Divider(height: 10, thickness: 3, color: Colors.grey),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(height: 10),
//                     paymentTextField(),
//                     Divider(
//                       height: 50,
//                       thickness: 1.5,
//                     ),
//                     RaisedButton(
//                       color: Colors.yellow,
//                       elevation: 10,
//                       onPressed: () async {
//                         if (firstClick) {
//                           Map<String, String> data = {"Payment": _name.text};
//                           setState(() {
//                             firstClick = false;
//                             circular = false;
//                           });
//                           var response = await networkHandler.post(
//                               "/church/editPayment", data);
//                           if (response.statusCode != 200) {
//                             setState(() {
//                               firstClick = true;
//                             });
//                             _scaffoldKey.currentState.showSnackBar(SnackBar(
//                                 backgroundColor: Colors.red[400],
//                                 content: Text("Error to update. Try once more"),
//                                 duration: Duration(seconds: 5)));
//                           } else {
//                             setState(() {
//                               firstClick = true;
//                             });
//                             _scaffoldKey.currentState.showSnackBar(SnackBar(
//                                 backgroundColor: Colors.green[400],
//                                 content:
//                                     Text("Payment Successfully updated"),
//                                 duration: Duration(seconds: 5)));
//                           }
//                         }
//                       },
//                       child: Text(
//                         "Update",
//                         style: TextStyle(
//                           // color: Colors.,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                   ]),
//             ),
//           ),
//         ));
//   }

//   Widget paymentTextField() {
//     return TextFormField(
//         smartDashesType: SmartDashesType.disabled,
//         controller: _name,
//         minLines: 10,
//         maxLines: null,
//         decoration: InputDecoration(
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(
//               color: Colors.teal,
//               width: 10.0,
//             )),
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.red[300], width: 3)),
//             helperStyle: TextStyle(color: Colors.grey[400]),
//             labelText: "Payment",
//             hintText: "Write a Payment for Belivers "));
//   }
// }
