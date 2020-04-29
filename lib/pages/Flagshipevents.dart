import 'dart:io';
import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revels20/models/ScheduleModel.dart';
import 'package:revels20/pages/Login.dart';
import 'package:shimmer/shimmer.dart';
import 'package:revels20/models/EventModel.dart';
import '../main.dart';

Color skn = Color.fromRGBO(247, 176, 124, 1);

class FeaturedEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeaturedState(),
      theme: ThemeData(
          canvasColor: Colors.black,
          brightness: Brightness.dark,
          fontFamily: 'Product-Sans',
          accentColor: Color.fromRGBO(247, 176, 124, 1)),
    );
  }
}

//void main() => runApp(Dashboard());
class FeaturedState extends StatefulWidget {
  @override
  _LostFeatureState createState() => _LostFeatureState();
}

List<String> flagStrings = [
  "MIT Debate Tournament (Teams)",
  "Groove",
  "Battle of Bands",
  "Desi Tadka",
  "Nukkad Natak",
  "Curtain Call",
  "The Fashion Show",
  "Mr. and Ms. Revels"
];

List<EventData> renderEvents = [];

class _LostFeatureState extends State<FeaturedState> {
  Widget rate(BuildContext context, {int price}) {
    int val = (price <= 75000 && price > 45000)
        ? 3
        : (price <= 45000 && price > 30000) ? 2 : 1;
    int duration = 3 ~/ val;
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        period: Duration(seconds: duration),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                child: SizedBox(
                  height: 3.0,
                  width: 30.0,
                  //width: MediaQuery.of(context).size.width/12,
                ),
              ),
            ]),
            Column(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                child: SizedBox(
                  height: 3.0,
                  width: 30.0,
                  //width: MediaQuery.of(context).size.width/12,
                ),
              ),
            ])
          ],
        ),
        baseColor: Color.fromRGBO(212, 175, 55, 1),
        highlightColor: Colors.brown);
  }

  Widget myItems(IconData icon, String heading, {price = 30000}) {
    Color color = Color.fromRGBO(Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255), 1);
    return GestureDetector(
      onTap: () {
        print('BackHere');
        int index = -1;
        print(heading);
        for (var ind in renderEvents) {
          index++;
          print(ind.name);
          if (ind.name.toLowerCase() == heading.toLowerCase()) {
            break;
          }
        }
        print(index);
        print(renderEvents.length);
        _newTaskModalBottomSheet(context, renderEvents[index], price);
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white10,
            ),
            height: 200.0,
            child: Center(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            //  borderRadius: BorderRadius.circular(50.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(247, 176, 124, 1)),
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Shimmer.fromColors(
                                    direction: ShimmerDirection.ttb,
                                    period: Duration(seconds: 2),
                                    baseColor: Colors.black,
                                    highlightColor:
                                        Color.fromRGBO(247, 176, 124, 1),
                                    child: Icon(
                                      icon,
                                      color: Colors.redAccent,
                                      size: 30.0,
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              heading,
                              style: TextStyle(
                                color: Color.fromRGBO(247, 176, 124, 1),
                                fontSize: 15.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          rate(context, price: price)
                        ],
                      )
                    ],
                  )),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: money(price: price))
        ],
      ),
    );
  }

  String getcategoryname(int catid) {
    for (int i = 0; i < allCategories.length; i++) {
      if (allCategories[i].id == catid) {
        return allCategories[i].name;
      }
    }
    return 'Revels';
  }

  void _newTaskModalBottomSheet(context, EventData event, int price) {
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
                          child: Text(event.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.white)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Divider(
                            color: skn,
                            thickness: 1.0,
                          ),
                        ),
                        Container(
                          //height: 20,
                          child: Text(getcategoryname(event.categoryId),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white70)),
                        ),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: getDetails(context, event, price),
                ),
              ],
            ),
          );
        });
  }

  Row money(
      {int price: 3000, Color color: const Color.fromRGBO(212, 175, 55, 1)}) {
    int val = (price <= 75000 && price > 45000)
        ? 3
        : (price <= 45000 && price > 10000) ? 2 : 1;
    return Row(
      children: List.generate(
          val,
          (context) => Container(
                padding: EdgeInsets.all(1.5),
                child: Text(
                  '₹',
                  style: TextStyle(color: color, fontSize: 14.0),
                ),
              )),
    );
  }

  _getflagEvents() {
    print("Inside Get Flag Events \n");
    print("The length of allEvents = ${allEvents.length}");
    print("The lenght of flagStrings = ${flagStrings.length}");
    for (var event in allEvents) {
      for (var item in flagStrings) {
        print('Item = $item    Event = ${event.name.toString()}');
        if (item.toLowerCase() == event.name.toString().toLowerCase()) {
          renderEvents.add(event);
        }
      }
    }
    renderEvents.toSet().toList();
    print(renderEvents.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Inside the init\n");
    _getflagEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(
          "Featured Events",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        physics: ScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          myItems(Icons.vpn_key, "MITDT", price: 75000),
          myItems(Icons.music_note, "GROOVE", price: 37000),
          myItems(Icons.graphic_eq, "BATTLE OF BANDS", price: 26000),
          myItems(Icons.message, "DESI TADKA", price: 22000),
          myItems(Icons.add, "NUKKAD NATAK", price: 33000),
          myItems(Icons.settings, "CURTAIN CALL", price: 30000),
          myItems(Icons.face, "THE FASHION SHOW", price: 40000),
          myItems(Icons.dashboard, "MR. AND MS. REVELS", price: 12000),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 150.0),
        ],
      ),
    );
  }
}

