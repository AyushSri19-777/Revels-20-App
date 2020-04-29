import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:revels20/models/EventModel.dart';
import '../main.dart';

class FeaturedEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeaturedState(),
    );
  }
}

//void main() => runApp(Dashboard());
class FeaturedState extends StatefulWidget {
  @override
  _LostFeatureState createState() => _LostFeatureState();
}

List<String> flagStrings = [
  "MITDT",
  "Groove",
  "Battle of Bands",
  "Desi Tadka",
  "Nukkad Natak",
  "Curtain Call",
  "Fashion Show",
  "Mr. and Mrs. Revels"
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
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
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: Colors.grey[850],
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
                          Material(
                            color: color,
                            borderRadius: BorderRadius.circular(50.0),
                            child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Shimmer.fromColors(
                                    direction: ShimmerDirection.ttb,
                                    period: Duration(seconds: 2),
                                    baseColor: Colors.black,
                                    highlightColor: color,
                                    child: Icon(
                                      icon,
                                      color: Colors.white,
                                      size: 30.0,
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              heading,
                              style: TextStyle(
                                color: color,
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
                                  fontSize: 22.0, color: Colors.white)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Divider(
                            color: Color.fromARGB(255, 22, 159, 196),
                            thickness: 3.0,
                          ),
                        ),
                        Container(
                          height: 20,
                          child: Text(getcategoryname(event.categoryId),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
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
          style: TextStyle(color: Colors.white),
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
          myItems(Icons.face, "FASHION SHOW", price: 40000),
          myItems(Icons.dashboard, "MR. AND MRS. REVELS", price: 12000),
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
    color: Color.fromARGB(255, 20, 20, 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Shimmer.fromColors(
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
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            'Delegate Card : ' + getdelegatecard(event.delCardType),
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(10),
        ),
        Center(
          child: Container(
            width: 260,
            height: 50,
            child: Container(
                child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              color: Color.fromARGB(255, 22, 159, 196),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {},
            )),
          ),
        ),
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
          //    height: 200,
              width: MediaQuery.of(context).size.width / 1.2,
              child: ListView(
                children: <Widget>[
                  Text(event.longDescription,
                      style: TextStyle(color: Colors.white70, fontSize: 16.0),
                      textAlign: TextAlign.center)
                ],
              ),
            )
          ],
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
                                border: Border.all(
                                  color: Color.fromARGB(255, 22, 159, 196),
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 22, 159, 196),
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
                        width: 30.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          shape: BoxShape.rectangle,
                          color: Color.fromARGB(255, 22, 159, 196),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0 +
                                  (5 * event.maxTeamSize / event.maxTeamSize),
                              width: 30.0 +
                                  (5 * event.maxTeamSize / event.maxTeamSize),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 22, 159, 196),
                                ),
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 22, 159, 196),
                              )),
                          Container(
                              height: 30.0 +
                                  (5 * event.maxTeamSize / event.maxTeamSize),
                              width: 30.0 +
                                  (5 * event.maxTeamSize / event.maxTeamSize),
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
      ],
    ),
  );
}
