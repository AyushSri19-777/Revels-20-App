import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:cookie_jar/cookie_jar.dart' as cm;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:path_provider/path_provider.dart';
import 'package:revels20/main.dart';
import 'package:revels20/pages/DelegateCards.dart';
import 'package:revels20/pages/Login.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Proshow extends StatefulWidget {
  @override
  _ProshowState createState() => _ProshowState();
}

class _ProshowState extends State<Proshow> {
  bool hasBought = false;
  Future<Map> futureArtists;
  Map artistInMap = {};
  List artistList = [];
  Map content;
  Map proshow;
  bool profetch = false;
  Future<Map> fetchProshowArtist() async {
    final responsecc = await http.get('https://api.mitrevels.in/categories');
    content = json.decode(responsecc.body);
    for (Map i in content["data"]) {
      if (i["id"] == 141) {
        print(i);
        proshow = i;
        break;
      }
    }
    setState(() {
      profetch = true;
    });
    final response =
        await http.get('https://appdev.mitrevels.in/proshow/android');
    content = json.decode(response.body);
    setState(() {
      booltag = true;
    });
    if (response.statusCode == 200) {
      return (content);
    } else {
      throw Exception('Failed to load ProshowArtist');
    }
  }

  bool booltag;
  @override
  void initState() {
    booltag = false;
    super.initState();
    futureArtists = fetchProshowArtist();
  }