Row money(
    {int price: 3000, Color color: const Color.fromRGBO(212, 175, 55, 1)}) {
  int val = (price <= 75000 && price > 45000)
      ? 3
      : (price <= 45000 && price > 10000) ? 2 : 1;
  return Row(
    children: List.generate(
        val,
        (context) => Container(
              padding: EdgeInsets.all(1.5),
              child: Text(
                '₹',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            )),
  );
}

String getdelegatecard(int delid) {
  for (int i = 0; i < allCards.length; i++) {
    if (allCards[i].id == delid) {
      return allCards[i].name;
    }
  }
  return 'Delegate Card';
}

Widget getDetails(context, EventData event, int price) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.6,
    color: Color.fromARGB(255, 20, 20, 20),
    child: ListView(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: EdgeInsets.all(24.0),
//          height: MediaQuery.of(context).size.height,
          child: Shimmer.fromColors(
            child: Text(
              "₹ $price",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            baseColor: Color.fromRGBO(212, 175, 55, 1),
            highlightColor: Colors.brown,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: getCanRegister(event.id) == 1
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.1, 0.9],
                        colors: [
                          skn.withOpacity(0.8),
                          skn.withOpacity(1),
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
                          : _registerForEvent(event.id, context);
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
            '(Delegate Card : ${getdelegatecard(event.delCardType)})',
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
                              height:
                                  30.0 * event.minTeamSize / event.minTeamSize,
                              width:
                                  30.0 * event.minTeamSize / event.minTeamSize,
                              decoration: BoxDecoration(
                                border: Border.all(color: skn, width: 2),
                                shape: BoxShape.circle,
                                // color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height:
                                  30.0 * event.minTeamSize / event.minTeamSize,
                              width:
                                  30.0 * event.minTeamSize / event.minTeamSize,
                              child: Center(
                                child: Text(event.minTeamSize.toString(),
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
                          color: skn,
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 +
                                  (5 * event.maxTeamSize / event.minTeamSize),
                              width: 30.0 +
                                  (5 * event.maxTeamSize / event.minTeamSize),
                              decoration: BoxDecoration(
                                border: Border.all(color: skn, width: 2),
                                shape: BoxShape.circle,
                              )),
                          Container(
                              height: 30.0 +
                                  (5 * event.maxTeamSize / event.minTeamSize),
                              width: 30.0 +
                                  (5 * event.maxTeamSize / event.minTeamSize),
                              child: Center(
                                child: Text(event.maxTeamSize.toString(),
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
                //  height: 200,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Text(
                    event.longDescription.length == 0
                        ? event.shortDescription
                        : event.longDescription,
                    style: TextStyle(color: Colors.white70, fontSize: 16.0),
                    textAlign: TextAlign.center)),
            Container(height: 25)
          ],
        ),
      ],
    ),
  );
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
              "It seems like you have not bought the Delegate Card required for ${getEventNameFromID(eventId)}.\n\nPlease head over to our Delegate Card section and purchase the ${getCardFromEventId(eventId)} card."),
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

getCardFromEventId(int id) {
  EventData temp;

  for (var event in allEvents) {
    if (event.id == id) {
      temp = event;
    }
  }

  for (var card in allCards) {
    if (temp.delCardType == card.id) {
      return card.name;
    }
  }
}

getEventNameFromID(int id) {
  print(allEvents.length);

  for (var event in allEvents) {
    if (id == event.id) return event.name;
  }
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

getEventDescription(ScheduleData scheduleData) {
  for (var i in allEvents) {
    if (i.id == scheduleData.eventId) {
      return i.longDescription;
    }
  }
}
