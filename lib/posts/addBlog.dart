import 'package:pilasa_church/Model/addBlogModels.dart';
import "package:flutter/material.dart";
import 'package:pilasa_church/NetworkHandler.dart';
import 'package:pilasa_church/mainPages/HomePage.dart';

class AddBlog extends StatefulWidget {
  @override
  _AddBlogState createState() => _AddBlogState();
}

class Item {
  const Item(this.name, this.icon, this.colorCode);
  final String name;
  final Icon icon;
  final String colorCode;
}

class _AddBlogState extends State<AddBlog> {
  String bgColor = '#f6f5f5'.replaceAll('#', '0xff');
  String titleColor = '#aa3a3a'.replaceAll('#', '0xff');
  String textColor = '#f6f5f5'.replaceAll('#', '0xff');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _blogBody = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkhandler = NetworkHandler();
  bool _firstClick = true;
  IconData iconPhoto = Icons.image;
  Item selectedColor;
  String pickColor = '0xFFFFFFFF';

  List<Item> color = <Item>[
    const Item(
        'white',
        Icon(
          Icons.brightness_1,
          color: Colors.white,
        ),
        '0xFFFFFFFF'),
    const Item('lightGreen', Icon(Icons.brightness_1, color: Colors.green),
        "0xFFAED581"),
    const Item('lightBlue', Icon(Icons.brightness_1, color: Colors.blue),
        "0xFF80DEEA"),
    const Item(
        'yellow',
        Icon(
          Icons.brightness_1,
          color: Colors.yellow,
        ),
        "0xFFDCE775"),
    const Item(
        'purple',
        Icon(
          Icons.brightness_1,
          color: Colors.purple,
        ),
        "0xFFCE93D8"),
    const Item('BlueGray', Icon(Icons.brightness_1, color: Colors.blueGrey),
        "0xFFCFD8DC"),
    const Item(
        'Orange',
        Icon(
          Icons.brightness_1,
          color: Colors.deepOrange,
        ),
        "0xFFFFAB91"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(int.parse(titleColor)),
        title: Text("Add post"),
        centerTitle: true,
      ),
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              DropdownButton<Item>(
                focusColor: Colors.blue,
                hint: Text("Select A Colour"),
                value: selectedColor,
                onChanged: (Item value) {
                  setState(() {
                    selectedColor = value;
                    pickColor = value.colorCode;
                  });
                },
                items: color.map((Item user) {
                  return DropdownMenuItem<Item>(
                    value: user,
                    child: Row(
                      children: <Widget>[
                        user.icon,
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              bodyTextField(),
              Text("NB: The Post will be Automatically remove after 7 Days",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
              SizedBox(
                height: 10,
              ),
              addButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        style: TextStyle(fontSize: 16),
        maxLength: 100,
        minLines: 2,
        maxLines: 4,
        controller: _blogBody,
        validator: (value) {
          if (value.isEmpty) return "Body can't be empty";
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor:
              pickColor != null ? Color(int.parse(pickColor)) : Colors.white,
          // pickColor != null ? Color(int.parse(pickColor)) : Colors.white,
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )),
          labelText: "Write the content to share ",
        ),
        // maxLines: null,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        if (_globalKey.currentState.validate()) {
          if (_firstClick) {
            setState(() {
              _firstClick = false;
            });
            AddBlogModel addBlogModels =
                AddBlogModel(color: pickColor, content: _blogBody.text);
            var response = await networkhandler.post1(
                "/church/insertPost", addBlogModels.toJson());
            if (response.statusCode == 200 || response.statusCode == 201) {
              // ignore: deprecated_member_use
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                  backgroundColor: Colors.green[400],
                  content: Text("Image Successfully updated "),
                  duration: Duration(seconds: 5)));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            } else {
              setState(() {
                _firstClick = true;
              });
              // ignore: deprecated_member_use
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                  backgroundColor: Colors.red[400],
                  content: Text("Error to upload. try Once more"),
                  duration: Duration(seconds: 5)));
            }
          }
        }
      },
      child: Center(
          child: Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(int.parse(titleColor))),
        child: Center(
          child: Text(
            "Publish Post",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      )),
    );
  }
}