  var currentPage = imagesArtist.length - 1.0;
  @override
  Widget build(BuildContext context) {
    _checkBoughtCards();
    PageController controller =
        PageController(initialPage: imagesArtist.length, keepPage: false);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
        print(currentPage);
      });
    });

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              //  Colors.grey.withOpacity(0.1),
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
              //  Colors.grey.withOpacity(0.1),
            ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp)),
        child: (booltag == true)
            ? Scaffold(
                resizeToAvoidBottomInset: true,
                resizeToAvoidBottomPadding: true,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: Text(
                    'Proshow',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  elevation: 10.0,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                Size size = MediaQuery.of(context).size;
                                String cc1Name = "Ribhav Modi";
                                String cc2Name = "Sajal Gupta";
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          var url =
                                              "tel:+918872516915"; //proshow["cc1Contact"]
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            color: Colors.cyan.withOpacity(0.7),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.cyan),
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child: Text('$cc1Name',
                                                    maxLines: 2),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var url = "tel:+919910747712";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            color:
                                                Colors.orange.withOpacity(0.7),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.orange),
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child: Text(
                                                  '$cc2Name',
                                                  maxLines: 2,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                                /*Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(247, 176, 124,1),//Color.fromRGBO(44,183,233,1)
                                            ),
                                            child: Text("$cc1Name",maxLines: 2),
                                          ),
                                      ),
                                        onTap: ()async {
                                          var url = proshow["cc1Contact"];
                                          print(url);
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromRGBO(44,183,233,1)
                                          ),
                                          child: Icon(Icons.call),
                                        ),
                                        onTap: ()async {
                                          var url = proshow["cc2Contact"];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),

                                  ],
                                ),*/
                              });
                        })
                  ],
                ),
                body: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          Stack(
                            children: <Widget>[
                              CardScrollWidget(
                                  currentPage, imagesArtist, futureArtists),
                              Positioned.fill(
                                child: PageView.builder(
                                  itemCount: 6,
                                  controller: controller,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          _newTaskModalBottomSheet(
                                              context, index, futureArtists);
                                        },
                                        child: Container(
                                            color: Colors.transparent));
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: ((content["sales"] == true)
                    ? ((4 > currentPage)
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: (hasBought)
                                ? Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: (currentPage > 3 &&
                                                currentPage < 4)
                                            ? (1 -
                                                    (currentPage -
                                                        currentPage.toInt())) *
                                                50.0
                                            : 50.0,
                                        child: Text(
                                          'Passes Already Purchased',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white30),
                                        )),
                                  )
                                : SliderButton(
                                    backgroundColor: Colors.black,
                                    //buttonColor: Color.fromRGBO(44, 183, 233, 1),
                                    buttonColor: Colors.green,
                                    radius: 10.0,
                                    buttonSize: 80.0,
                                    width: MediaQuery.of(context).size.width,
                                    height: (currentPage > 3 && currentPage < 4)
                                        ? (1 -
                                                (currentPage -
                                                    currentPage.toInt())) *
                                            50.0
                                        : 50.0,
                                    alignLabel: Alignment.centerRight,
                                    dismissible: false,
                                    action: () {
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : Navigator.of(context).push(
                                              MaterialPageRoute<Null>(builder:
                                                  (BuildContext context) {
                                              return BuyCard(
                                                  58); //proshow card ID
                                            })).then((value) {
                                              _checkBoughtCards();
                                              if (hasBought)
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: new Text(
                                                          "Congratulation!"),
                                                      content: Text(
                                                          "You have successfully purchased your proshow pass!"),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                          child:
                                                              new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              setState(() {});
                                            });
                                    },
                                    label: Text("Swipe to Buy Proshow Pass",
                                        style: TextStyle(
                                            color: Colors.red.withOpacity(1))),
                                    icon: Text('Buy Now\t➤',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))))
                        : SizedBox(
                            height: 50.0,
                          ))
                    : SizedBox(
                        height: 50.0,
                      )))
            : Scaffold(
                resizeToAvoidBottomInset: true,
                resizeToAvoidBottomPadding: true,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: Text(
                    'Proshow',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                Size size = MediaQuery.of(context).size;
                                String cc1Name = "Ribhav Modi";
                                String cc2Name = "Sajal Gupta";
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          var url =
                                              "tel:+918872516915"; //proshow["cc1Contact"]
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            color: Colors.cyan.withOpacity(0.7),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.cyan),
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child: Text('$cc1Name',
                                                    maxLines: 2),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var url = "tel:+919910747712";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            color:
                                                Colors.orange.withOpacity(0.7),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.orange),
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child: Text(
                                                  '$cc2Name',
                                                  maxLines: 2,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                                /*Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(247, 176, 124,1),//Color.fromRGBO(44,183,233,1)
                                            ),
                                            child: Text("$cc1Name",maxLines: 2),
                                          ),
                                      ),
                                        onTap: ()async {
                                          var url = proshow["cc1Contact"];
                                          print(url);
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromRGBO(44,183,233,1)
                                          ),
                                          child: Icon(Icons.call),
                                        ),
                                        onTap: ()async {
                                          var url = proshow["cc2Contact"];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),

                                  ],
                                ),*/
                              });
                        })
                  ],
                  elevation: 10.0,
                ),
                body: Container(
                  child: Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ));
  }

  void _newTaskModalBottomSheet(context, artistIndex, futureArtists) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 30.0,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return FutureBuilder(
              future: futureArtists,
              builder: (context, snapshot) {
                var artistI = fixIndex(artistIndex);
                content = snapshot.data;
                if (snapshot.hasData) {
                  return Scaffold(
                    backgroundColor: Colors.black,
                    body: StretchyHeader.listView(
                      headerData: HeaderData(
                        blurContent: false,
                        headerHeight: 250,
                        header: CachedNetworkImage(
                          imageUrl: content['data']["${artistI + 1}"]
                              ['artist_image_url'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontFamily: 'Cabin',
                                color: Color.fromRGBO(247, 176, 124, 1),
                                fontSize: 30.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0, right: 10.0),
                          child: Text(
                              content['data']["${artistI + 1}"]['description'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                          // )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 20.0),
                              height:
                                  MediaQuery.of(context).size.height * 0.35 -
                                      150.0,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    "${getDate(artistIndex + 1)}",
                                    style: headStyle(20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                  ),
                                  Text(
                                    content['data']["${6 - (artistIndex)}"]
                                        ['time'],
                                    style: headStyle(20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35 -
                                        170.0,
                                width: MediaQuery.of(context).size.width * 0.50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(44, 183, 233, 1),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      height:
                                          (MediaQuery.of(context).size.height *
                                                      0.35 -
                                                  150.0) /
                                              3,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(44, 183, 233, 1),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(44, 183, 233, 1),
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                      ),
                                      child: Center(
                                          child: Text('Venue',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white))),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                          content['data']["${artistI + 1}"]
                                              ['venue'],
                                          style: headStyle(17.0)),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        Container(
                            height: 2.0,
                            width: MediaQuery.of(context).size.width,
                            color: Color.fromRGBO(44, 183, 233, 0.5)),
                        Container(
                            // height: 600.0,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Rules and Regulations',
                                    style: TextStyle(
                                        fontFamily: 'Cabin',
                                        color: Color.fromRGBO(247, 176, 124, 1),
                                        fontSize: 30.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),
                                  child: Text(content['rules1'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17.0)),
                                )
                              ],
                            ))
                      ],
                    ),
                  );
                }
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              });
        });
  }

  _checkBoughtCards() async {
    List<int> boughtCardsID = await _fetchBoughtCards();
    for (var i in boughtCardsID) {
      if (i == 58) {
        hasBought = true;
      }
    }
  }

  _fetchBoughtCards() async {
    List<int> cards = [];

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

  TextStyle headStyle(double fs) {
    return TextStyle(
      color: Colors.white,
      fontSize: fs,
    );
  }

  String getDate(int i) {
    String date = "";
    if (i == 1 || i == 2) {
      date = "7th March";
    } else if (i == 3 || i == 4) {
      date = "6th March";
    } else if (i == 5) {
      date = "5th March";
    } else if (i == 6) {
      date = "4th March";
    }
    return date;
  }
}

