import 'dart:io';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revels20/models/RegisteredEventsModel.dart';
import 'package:revels20/models/EventModel.dart';
import 'package:revels20/models/ScheduleModel.dart';
import 'package:revels20/pages/Login.dart';
import 'package:revels20/main.dart';

class RegisteredEvents extends StatefulWidget {
  @override
  RegisteredEventsState createState() => RegisteredEventsState();
}

class RegisteredEventsState extends State<RegisteredEvents> {
  List<RegisteredEventsData> allRegisteredEvents = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Registered Events"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: loadRegisteredEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildRegisteredEvents(context);
          }
        },
      ),
    );
  }

  _buildRegisteredEvents(context) {
    if (allRegisteredEvents.length == 0) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.topCenter,
              child: FlareActor(
                'assets/NoEvent.flr',
                animation: 'noEvents',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Text(
                "You have not yet registered for any event.",
                style: TextStyle(color: Colors.white54, fontSize: 18.0),
              ),
            )
          ],
        ),
      );
    } else
      return Container(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0, 2),
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: allRegisteredEvents.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  color: Colors.white10,
                  child: InkWell(
                    child: ListTile(
                      title: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                  getEventNameFromID(
                                      allRegisteredEvents[index].eventId),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  )),
                            ),
                            Container(
                              color: Colors.lightBlueAccent,
                              width: 300.0,
                              height: 0.5,
                              margin: EdgeInsets.all(10.0),
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        "Team ID: ${allRegisteredEvents[index].teamId}",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 22.0),
                                      )),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(7.0)),
                            Container(
                              padding: EdgeInsets.only(left: 12.0),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [0.1, 0.3, 0.7, 0.9],
                                          colors: [
                                            Colors.blueAccent.withOpacity(0.9),
                                            Colors.blueAccent.withOpacity(0.7),
                                            Colors.blue.withOpacity(0.8),
                                            Colors.blue.withOpacity(0.6),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      onPressed: () {
                                        _scanQR(context,
                                            allRegisteredEvents[index].eventId);
                                      },
                                      child: Container(
                                        width: 100.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Add Member",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [0.1, 0.3, 0.7, 0.9],
                                          colors: [
                                            Colors.redAccent.withOpacity(0.9),
                                            Colors.redAccent.withOpacity(0.7),
                                            Colors.red.withOpacity(0.8),
                                            Colors.red.withOpacity(0.6),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      onPressed: () {
                                        _showLeaveTeamDialogue(
                                            allRegisteredEvents[index].teamId,
                                            context);
                                      },
                                      child: Container(
                                        width: 100.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Leave Team",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
  }

  Future _scanQR(context, evendId) async {
    var res;

    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        res = qrResult.replaceAll(" ", "+");
      });

      String result = res.toString();
      
      //result.replaceAll(" ","+");

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      var cookieJar = PersistCookieJar(
          dir: tempPath, ignoreExpires: true, persistSession: true);

      dio.interceptors.add(CookieManager(cookieJar));

      var resp = await dio
          .post("/addmember", data: {'eventid': evendId, 'delid': result});

      String msg;

      if (resp.statusCode == 200 && resp.data['success'] == true) {
        msg = "You have successfully added a member to your team";
      }

      else if (resp.data['msg'] == "Card for event not bought") {
        msg =
            "This user has not bought the card required for this particular event";
      }

      else if (resp.data['msg'] == "User already registered for event") {
        msg = "This user has already registered for this particular event";
      }

      else{
        msg = resp.data['msg'];
      }

      print(resp.data);

      print(result);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(msg),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
      return;
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          res = "Camera permission was denied";
        });
      } else {
        setState(() {
          res = "Unknown Error $ex";
        });
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(res),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
    } on FormatException {
      setState(() {
        res = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        res = "Unknown Error $ex";
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(res),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
    }
  }

  _showLeaveTeamDialogue(int teamId, contextt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to leave team $teamId?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No, I want to stay."),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            InkWell(
              child: Container(
                height: 30.0,
                width: 120.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.1, 0.3, 0.7, 0.9],
                      colors: [
                        Colors.redAccent.withOpacity(0.9),
                        Colors.redAccent.withOpacity(0.7),
                        Colors.red.withOpacity(0.8),
                        Colors.red.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.0)),
                child: new Text(
                  "Yes, I'm sure.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                _leaveTeam(teamId, contextt);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _leaveTeam(int teamId, context) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    dio.interceptors.add(CookieManager(cookieJar));

    var resp = await dio.post("/leaveteam", data: {"teamid": teamId});

    if (resp.statusCode == 200 && resp.data['success'] == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Team Left!"),
            content: Text("You have left the team $teamId"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
    }
    //if
  }

  loadRegisteredEvents() async {
    allRegisteredEvents = await _fetchRegisteredEvents();
    return "success";
  }

  _fetchRegisteredEvents() async {
    List<RegisteredEventsData> registeredEvents = [];

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    dio.interceptors.add(CookieManager(cookieJar));

    try {
      var resp = await dio.get("/registeredevents");

      if (resp.statusCode == 200) {

        if (resp.data['success'] == true) {
          for (var json in resp.data['data']) {
            RegisteredEventsData temp;

            var teamId = json['teamid'];
            var eventId = json['event'];
            var round = json['round'];
            var delId = json['delid'];

            temp = RegisteredEventsData(
                teamId: teamId, eventId: eventId, round: round, delId: delId);

            registeredEvents.add(temp);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return registeredEvents;
  }

  getEventNameFromID(int id) {
    for (var event in allEvents) {
      if (id == event.id) return event.name;
    }
  }
}
