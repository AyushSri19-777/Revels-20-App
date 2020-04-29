import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:revels20/pages/Home.dart';
import 'package:revels20/pages/Login.dart';
import './AutoComplete.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:url_launcher/url_launcher.dart';

String collname, initialLink;
bool inpassword = false;
int flag = 0;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool selected = true;
  double width1 = 265.0;

  Widget login() {
    return Text(
      'Register',
      style: TextStyle(color: Colors.white, fontSize: 18.0),
    );
  }

  String name, email, mobile, id;
  bool _autovalidate = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  _launchURL() async {
    const url = 'tel:+918076740513';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return /*(initialLink==null)?*/ MaterialApp(
      theme: ThemeData(
        accentColor: Colors.grey[900],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: Image.asset('assets/Revels20_logo.png'),
              alignment: Alignment.topCenter,
            ),
            Form(
              key: _key,
              autovalidate: _autovalidate,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.only(left: 0, right: 0, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validatename,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 247, 176, 124),
                            ),
                            hintText: 'Name',
                          ),
                          onChanged: (String val) {
                            name = val;
                          },
                        )),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validateemail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(
                              Icons.mail_outline,
                              color: Color.fromARGB(255, 247, 176, 124),
                            ),
                            hintText: 'Email ID',
                          ),
                          onChanged: (String val) {
                            email = val;
                          },
                        )),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validatephone,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(
                              Icons.phone,
                              color: Color.fromARGB(255, 247, 176, 124),
                            ),
                            hintText: 'Phone',
                          ),
                          onChanged: (String val) {
                            mobile = val;
                          },
                        )),
                    FlatButton(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.school,
                              color: Color.fromARGB(255, 247, 176, 124),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Text(
                                        collname == null
                                            ? 'Search for your college'
                                            : collname,
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                        maxLines: 3,
                                        overflow: TextOverflow.fade,
                                      )))),
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.info_outline),
                              color: Color.fromARGB(255, 247, 176, 124),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        content: new Text(
                                            "Please search for your college. \nIf college not present, please contact Outstation Management at om.revels20@gmail.com or Call"),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.call,
                                                    color: Color.fromARGB(
                                                        255, 247, 176, 124),
                                                    size: 18,
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                ),
                                                Text(
                                                  "Call",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 247, 176, 124)),
                                                )
                                              ],
                                            ),
                                            onPressed: () {
                                              _launchURL();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          new FlatButton(
                                            child: new Text(
                                              "Back",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 247, 176, 124)),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        collname = null;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AutoComplete()),
                        ).then((_) {
                          print(collname);
                        });
                      },
                    ),
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          validator: validateid,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            icon: Icon(
                              Icons.confirmation_number,
                              color: Color.fromARGB(255, 247, 176, 124),
                            ),
                            hintText: 'Reg. No./Faculty ID',
                          ),
                          onChanged: (String val) {
                            id = val;
                          },
                        )),
                    Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: width1,
                        height: 40,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.1, 0.3, 0.7, 0.9],
                                  colors: [
                                    Colors.blueAccent.withOpacity(0.9),
                                    Colors.blueAccent.withOpacity(0.7),
                                    Colors.lightBlueAccent.withOpacity(0.8),
                                    Colors.lightBlueAccent.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: flag != 1 ? login() : progress(),
                              onPressed: () {
                                if (_key.currentState.validate()) {
                                  setState(() {
                                    flag = 1;
                                  });
                                  _sendToServer();
                                } else {
                                  setState(() {
                                    _autovalidate = true;
                                    checkCircular = 0;
                                  });
                                }
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ); /*:Password();*/
  }

  Widget progress() {
    return Container(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent
                /* Colors.transparent*/)));
  }

  int checkCircular = 0;
  String validatename(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      checkCircular = 1;
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      checkCircular = 1;
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatephone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      checkCircular = 1;
      return "Mobile is Required";
    } else if (value.length != 10) {
      checkCircular = 1;
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      checkCircular = 1;
      return "Mobile Number must be digits";
    }
    return null;
  }

  String validateemail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      checkCircular = 1;
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      checkCircular = 1;
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validateid(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      checkCircular = 1;
      return "ID is required is Required";
    } else if (!regExp.hasMatch(value)) {
      checkCircular = 1;
      return "Enter a Valid ID";
      // return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validatecollegename(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      checkCircular = 1;
      return "College Name is Required";
    } else if (!regExp.hasMatch(value)) {
      checkCircular = 1;
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      selected = false;
      print(collname);
      if (selected)
        width1 = 265;
      else {
        String token = key;
        String type = "invisible";
        var response =
            await dio.post("https://register.mitrevels.in/signup/", data: {
          "name": name,
          "email": email,
          "regno": id,
          "collname": collname,
          "mobile": mobile,
          'g-recaptcha-response': token,
          'type': type
        });
        if (response.data['success'] == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Success!"),
                content: new Text(
                    "User Registered Successully.\nPlease Check your email and click on the link!"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      setState(() {
                        flag = 0;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (response.data['success'] == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[900],
                title: new Text("Alert!!"),
                content: new Text(response.data['msg']),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Try Again"),
                    onPressed: () {
                      //initUniLinks();

                      Navigator.of(context).pop();
                      setState(() {
                        flag = 0;
                      });
                    },
                  ),
                ],
              );
            },
          );
        }

        print(response.statusCode);
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