var cardAspectRatio = 12.0 / 20.0;
var widgetAspectRatio = cardAspectRatio * 1.25;

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  Future<Map> futureArtists;

  List<String> images;

  CardScrollWidget(this.currentPage, this.images, this.futureArtists);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureArtists,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;

            return new AspectRatio(
              aspectRatio: widgetAspectRatio,
              child: LayoutBuilder(builder: (context, contraints) {
                var primaryCardLeft = 50.0;
                var horizontalInset = primaryCardLeft;

                List<Widget> cardList = new List();
                for (var i = 0; i < 6; i++) {
                  var delta = i - currentPage;
                  bool isOnRight = delta > 0;
                  var j = fixIndex(i);
                  var start = padding +
                      math.max(
                          primaryCardLeft -
                              horizontalInset * -delta * (isOnRight ? 20 : 1),
                          0.0);

                  var cardItem = Positioned.directional(
                    top: padding + verticalInset * math.max(-delta, 0.0),
                    bottom: padding + verticalInset * math.max(-delta, 0.0),
                    start: start,
                    textDirection: TextDirection.rtl,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(3.0, 6.0),
                                blurRadius: 10.0)
                          ]),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: AspectRatio(
                          aspectRatio: cardAspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)),
                                  child: CachedNetworkImage(
                                    imageUrl: content['data']["${j + 1}"]
                                        ['vertical_image_url'],
                                    fit: BoxFit.cover,
                                  )),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Colors.transparent,
                                        Colors.black,
                                      ],
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          tileMode: TileMode.clamp)),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Text("Day " + "${getDay(j)}",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.75),
                                                    fontSize: 32.0,
                                                    fontWeight: (getDay(j) < 3)
                                                        ? FontWeight.normal
                                                        : FontWeight.bold)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            child: Text(
                                                (getDay(j) < 3)
                                                    ? "Free"
                                                    : "Paid",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                    fontSize: 20.0,
                                                    fontWeight: (getDay(j) > 2)
                                                        ? FontWeight.bold
                                                        : FontWeight.normal)),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  cardList.add(cardItem);
                }
                return Stack(
                  children: cardList,
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

int getDay(int i) {
  int day = 1;
  if (i == 0)
    return day;
  else if (i == 1)
    return day + 1;
  else if (i <= 3)
    return day + 2;
  else
    return day + 3;
}

int fixIndex(int i) {
  int j;
  switch (i) {
    case 0:
      j = 5;
      break;
    case 1:
      j = 4;
      break;
    case 2:
      j = 3;
      break;
    case 3:
      j = 2;
      break;
    case 4:
      j = 1;
      break;
    case 5:
      j = 0;
      break;
  }
  return j;
}

Widget ruleItem(String rule, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0, left: 20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10.0, top: 10.0),
          height: 5.0,
          width: 5.0,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                width: 2.0,
                color: Colors.white,
              )),
        ),
        Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            rule,
            style: headStyle(18.0),
            softWrap: true,
          ),
        )
      ],
    ),
  );
}

