import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:revels20/models/EventModel.dart';
import 'package:revels20/pages/Login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import '../main.dart';

List tags = <String>[
  'Music',
  'English',
  'Solo',
  'Hindi',
  'Other',
  'Painting',
  'Anime',
  'Public Speaking',
  'Gaming',
  'Comedy',
  'Bands',
  'Adventure',
  'Dance',
  'Drama',
  'Photography',
  'Fashion',
  'Sports'
];
List tagselected = <bool>[
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
List rendertags = <String>[];
Map eventlist = {};
List renderevents = [];
MediaQueryData deviceinfo;

String getcategoryname(int catid) {
  for (int i = 0; i < allCategories.length; i++) {
    if (allCategories[i].id == catid) {
      return allCategories[i].name;
    }
  }
  return 'Revels';
}

String getdelegatecard(int delid) {
  for (int i = 0; i < allCards.length; i++) {
    if (allCards[i].id == delid) {
      return allCards[i].name;
    }
  }
  return 'Delegate Card';
}

class Sample2 extends StatefulWidget {
  @override
  _Sample2State createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  ScrollController sc = new ScrollController();
  bool done = false;

  Future<Map> fetchEvents() async {
    http.Response response = await http.get('https://api.mitrevels.in/events');

    return json.decode(response.body);
  }

  void getrenderevents() {
    rendertags = [];
    renderevents = [];
    for (int i = 0; i < tags.length; i++) {
      if (tagselected[i]) rendertags.add(tags[i]);
    }
    if (eventlist != null) {
      if (rendertags.length == 0) {
        for (int i = 0; i < eventlist['data'].length; i++)
          renderevents.add(eventlist['data'][i]);
      } else
        for (int i = 0; i < eventlist['data'].length; i++) {
          for (int j = 0; j < rendertags.length; j++)
            if (eventlist['data'][i]['tags'].contains(rendertags[j])) {
              renderevents.add(eventlist['data'][i]);
            }
        }
      renderevents = renderevents.toSet().toList();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    rendertags = [];
    tagselected = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceinfo = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Container(
              height: 70,
              child: ListView.builder(
                  itemCount: tags.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                        color: Colors.grey[900],
                        margin: EdgeInsets.only(
                            left: 0, bottom: 15, top: 10, right: 10),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: (tagselected[index])
                              ? Color.fromARGB(255, 44, 183, 233)
                              : Colors.black,
                          child: Text(
                            tags[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            tagselected[index] = !tagselected[index];
                            getrenderevents();
                            setState(() {});
                          },
                        ));
                  })),
        ),
        body: FutureBuilder(
            future: fetchEvents(),
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
              Map content = snapshot.data;
              eventlist = content;
              getrenderevents();
              return (eventlist != null)
                  ? Center(
                      child: Container(
                          width: deviceinfo.size.width,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                          child: ListView.builder(
                              controller: sc,
                              itemCount: renderevents.length,
                              addRepaintBoundaries: true,
                              //primary: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      _newTaskModalBottomSheet(
                                          context, renderevents[index]);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          20.0, 20.0, 20.0, 0.0),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(43, 42, 42, 0.8),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 5.0,
                                            ),
                                          ]),
                                      width: deviceinfo.size.width,
                                      height: 100.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  renderevents[index]['name'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                width: deviceinfo.size.width *
                                                    0.65,
                                                alignment: Alignment.center,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                height: 0.5,
                                                color: Color.fromARGB(
                                                    255, 22, 159, 196),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      left: 5,
                                                      right: 5),
                                                  width: deviceinfo.size.width *
                                                      0.65,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    getcategoryname(
                                                        renderevents[index]
                                                            ['category']),
                                                    style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 16,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ))
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 20.0, 10.0, 20.0),
                                            child: Icon(
                                              Icons.info_outline,
                                              color: Color.fromARGB(
                                                      255, 22, 159, 196)
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              })))
                  : Container(
                      decoration: BoxDecoration(color: Colors.black),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Shimmer.fromColors(
                              highlightColor: Color.fromARGB(255, 22, 159, 196),
                              baseColor: Colors.black,
                              child: ImageIcon(
                                AssetImage('assets/Revels20_logo.png'),
                                size: 300.0,
                              ))));
            }));
  }
}

