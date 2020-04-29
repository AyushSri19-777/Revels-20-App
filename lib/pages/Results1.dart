import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:revels20/models/EventModel.dart';
import 'package:revels20/models/ResultModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:revels20/pages/Login.dart';
import '../main.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

List<EventData> eventsWithResults;
List<EventData> eventsMatchingSearch;

class _ResultsState extends State<Results> with TickerProviderStateMixin {
  @override
  void initState() {
    print("object");
    _resultsForEvents();
    super.initState();
  }

  _resultsForEvents() {
    eventsWithResults = [];
    for (var result in allResults) {
      for (var event in allEvents) {
        if (result.eventId == event.id) {
          eventsWithResults.add(event);
        }
      }
    }

    eventsWithResults = eventsWithResults.toSet().toList();
    return eventsWithResults;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBarDelegate.buildSliverAppBar(
                  "Results", "assets/rr.jpg", context)
            ];
          },
          body: FutureBuilder(
            future: loadResults(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  height: 300.0,
                  width: 300.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              else {
                return eventsWithResults.length != 0
                    ? Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          children:
                              List.generate(eventsWithResults.length, (index) {
                            return _buildResultCard(context, index);
                          }),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Text("No Results available.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70)),
                      );
              }
            },
          ),
        ));
  }

  Future<String> loadResults() async {
    allResults = await _fetchResults();
    return "success";
  }

  _fetchResults() async {
    List<ResultData> results = [];

    preferences = await SharedPreferences.getInstance();

    var jsonData;

    var isCon;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isCon = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isCon = false;
    }

    try {
      String data = preferences.getString('Results') ?? null;

      if (data != null && !isCon) {
        print("here res");
        jsonData = jsonDecode(jsonDecode(data));
      } else {
        final response =
            await http.get(Uri.encodeFull("https://api.mitrevels.in/results"));

        if (response.statusCode == 200) jsonData = json.decode(response.body);
      }

      for (var json in jsonData['data']) {
        try {
          var eventId = json['event'];
          var teamId = json['teamid'];
          var position = json['position'];
          var round = json['round'];

          ResultData temp = ResultData(
            eventId: eventId,
            teamId: teamId,
            position: position,
            round: round,
          );

          results.add(temp);
        } catch (e) {
          print(e);
          print("error in parsing results");
        }
      }
    } catch (e) {
      print(e);
    }
    return results;
  }

  String _findNameOfEvent(int eventId) {
    for (var event in allEvents) {
      if (event.id == eventId) return event.name;
    }
  }

  Widget _buildResultCard(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          child: InkWell(
            onTap: () {
              _showResultsSheet(context, index);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 2.0,
                      height: 0.5,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.29),
                      child: Container(
                          height: 80.0,
                          alignment: Alignment.center,
                          child: Text(
                            eventsWithResults[index].name ?? "EEEEEEEE",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          )),
                    ),
                    Container(
                      color: Colors.blueAccent,
                      height: 0.5,
                      width: 50.0,
                    )
                  ],
                ),
                Container(
                  color:
                      (index % 3 != 2) ? Colors.blueAccent : Colors.transparent,
                  height: 50.0,
                  width: 0.5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showResultsSheet(context, index) {
    int maximum_Rounds = 0;
    for (var result in allResults) {
      if (result.eventId == eventsWithResults[index].id) {
        if (result.round > maximum_Rounds) maximum_Rounds = result.round;
      }
    }
    TabController _controller =
        TabController(length: maximum_Rounds, vsync: this);
    var flag = new List(6);
    for (int i = 0; i < maximum_Rounds; i++) {
      flag[i] = 1;
    }

    List<ResultData> roundOneResults = [];
    List<ResultData> roundTwoResults = [];
    List<ResultData> roundThreeResults = [];
    List<ResultData> roundFourResults = [];
    List<ResultData> roundFiveResults = [];
    List<ResultData> roundSixResults = [];

    for (var result in allResults) {
      if (result.eventId == eventsWithResults[index].id && result.round == 1)
        roundOneResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 2)
        roundTwoResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 3)
        roundThreeResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 4)
        roundFourResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 5)
        roundFiveResults.add(result);

      if (result.eventId == eventsWithResults[index].id && result.round == 6)
        roundSixResults.add(result);
    }

    roundOneResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });

    roundTwoResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });

    roundThreeResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });
    roundFourResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });
    roundFiveResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });
    roundSixResults.sort((a, b) {
      return a.position.compareTo(b.position);
    });

    List<List<ResultData>> roundList = [
      roundOneResults,
      roundTwoResults,
      roundThreeResults,
      roundFourResults,
      roundFiveResults,
      roundSixResults
    ];
    List<Container> tabContainers = new List(maximum_Rounds);
    List<Tab> tabList = new List(maximum_Rounds);
    for (int i = 0; i < maximum_Rounds; i++) {
      tabList[i] = Tab(
        icon: Icon(
          Icons.assessment,
          color: Colors.white,
        ),
        text: "Round " + i.toString(),
      );

      tabContainers[i] = Container(
        height: MediaQuery.of(context).size.height * 0.45,
        child: roundList[i].length == 0
            ? Column(
                children: <Widget>[
                  Container(
                    height: 270.0,
                    width: 270.0,
                    alignment: Alignment.topCenter,
                    child: FlareActor(
                      'assets/NoEvent.flr',
                      animation: 'noEvents',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    child: Text(
                      "No Results for this Round.",
                      style: TextStyle(color: Colors.white54, fontSize: 18.0),
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemCount: roundList[i].length,
                itemBuilder: (context, resultsIndex) {
                  return Container(
                    child: ListTile(
                        leading: Container(
                          width: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.ribbon,
                                size: 18,
                                color: getColorFromPosition(
                                    roundList[i][resultsIndex].position),
                              ),
                              Text(
                                roundList[i][resultsIndex].position.toString(),
                                style: TextStyle(fontSize: 22.0),
                              )
                            ],
                          ),
                        ),
                        title: Text(
                          "Team ID:",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white70),
                        ),
                        trailing: Text(
                          roundList[i][resultsIndex].teamId.toString(),
                          style: TextStyle(fontSize: 20.0),
                        )),
                  );
                },
              ),
      );
    }

    showModalBottomSheet(
        backgroundColor: Colors.black,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text(
                    eventsWithResults[index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TabBar(
                  controller: _controller,
                  tabs: tabList,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: TabBarView(
                      controller: _controller, children: tabContainers),
                )
              ],
            ),
          );
        });
  }

  getColorFromPosition(int pos) {
    if (pos == 1)
      return Colors.amberAccent;
    else if (pos == 2)
      return Color.fromRGBO(192, 192, 192, 1);
    else if (pos == 3)
      return Color.fromRGBO(205, 127, 50, 1);
    else
      return Colors.white;
  }
}