List<String> imagesArtist = [
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
  'Prateek_Kuhad.jpg',
];

TextStyle headStyle(double fs) {
  return TextStyle(
    color: Colors.white,
    fontSize: fs,
  );
}

class SliderButton extends StatefulWidget {
  final double radius;
  final double height;
  final double width;
  final double buttonSize;
  final Color backgroundColor;
  final Color baseColor;
  final Color highlightedColor;
  final Color buttonColor;
  final Text label;
  final Alignment alignLabel;
  final BoxShadow boxShadow;
  final Widget icon;
  final Function action;
  final bool shimmer;
  final bool dismissible;
  final LinearGradient linearGradient;
  final Alignment alignButton;
  SliderButton({
    @required this.action,
    this.linearGradient = const LinearGradient(colors: [
      Colors.white,
      Colors.white,
    ]),
    this.radius = 0,
    this.boxShadow = const BoxShadow(
      color: Colors.black,
      blurRadius: 4,
    ),
    this.shimmer = true,
    this.height = 70,
    this.buttonSize = 60,
    this.width = 250,
    this.alignLabel = const Alignment(0.4, 0),
    this.backgroundColor = const Color(0xffe0e0e0),
    this.baseColor = Colors.teal,
    this.buttonColor = Colors.white,
    this.highlightedColor = Colors.black,
    this.label = const Text(
      "Slide to cancel !",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
    ),
    this.icon = const Icon(
      Icons.power_settings_new,
      color: Colors.red,
      size: 30.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    this.alignButton = Alignment.centerLeft,
    this.dismissible = true,
  });

  @override
  _SliderButtonState createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> {
  bool flag;

  @override
  void initState() {
    super.initState();
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    return flag == true
        ? _control()
        : widget.dismissible == true
            ? Container()
            : Container(
                child: _control(),
              );
  }

  Widget _control() => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          gradient: widget.linearGradient,
          color: widget.backgroundColor,
        ),
        alignment: Alignment.centerLeft,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 30.0),
              alignment: widget.alignLabel,
              child: widget.shimmer
                  ? Shimmer.fromColors(
                      baseColor: widget.baseColor,
                      highlightColor: widget.highlightedColor,
                      child: widget.label,
                    )
                  : widget.label,
            ),
            Dismissible(
              key: Key("cancel"),
              direction: DismissDirection.startToEnd,
              onDismissed: (dir) async {
                setState(() {
                  if (widget.dismissible) {
                    flag = false;
                  } else {
                    flag = !flag;
                  }
                });
                widget.action();
              },
              child: Container(
                width: widget.width - 60,
                height: widget.height,
                alignment: widget.alignButton,
                child: Container(
                  height: widget.height,
                  width: widget.buttonSize * 2,
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: widget.buttonColor,
                  ),
                  child: Center(child: widget.icon),
                ),
              ),
            ),
          ],
        ),
      );
}
