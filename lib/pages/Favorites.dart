import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:revels20/main.dart";
import 'package:revels20/models/CategoryModel.dart';
import 'package:revels20/models/ScheduleModel.dart';
import 'package:revels20/pages/Login.dart';
import 'package:url_launcher/url_launcher.dart';

import "../main.dart";

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> with TickerProviderStateMixin {
  bool isFABTapped = false;

  // @override
  // bool get wantKeepAlive => true;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch("url");
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    //  _getFavoriteList();
    // TODO: implement initState
    super.initState();
  }

  // _getFavoriteList() async {
  //   preferences = await SharedPreferences.getInstance();
  //   favoriteList = preferences.getStringList("favoriteEvents") ?? ["-1", "0"];
  // }

  @override
  Widget build(BuildContext context) {
    try {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Favorites"),
            backgroundColor: Colors.black,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                _buildTab("Day 1", "04-03-2020"),
                _buildTab("Day 2", "05-03-2020"),
                _buildTab("Day 3", "06-03-2020"),
                _buildTab("Day 4", "07-03-2020"),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: <Widget>[
                _buildCard(
                    favoriteScheduleForDay(allSchedule, 'Wednesday'), context),
                _buildCard(
                    favoriteScheduleForDay(allSchedule, 'Thursday'), context),
                _buildCard(
                    favoriteScheduleForDay(allSchedule, 'Friday'), context),
                _buildCard(
                    favoriteScheduleForDay(allSchedule, 'Saturday'), context),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            "There appears to be some error, don't panic. Just toggle between tabs or restart the app. \n\n$e ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }
  }

  List<ScheduleData> favoriteScheduleForDay(
      List<ScheduleData> allSchedule, String day) {
    List<ScheduleData> temp = [];

    switch (day) {
      case 'Wednesday':
        for (var i in allSchedule) {
          if (i.startTime.day == 4) {
            for (var j in favoriteEvents) {
              if (i.name == j) {
                temp.add(i);
              }
            }
          }
        }
        break;

      case 'Thursday':
        for (var i in allSchedule) {
          if (i.startTime.day == 5) {
            for (var j in favoriteEvents) {
              if (i.name == j) {
                temp.add(i);
              }
            }
          }
        }
        break;

      case 'Friday':
        for (var i in allSchedule) {
          if (i.startTime.day == 6) {
            for (var j in favoriteEvents) {
              if (i.name == j) {
                temp.add(i);
              }
            }
          }
        }
        break;

      case 'Saturday':
        for (var i in allSchedule) {
          if (i.startTime.day == 7) {
            for (var j in favoriteEvents) {
              if (i.name == j) {
                temp.add(i);
              }
            }
          }
        }
        break;

      default:
        print("ERROR IN DAY WISE PARSINGG");
        break;
    }

    return temp;
  }

  Widget _buildTab(String day, String date) => Tab(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                day,
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 9.0,
                    color: Colors.white54,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 9.0,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _registerForEvent(int eventId, context) async {
    print("tapped");
    print(eventId);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    dio.interceptors.add(CookieManager(cookieJar));
    var response = await dio.post("/createteam", data: {"eventid": eventId});

    print(response.statusCode);
    print(response.data);

    if (response.statusCode == 200 && response.data['success'] == true) {
      print("object");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Success!"),
            content: Text(
                "You have successfully registered for ${getEventNameFromID(eventId)}. Your team ID is ${response.data['data']}"),
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
                "It seems like you have already registered for ${getEventNameFromID(eventId)}. Check your registered events in the User Section."),
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
                "It seems like you have not bought the Delegate Card required for ${getEventNameFromID(eventId)}."),
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

  getEventNameFromID(int id) {
    print(allEvents.length);

    for (var event in allEvents) {
      if (id == event.id) return event.name;
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

  _showBottomModalSheet(BuildContext context, ScheduleData schedule) {
    TabController _controller = TabController(length: 2, vsync: this);

    CategoryData scheduleCategory;

    for (var i in allCategories) {
      if (schedule.categoryId == i.id)
        scheduleCategory = CategoryData(
          id: i.id,
          eventIds: i.eventIds,
          name: i.name,
          shortDescription: i.shortDescription,
          longDescription: i.longDescription,
          type: i.type,
          cc1Name: i.cc1Name,
          cc2Name: i.cc2Name,
          cc1Contact: i.cc1Contact,
          cc2Contact: i.cc2Contact,
        );
    }

    print(schedule.name);
    print(getCanRegister(schedule.eventId));

    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: Text(
                      schedule.name,
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: getCanRegister(schedule.eventId) == 1
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
                                    : _registerForEvent(
                                        schedule.eventId, context);
                              },
                              child: Container(
                                width: 300.0,
                                alignment: Alignment.center,
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
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
                  TabBar(
                    controller: _controller,
                    tabs: <Widget>[
                      Tab(
                        text: "Event",
                      ),
                      Tab(
                        text: "Description",
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    //color: Colors.black,
                    child: TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        ListView(
                          children: <Widget>[
                            _buildEventListTileInfo(Icon(Icons.assessment),
                                "Round:", schedule.round.toString()),
                            _buildEventListTileInfo(Icon(Icons.category),
                                "Category:", scheduleCategory.name),
                            _buildEventListTileInfo(
                                Icon(Icons.calendar_today),
                                "Date:",
                                '${schedule.startTime.day.toString()}-${schedule.startTime.month.toString()}-${schedule.startTime.year.toString()}'),
                            _buildEventListTileInfo(
                                Icon(Icons.timer), "Time:", getTime(schedule)),
                            _buildEventListTileInfo(Icon(Icons.location_on),
                                "Venue:", schedule.location),
                            _buildEventListTileInfo(
                                Icon(Icons.credit_card),
                                "Delegate Card",
                                getDelCardNameFromEventID(schedule.eventId) ??
                                    "unavailable"),
                            _buildEventListTileInfo(Icon(Icons.people),
                                "Team Size:", getTeamSize(schedule)),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                              height: 0.5,
                              width: 100.0,
                              color: Colors.blueAccent,
                            ),
                            _buildEventListTileInfo(
                                Icon(Icons.phone), "Contact:", ""),
                            _buildEventListTileInfo(
                                null,
                                "${scheduleCategory.cc1Name}",
                                "${scheduleCategory.cc1Contact}"),
                            _buildEventListTileInfo(
                                null,
                                "${scheduleCategory.cc2Name}",
                                "${scheduleCategory.cc2Contact}")
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: Icon(Icons.subject),
                            title: Text(
                              getEventDescription(schedule),
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  getEventDescription(ScheduleData scheduleData) {
    for (var i in allEvents) {
      if (i.id == scheduleData.eventId) {
        return i.longDescription == "" ? i.shortDescription : i.longDescription;
      }
    }
  }

  getTeamSize(ScheduleData scheduleData) {
    for (var i in allEvents) {
      if (i.id == scheduleData.eventId) {
        return (i.maxTeamSize == i.minTeamSize)
            ? i.maxTeamSize.toString()
            : '${i.minTeamSize} - ${i.maxTeamSize}';
      }
    }
  }

  Widget _buildEventListTileInfo(Icon icon, String title, String value) {
    return Material(
      color: Colors.black,
      child: ListTile(
        onTap: () {},
        leading: icon,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title == "null" ? "unavailable" : title,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                ),
              ),
              Container(
                width: 140.0,
                child: Text(
                  value == "null" ? "unavailable" : value,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getVisibleFrom(int id) {
    for (var event in allEvents) {
      if (event.id == id) {
        return event.visible;
      }
    }
  }

  Widget _buildCard(List<ScheduleData> allSchedule, BuildContext context) {
    // for (var i in allSchedule){
    //   i.
    // }

    return Container(
      alignment: Alignment.center,
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(2.0, 0.0, 2, 2),
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
          itemCount: allSchedule.length,
          itemBuilder: (BuildContext context, int index) {
            if (getVisibleFrom(allSchedule[index].eventId) == 0) {
              return null;
            }

            return Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Card(
                color: Colors.white10,
                child: InkWell(
                  onTap: () {
                    _showBottomModalSheet(context, allSchedule[index]);
                    print(allSchedule[index].eventId);
                  },
                  child: ListTile(
                    title: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.backspace),
                                color: Colors.transparent,
                                onPressed: () {},
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 150),
                                child: Text(
                                    allSchedule[index].name ??
                                        "error i in name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(Icons.backspace),
                                color: Colors.transparent,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.blueAccent,
                            width: 500.0,
                            height: 1.0,
                            margin: EdgeInsets.all(10.0),
                          ),
                          Padding(padding: EdgeInsets.all(2.0)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(
                                        Icons.schedule,
                                        size: 12.0,
                                        color: Colors.blueAccent,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          getTime(allSchedule[index]),
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        size: 12.0,
                                        color: Colors.blueAccent,
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Text(
                                          allSchedule[index].location ?? "hhhh",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(7.0)),
                          Container(
                            padding: EdgeInsets.only(left: 5.0),
                            width: MediaQuery.of(context).size.width,
                            //  color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 80.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(
                                        Icons.assessment,
                                        size: 15.0,
                                      ),
                                      Text(
                                        "Round ${allSchedule[index].round}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20.0,
                                    color: Colors.blueAccent,
                                  ),
                                )
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

  displayAddedSnackbar(String str) {
    final snackBar = SnackBar(
      content: Text(
        'You\'ve added $str to your favourites!',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 400),
      backgroundColor: Colors.black,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  displayRemovedSnackbar(String str) {
    final snackBar = SnackBar(
      content: Text(
        'You\'ve removed $str from your favourites!',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 400),
      backgroundColor: Colors.black,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  isFav(String str) {
    try {
      for (var i in favoriteEvents) {
        if (str == i) {
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  _setFavoriteInUserInfo(List<String> temp) async {
    preferences = await SharedPreferences.getInstance();
    for (var i in temp) {
      print(i);
    }
    print("efefef!!!!!!!");
    setState(() {
      preferences.setStringList('favoriteEvents', temp);
    });
    setState(() {});
  }

  getDelCardNameFromEventID(int eventId) {
    int delId;
    for (var event in allEvents) {
      if (event.id == eventId) delId = event.delCardType;
    }

    for (var card in allCards) {
      if (card.id == delId) return card.name;
    }
  }
}
