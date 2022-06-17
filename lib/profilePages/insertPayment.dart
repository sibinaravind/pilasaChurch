// import "package:flutter/material.dart";
// import '../NetworkHandler.dart';

// class InsertPayment extends StatefulWidget {
//   InsertPayment({Key key, this.id, this.churchName}) : super(key: key);
//   final String id;
//   final String churchName;
//   @override
//   _InsertPaymentState createState() => _InsertPaymentState();
// }

// class _InsertPaymentState extends State<InsertPayment> {
//   final _globalKey = GlobalKey<FormState>();
//   String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
//   String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
//   String textColor = '#f6f5f5'.replaceAll('#', '0xff');
//   bool vis = true;
//   bool _firstclick = true;
//   String _errText1;
//   NetworkHandler networkHandler = NetworkHandler();
//   TextEditingController _name = TextEditingController();
//   TextEditingController _amt = TextEditingController();

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   String errorText;
//   bool validate = false;
//   bool circular = false;
//   bool dateCheck = false;
//   bool amtCheck = false;
//   @override
//   void initState() {
//     super.initState();
//     // Navigator.of(context).push(MaterialPageRoute(
//     //     builder: (context) =>
//     //         AccountAdd(id: widget.id, churchName: widget.churchName)));
//     // fetchInsertPayment();
//   }

//   void fetchInsertPayment() async {
//     var response = await networkHandler.get("/church/getInsertPayment");
//     Map<String, dynamic> output = response;
//     setState(() {
//       // _InsertPayment.text = output["announcemnt"];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Color(int.parse(titleColor)),
//           title: Text(
//             "InsertPayment",
//           ),
//           centerTitle: true,
//           actions: <Widget>[
//             Center(
//               child: InkWell(
//                   child: Text("Clear", style: TextStyle(fontSize: 20)),
//                   onTap: () => {
//                         setState(() {
//                           // _InsertPayment.text = '';
//                         })
//                       }),
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//             child: Container(
//           key: _globalKey,
//           child: Padding(
//             padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView(
//                 children: <Widget>[
//                   Center(
//                       child: Text("New Insert",
//                           style: TextStyle(
//                               fontSize: 25,
//                               color: Color(int.parse(titleColor)),
//                               fontWeight: FontWeight.bold))),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextFormField(
//                       validator: (value) {
//                         if (value.isEmpty) return "Name can't be empty";
//                         return null;
//                       },
//                       controller: _name,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                             color: Colors.teal,
//                           )),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(color: Colors.red[300], width: 3)),
//                           helperStyle: TextStyle(color: Colors.grey[400]),
//                           labelText: "Name to Display",
//                           errorText: _errText1)),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Text(
//                         "Date",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                       Checkbox(
//                         focusColor: Colors.grey,
//                         checkColor: Colors.green,
//                         activeColor: Color(int.parse(bgColor)),
//                         value: dateCheck,
//                         onChanged: (newValue) {
//                           setState(() => {dateCheck = newValue});
//                         },
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Text(
//                         "Fixed Amount",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                       Checkbox(
//                         focusColor: Colors.grey,
//                         checkColor: Colors.green,
//                         activeColor: Color(int.parse(bgColor)),
//                         value: amtCheck,
//                         onChanged: (newValue) {
//                           setState(() => {amtCheck = newValue});
//                           if (amtCheck) {
//                             TextFormField(
//                                 validator: (value) {
//                                   if (value.isEmpty)
//                                     return "Amount Can't be empty";
//                                   return null;
//                                 },
//                                 controller: _amt,
//                                 decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                       color: Colors.teal,
//                                     )),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.red[300], width: 3)),
//                                     helperStyle:
//                                         TextStyle(color: Colors.grey[400]),
//                                     labelText: "Amount",
//                                     errorText: _errText1));
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   FlatButton(
//                     onPressed: () async {
//                       if (_amt.text != '') {
//                         if (_name.text != '') {
//                           if (_firstclick) {
//                             setState(() {
//                               _firstclick = false;
//                             });
//                             // HolyMassModels holyMassModels = HolyMassModels(
//                             //     date: _selectedDay,
//                             //     time: (_amt.text).trim(),
//                             //     lang: _langContoller.text,
//                             //     remaining: int.parse(_numberOfSeats.text),
//                             //     seats: int.parse(_numberOfSeats.text));
//                             // var response = await networkHandler.post1(
//                             //     "/church/addMasses", holyMassModels.toJson());
//                             // if (response.statusCode == 200 ||
//                             //     response.statusCode == 201) {
//                             //   Navigator.of(context).pop();
//                             //   setState(() {
//                             //     _amt.text = '';
//                             //     listdata.add(holyMassModels);
//                             //   });
//                             // } else {
//                             //   setState(() {
//                             //     _firstclick = true;
//                             //   });
//                             // }
//                           }
//                         } else {
//                           setState(() {
//                             _errText1 = 'please fill the Date';
//                           });
//                         }
//                       }
//                     },
//                     child: Text("Add"),
//                     color: Colors.yellow,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         )));
//   }

//   Widget InsertPaymentTextField() {
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
//             labelText: "InsertPayment",
//             hintText: "Write a InsertPayment for Belivers "));
//   }
// }
