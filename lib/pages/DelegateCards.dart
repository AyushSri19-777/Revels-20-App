import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as cm;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revels20/main.dart';
import 'package:revels20/models/DelegateCardModel.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:revels20/pages/Home.dart';

import 'Login.dart';

class DelegateCard extends StatefulWidget {
  @override
  _DelegateCardState createState() => _DelegateCardState();
}

class _DelegateCardState extends State<DelegateCard> {
  List<int> boughtCardsID = [];

  @override
  Widget build(BuildContext context) {
    print("all them cards ${allCards.length}");

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Delegate Cards"),
        centerTitle: true,
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
            } else
              return ListView(
                children: <Widget>[
                  buildCardRow(context, "General"),
                  buildCardRow(context, "Featured"),
                  buildCardRow(context, "Gaming"),
                  buildCardRow(context, "Workshop"),
                  buildCardRow(context, "Sports"),
                  buildCardRow(context, "Others")
                ],
              );
          }),
    );
  }

  loadBoughtCards() async {
    boughtCardsID = await _fetchBoughtCards();
    print(boughtCardsID.length);
    return "success";
  }

  _fetchBoughtCards() async {
    List<int> cards = [];

    var jsonData;

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
        dir: tempPath, ignoreExpires: true, persistSession: true);

    print("eeeee");

    dio.interceptors.add(cm.CookieManager(cookieJar));
    var resp = await dio.get("/boughtCards");

    if (resp.statusCode == 200) {
      jsonData = resp.data;

      try {
        for (var json in jsonData['data']) {
          try {
            var temp = json['card_type'];
            cards.add(temp);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        return cards.toSet().toList();
      }
    }

    return cards.toSet().toList();
  }

  Widget buildCardRow(BuildContext context, String type) {
    List<DelegateCardModel> filteredCards = [];

    for (var i in allCards) {
      if (i.type == type.toUpperCase() &&
          !((i.paymentMode < 2) || i.forSale == 0)) {
        filteredCards.add(i);
      }
    }

    return filteredCards.length == 0
        ? Container()
        : Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(38, 6, 12, 6),
                alignment: Alignment.centerLeft,
                child: Text(
                  type,
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Container(
                // color: Colors.red.withOpacity(0.2),
                height: 300,
                //width: MediaQuery.of(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isBought = false;

                    print(filteredCards[index].name);
                    print(filteredCards[index].mahePrice);

                    for (int i in boughtCardsID) {
                      print(i);
                      print("THIS IS I");
                      if (filteredCards[index].id == i) {
                        isBought = true;
                        break;
                      }
                    }

                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white10,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: ListView(
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                filteredCards[index].name,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                filteredCards[index].desc,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Mahe Price: ${filteredCards[index].mahePrice}",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  filteredCards[index].nonMahePrice != 0
                                      ? Text(
                                          "Non-Mahe Price: ${filteredCards[index].nonMahePrice}",
                                          style: TextStyle(fontSize: 16.0),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            isBought
                                ? Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.check_circle_outline,
                                            color:
                                                Colors.green.withOpacity(0.5),
                                          ),
                                          Container(
                                            width: 8.0,
                                            height: 10,
                                          ),
                                          Text(
                                            "Already Purchased",
                                            style: TextStyle(
                                              color:
                                                  Colors.green.withOpacity(0.5),
                                            ),
                                          )
                                        ]),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            stops: [0.1, 0.3, 0.7, 0.9],
                                            colors: [
                                              Colors.blueAccent
                                                  .withOpacity(0.9),
                                              Colors.blueAccent
                                                  .withOpacity(0.7),
                                              Colors.blue.shade800
                                                  .withOpacity(0.8),
                                              Colors.blue.shade800
                                                  .withOpacity(0.6),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.055,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (!isLoggedIn) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text("Oops!"),
                                                  content: Text(
                                                      "You must be logged in to buy delegate cards."),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            // showDialog(
                                            //     context: context,
                                            //     child: Container(
                                            //         child: Text(
                                            //             "You need to be logged in to buy cards!")));
                                          } else
                                            Navigator.of(context).push(
                                                MaterialPageRoute<Null>(builder:
                                                    (BuildContext context) {
                                              return BuyCard(
                                                  filteredCards[index].id);
                                            })).then((value) {
                                              setState(() {});
                                            });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Buy Now",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 0.5,
                width: 300,
                margin: EdgeInsets.fromLTRB(0, 8, 0, 12.0),
              )
            ],
          );
  }
}

class BuyCard extends StatefulWidget {
  int id;
  BuyCard(int id) {
    this.id = id;
  }

  final MyInAppBrowser browser = new MyInAppBrowser();

  @override
  _BuyCardState createState() => _BuyCardState();
}

class _BuyCardState extends State<BuyCard> {
  @override
  Widget build(BuildContext context) {
    InAppWebViewController inappWebView;

    CookieManager cManager = CookieManager.instance();

    print("pergiuerghiuer ${user.cookie} wefef");

    try {
      cManager.setCookie(
        url: 'https://register.mitrevels.in/buy?card=${widget.id}',
        name: 'connect.sid',
        value: user.cookie,
        isSecure: true,
        domain: 'register.mitrevels.in',
      );
    } catch (e) {
      print(e);
    }

    InAppWebView webView = InAppWebView(
      initialUrl: "https://register.mitrevels.in/buy?card=${widget.id}",
      initialOptions: InAppWebViewWidgetOptions(
          crossPlatform: InAppWebViewOptions(
        debuggingEnabled: true,
      )),
      onWebViewCreated: (InAppWebViewController controller) {
        inappWebView = controller;
      },
      onLoadStop: (controller, url) => print("yo what is up"),
      onConsoleMessage: (controller, consoleMessage) {
        //print(consoleMessage.message)
        print("******${consoleMessage.message}********");
      },
      onJsAlert: (controller, message) {
        print(message);
        print("HEEEEEEEE");
      },
      onJsConfirm: (controller, message) {
        print(message);
        print("HOOOOOOOOOOO");
      },
      onJsPrompt: (controller, message, defaultValue) {
        print(message);
        print("HIIIIIIIIIii");
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: webView,
    );

    // return Container(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: webView,
    // );
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(int progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  // @override
  // void shouldOverrideUrlLoadingRequest(String url) {
  //   print("\n\n override $url\n\n");
  //   this.webViewController.loadUrl(url: url);
  // }

  @override
  void onLoadResource(LoadedResource response) {
    print("Started at: " +
        response.startTime.toString() +
        "ms ---> duration: " +
        response.duration.toString() +
        "ms " +
        response.url);
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }
}
