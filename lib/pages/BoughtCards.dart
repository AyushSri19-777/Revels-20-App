import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revels20/main.dart';
import 'package:revels20/models/DelegateCardModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class BoughtDelegateCards extends StatefulWidget {
  @override
  _BoughtDelegateCardState createState() => _BoughtDelegateCardState();
}

class _BoughtDelegateCardState extends State<BoughtDelegateCards> {
  List<DelegateCardModel> boughtCards = [];

  @override
  Widget build(BuildContext context) {
    print(allCards.length);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Delegate Cards"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
          future: loadBoughtCards(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                child: Container(
                  height: 70.0,
                  width: 70.0,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              for (var i in boughtCards) {
                print(i.desc);
              }
              return boughtCards.length != 0
                  ? Container(
                      height: height,
                      width: width,
                      padding: EdgeInsets.all(12.0),
                      child: ListView.builder(
                          itemCount: boughtCards.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Colors.greenAccent, width: 0.5)
                                  //  color: Colors.greenAccent.withOpacity(0.1),
                                  ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        boughtCards[index].name,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        boughtCards[index].desc,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : Container(
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
                              "You have not purchased any delegate cards.",
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                    );
              ;
            }
          }),
    );
  }

  loadBoughtCards() async {
    boughtCards = await _fetchBoughtCards();
    print(boughtCards.length);
    return "success";
  }

  _fetchBoughtCards() async {
    List<int> cards = [];
    List<DelegateCardModel> tempCards = [];
    var jsonData;

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    print("eeeee");

    dio.interceptors.add(CookieManager(cookieJar));
    var resp = await dio.get("/boughtCards");

    if (resp.statusCode == 200) {
      jsonData = resp.data;
      for (var json in jsonData['data']) {
        try {
          var temp = json['card_type'];
          cards.add(temp);
        } catch (e) {
          print(e);
        }
      }
    }

    for (var i in allCards) {
      for (var j in cards) {
        if (i.id == j) {
          tempCards.add(i);
        }
      }
    }

    return tempCards.toSet().toList();
  }
}