getCanRegister(int id) {
  print(allEvents.length);

  for (var event in allEvents) {
    print(event.canRegister);
    if (event.id == id) {
      return event.canRegister;
    }
  }
}

void _newTaskModalBottomSheet(context, event) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          color: Color.fromARGB(255, 20, 20, 20),
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                  color: Color.fromARGB(255, 20, 20, 20),
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text(event['name'],
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Divider(
                          color: Color.fromARGB(255, 22, 159, 196)
                              .withOpacity(0.75),
                          thickness: 1.0,
                        ),
                      ),
                      Container(
                        //height: 20,
                        child: Text(getcategoryname(event['category']),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white70)),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: getDetails(context, event),
              ),
            ],
          ),
        );
      });
}

Widget getDetails(context, event) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.6,
    color: Color.fromARGB(255, 20, 20, 20),
    child: ListView(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: getCanRegister(event['id']) == 1
              ? Container(
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
                      borderRadius: BorderRadius.circular(4.0)),
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      !isLoggedIn
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Oops!"),
                                  content: Text(
                                      "It seems like you are not logged in, please login first in our user section."),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : _registerForEvent(event, context);
                    },
                    child: Container(
                      width: 300.0,
                      alignment: Alignment.center,
                      child: Text(
                        "Register Now",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Registerations for this event are closed.",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 10.0),
          child: Text(
            '(Delegate Card : ${getdelegatecard(event['delCardType'])})',
            style: TextStyle(color: Colors.white70, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Text('Team Size: ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 *
                                  event['minTeamSize'] /
                                  event['minTeamSize'],
                              width: 30.0 *
                                  event['minTeamSize'] /
                                  event['minTeamSize'],
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent, width: 2),
                                shape: BoxShape.circle,
                                // color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height: 30.0 *
                                  event['minTeamSize'] /
                                  event['minTeamSize'],
                              width: 30.0 *
                                  event['minTeamSize'] /
                                  event['minTeamSize'],
                              child: Center(
                                child: Text(event['minTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                      Container(
                        width: 60.0,
                        height: 2.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          shape: BoxShape.rectangle,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 +
                                  (5 *
                                      event['maxTeamSize'] /
                                      event['minTeamSize']),
                              width: 30.0 +
                                  (5 *
                                      event['maxTeamSize'] /
                                      event['minTeamSize']),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent, width: 2),
                                shape: BoxShape.circle,
                              )),
                          Container(
                              height: 30.0 +
                                  (5 *
                                      event['maxTeamSize'] /
                                      event['minTeamSize']),
                              width: 30.0 +
                                  (5 *
                                      event['maxTeamSize'] /
                                      event['minTeamSize']),
                              child: Center(
                                child: Text(event['maxTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Text(
                'Description:',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20.0),
                //   height: 200,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Text(
                    event['longDesc'].length == 0
                        ? event['shortDesc']
                        : event['longDesc'],
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                    textAlign: TextAlign.center)),
            Container(height: 25)
          ],
        ),
      ],
    ),
  );
}

_registerForEvent(event, context) async {
  print("tapped");

  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;

  var cookieJar = PersistCookieJar(
      dir: tempPath, ignoreExpires: true, persistSession: true);

  dio.interceptors.add(CookieManager(cookieJar));
  var response = await dio.post("/createteam", data: {"eventid": event['id']});

  print(response.statusCode);
  print(response.data);

  if (response.statusCode == 200 && response.data['success'] == true) {
    print("object");
    firebaseMessaging.subscribeToTopic('event-${event['id']}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Success!"),
          content: Text(
              "You have successfully registered for ${event['id']}. Your team ID is ${response.data['data']}"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else if (response.statusCode == 200 &&
      response.data['msg'] == "User already registered for event") {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Oops!"),
          content: Text(
              "It seems like you have already registered for ${event['name']}. Check your registered events in the User Section."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else if (response.statusCode == 200 &&
      response.data['msg'] == "Card for event not bought") {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Oops!"),
          content: Text(
              "It seems like you have not bought the Delegate Card required for ${event['name']}.\n"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Oops!"),
          content: Text(
              "Whoopsie there seems to be some error. Please check your connecting and try"),
          actions: <Widget>[
            new FlatButton(
              child: new Text(""),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
