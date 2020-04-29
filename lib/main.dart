import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:revels20/models/CategoryModel.dart';
import 'package:revels20/models/DelegateCardModel.dart';
import 'package:revels20/models/EventModel.dart';
import 'package:revels20/models/MapModel.dart';
import 'package:revels20/models/ResultModel.dart';
import 'package:revels20/models/ScheduleModel.dart';
import 'package:revels20/models/UserModel.dart';
import 'package:revels20/pages/Categories.dart';
import 'package:revels20/pages/Favorites.dart';
import 'package:revels20/pages/Home.dart';
import 'package:revels20/pages/Login.dart';
import 'package:revels20/pages/Maps.dart';
import 'package:revels20/pages/Schedule.dart';
import 'package:revels20/pages/Results.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

int count = 0;

List<String> favoriteEvents = [];

TextStyle headingStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400);
SharedPreferences preferences;
List<ScheduleData> allSchedule = [];
List<CategoryData> allCategories = [];
List<EventData> allEvents = [];
List<ResultData> allResults = [];
List<DelegateCardModel> allCards = [];

_startUserCache() async {
  try {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    print(isLoggedIn);

    dio.options.baseUrl = "https://register.mitrevels.in";
    dio.options.connectTimeout = 500000000; //5s
    dio.options.receiveTimeout = 300000000;

    if (isLoggedIn) {
      try {
        var resp = await dio.get("/registeredEvents");

        if (resp.statusCode == 200) {
          print(resp.data);
        }
      } catch (e) {}
    }

    if (isLoggedIn) {
      try {
        user = UserData(
            id: int.parse(preferences.getString('userId')),
            name: preferences.getString('userName'),
            regNo: preferences.getString('userReg'),
            mobilNumber: preferences.getString('userMob'),
            emailId: preferences.getString('userEmail'),
            qrCode: preferences.getString('userQR'),
            collegeName: preferences.getString('userCollege'),
            cookie: preferences.getString('userCookie'));
      } catch (e) {
        print(e);
      }
    }
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revels',
      theme: ThemeData(
          canvasColor: Colors.black,
          brightness: Brightness.dark,
          fontFamily: 'Product-Sans',
          accentColor: Color.fromRGBO(247, 176, 124, 1)),
      home: MyHomePage(),
    );
  }
}

bool isLoggedIn;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _page = 0;

  String collname, initialLink;
  bool inpassword = false;
  bool passwordset = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double navWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startupCache();
    loadCategories();
    loadSchedule();
    loadEvents();
    loadResults();
    loadDelCards();
    firebaseCloudMessaging_Listeners();
  }

  _startupCache() async {
    _startUserCache();
    _cacheSchedule();
    _cacheCategories();
    _cacheEvents();
    _cacheResults();
    _cacheDelCards();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    firebaseMessaging.getToken().then((token) {
      print(token);
    });

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _cacheDelCards() async {
    try {
      final response = await http
          .get(Uri.encodeFull("https://api.mitrevels.in/delegate_cards"));

      if (response == null) return;

      if (response.statusCode == 200)
        preferences.setString('DelegateCards', json.encode(response.body));
    } catch (e) {
      print("problem with del cards");
      print(e);
    }
  }

  void _cacheSchedule() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/schedule"));
      if (response == null) return;
      if (response.statusCode == 200)
        preferences.setString('Schedule', json.encode(response.body));
    } catch (e) {
      print("schedulBT$e");
    }
  }

  void _cacheCategories() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/categories"));
      if (response == null) return;
      if (response.statusCode == 200)
        preferences.setString('Categories', json.encode(response.body));
    } catch (e) {
      print(e);
    }
  }

  void _cacheEvents() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/events"));
      if (response.statusCode == 200)
        preferences.setString('Events', json.encode(response.body));
      if (response == null) return;
    } catch (e) {
      print(e);
      print("error in fetching events");
    }
  }

  void _cacheResults() async {
    try {
      final response =
          await http.get(Uri.encodeFull("https://api.mitrevels.in/results"));
      if (response.statusCode == 200)
        preferences.setString('Results', json.encode(response.body));
      if (response == null) return;
    } catch (e) {
      print(e);
      print("Error in fetching results");
    }
  }

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print('Got link');
      initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print("hello:");
      count++;
      print(initialLink);

      if (count <= 1) setState(() {});

      print('hello link');
      print('state set!!');
      // setState(() {
      // });
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageController = new PageController();

    navWidth = MediaQuery.of(context).size.width;

    if (!passwordset) initUniLinks();
    print(initialLink);

    return initialLink == null
        ? SafeArea(
            key: _scaffoldKey,
            child: Scaffold(
              // floatingActionButton: Transform.scale(
              //   scale: 1,
              //   child: FloatingActionButton(
              //     onPressed: () {
              //       Navigator.of(context).push(
              //           MaterialPageRoute<Null>(builder: (BuildContext context) {
              //         return MyMap();
              //       }));
              //     },
              //     backgroundColor: Color.fromRGBO(247, 176, 124, 1),
              //     child: Icon(
              //       Icons.map,
              //       size: 32,
              //     ),
              //   ),
              // // ),
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerDocked,
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: onPageChanged,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Home(),
                  Schedule(),
                  MyMap(),
                  Results(),
                  LoginPage()
                ],
              ),
              // bottomNavigationBar: BottomAppBar(
              //   color: Colors.white.withOpacity(0.07),
              //   shape: CircularNotchedRectangle(),
              //   child: Container(
              //     height: 60,
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: <Widget>[
              //         buildTabIcon(0, "Home", Icons.home),
              //         buildTabIcon(1, "Schedule", Icons.schedule),
              //         buildTabIcon(2, "Maps", Icons.map),
              //         buildTabIcon(3, "Results", Icons.assessment),
              //         buildTabIcon(4, "User", Icons.person),
              //       ],
              //     ),
              //   ),
              // )
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _page,
                onTap: navigationTapped,
                selectedItemColor: _page != 2
                    ? Colors.blueAccent
                    : Color.fromRGBO(247, 176, 124, 1),
                items: [
                  _buildBottomNavBarItem("Home", Icon(Icons.home)),
                  _buildBottomNavBarItem("Schedule", Icon(Icons.schedule)),
                  _buildBottomNavBarItem("Maps", Icon(Icons.map)),
                  _buildBottomNavBarItem("Results", Icon(Icons.assessment)),
                  _buildBottomNavBarItem("User", Icon(Icons.person))
                ],
              ),
            ))
        : Password();
  }

  bool _autovalidate1 = false;

  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  @override
  bool _passwordVisible = true;
  bool _passwordVisible1 = true;
  String password, password2;

  String validatepassword(String value) {
    if (password.length == 0) {
      return "Password is Required";
    } else if (password.length < 8) {
      return "Minimum length is 8";
    } else if (password != password2) return "Passwords do not match";

    return null;
  }

  String validatepassword2(String value) {
    if (password2.length == 0) {
      return "Password is Required";
    } else if (password2.length < 8) {
      return "Minimum length is 8";
    } else if (password != password2) return "Passwords do not match";

    return null;
  }

  ScrollController sc = new ScrollController();

  Widget Password() {
    print('inside password scaffold');
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        controller: sc,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 200,
            child: Image.asset(
              'assets/Revels20_logo.png',
              alignment: Alignment.topCenter,
            ),
          ),
          Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 400,
              child: ListView(controller: sc, children: <Widget>[
                Form(
                  key: _key1,
                  autovalidate: _autovalidate1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[850],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                              validator: validatepassword,
                              obscureText: _passwordVisible,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: _passwordVisible
                                            ? Colors.white70
                                            : Color.fromARGB(
                                                255, 247, 176, 124)),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible ^= true;
                                      });
                                    },
                                  )),
                              onChanged: (String val) {
                                password = val;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                              validator: validatepassword2,
                              obscureText: _passwordVisible1,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  hintText: 'Retype Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible1
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: _passwordVisible1
                                          ? Colors.white70
                                          : Color.fromARGB(255, 247, 176, 124),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible1 ^= true;
                                      });
                                    },
                                  )),
                              onChanged: (String val) {
                                password2 = val;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Minimum length 8 characters',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        Container(
                          child: FlatButton(
                            splashColor: Color.fromARGB(255, 22, 159, 196),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Color.fromARGB(255, 22, 159, 196),
                                width: 2.5,
                              ),
                            ),
                            child: Text(
                              'Submit Password',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              _autovalidate1 = true;
                              setState(() {});
                              if (_key1.currentState.validate()) {
                                _key1.currentState.save();
                                initUniLinks();
                                var a = initialLink.split('=');
                                print(a[1]);
                                String token = a[1];
                                print(token);
                                var response = await dio.post(
                                    "https://register.mitrevels.in/setPassword/",
                                    data: {
                                      "token": token,
                                      "password": password,
                                      "password2": password2,
                                    });
                                print(response.data['success']);
                                if (response.data['success'] == true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[900],
                                        title: new Text("Success!",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: new Text(
                                            "Password set successfully",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text("OK",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 247, 176, 124))),
                                            onPressed: () {
                                              passwordset = true;
                                              initialLink = null;
                                              Navigator.of(context).pop();
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           LoginPage()),
                                              // );
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
                                        title: new Text(
                                          "Invalid input",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: new Text(response.data['msg'],
                                            style:
                                                TextStyle(color: Colors.white)),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text("Try Again",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 247, 176, 124))),
                                            onPressed: () {
                                              //initUniLinks();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]))
        ],
      ),
    );
  }

  Padding buildTabIcon(int page, String name, IconData icon) {
    bool isCurrPage = page == _page;
    EdgeInsets padding;

    if (page == 0) {
      padding = EdgeInsets.only(left: 12);
    } else if (page == 1) {
      padding = EdgeInsets.only(right: 24);
    } else if (page == 3) {
      padding = EdgeInsets.only(right: 12);
    } else
      padding = EdgeInsets.only(left: 24);

    return Padding(
      padding: padding,
      child: InkWell(
        splashColor: Colors.transparent,
        child: Container(
          width: navWidth * 0.18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  icon,
                  color: isCurrPage ? Colors.blueAccent : Colors.white30,
                  size: 24.0,
                ),
              ),
              isCurrPage
                  ? Text(
                      name,
                      style: TextStyle(
                          color:
                              isCurrPage ? Colors.blueAccent : Colors.white30),
                    )
                  : Container()
            ],
          ),
        ),
        onTap: () {
          setState(() {
            _page = page;
            navigationTapped(_page);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  getPage(_pageController) {
    return _pageController.position;
  }

  _fetchEvents() async {
    List<EventData> events = [];

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
      String data = preferences.getString('Events') ?? null;

      if (data != null && !isCon) {
        jsonData = jsonDecode(jsonDecode(data));
      } else {
        final response =
            await http.get(Uri.encodeFull("https://api.mitrevels.in/events"));

        if (response.statusCode == 200) jsonData = json.decode(response.body);
      }

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var categoryId = json['category'];
          var name = json['name'];
          var free = json['free'];
          var short_description = json['shortDesc'];
          var long_description = json['longDesc'];
          var minTeamSize = json['minTeamSize'];
          var maxTeamSize = json['maxTeamSize'];
          var delCardType = json['delCardType'];
          var visible = json['visible'];
          var canReg = json['can_register'];

          EventData temp = EventData(
            id: id,
            categoryId: categoryId,
            name: name,
            free: free,
            shortDescription: short_description,
            longDescription: long_description,
            minTeamSize: minTeamSize,
            maxTeamSize: maxTeamSize,
            delCardType: delCardType,
            visible: visible,
            canRegister: canReg,
          );

          events.add(temp);
        } catch (e) {
          print(e);
          print("Error in parsing and fetching events");
        }
      }
    } catch (e) {
      print(e);
    }
    return events;
  }

  Future<String> loadEvents() async {
    allEvents = await _fetchEvents();
    //print(allEvents.length);
    return "success";
  }

  Future<String> loadDelCards() async {
    allCards = await _fetchCards();
    print("got card");
    return "success";
  }

  _fetchCards() async {
    List<DelegateCardModel> cards = [];

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
      String data = preferences.getString('DelegateCards') ?? "";
      if (data == "" && isCon) {
        final response = await http
            .get(Uri.encodeFull("https://api.mitrevels.in/delegate_cards"));

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        }
      } else {
        print(data);
        print(jsonDecode(jsonDecode(data)));
        jsonData = jsonDecode(jsonDecode(data));
      }

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var name = json['name'];
          var desc = json['description'];
          var mahePrice = json['MAHE_price'];
          var nonPrice = json['non_price'];
          var forSale = json['forSale'];
          var payMode = json['payment_mode'];
          var type = json['type'];

          DelegateCardModel temp = DelegateCardModel(
              id: id,
              name: name,
              desc: desc,
              mahePrice: mahePrice,
              nonMahePrice: nonPrice,
              forSale: forSale,
              paymentMode: payMode,
              type: type);

          cards.add(temp);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    return cards;
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

  _fetchCategories() async {
    List<CategoryData> category = [];

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

    String data = preferences.getString('Categories') ?? "";

    try {
      print(preferences.getString('Categories') ?? "");

      if (data == "" && isCon) {
        final response = await http
            .get(Uri.encodeFull("https://api.mitrevels.in/categories"));

        if (response.statusCode == 200) jsonData = json.decode(response.body);
      } else {
        jsonData = jsonDecode(jsonDecode(data));
      }

      //  print("\n\n\n$jsonData['data']\n\n\n");

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var name = json['name'];
          var short_description = json['vol_desc'];
          var long_description = json['description'];
          var type = json['type'];
          var cc1Name = json['cc1Name'];
          var cc1Contact = json['cc1Contact'];
          var cc2Name = json['cc2Name'];
          var cc2Contact = json['cc2Contact'];

          // add more with changes to API

          CategoryData temp = CategoryData(
              id: id,
              name: name,
              shortDescription: short_description,
              longDescription: long_description,
              type: type,
              cc1Contact: cc1Contact,
              cc1Name: cc1Name,
              cc2Contact: cc2Contact,
              cc2Name: cc2Name);

          category.add(temp);
        } catch (e) {
          print("error categories");
        }
      }
    } catch (e) {
      print(e);
    }
    return category;
  }

  Future<String> loadCategories() async {
    List<CategoryData> temp = await _fetchCategories();
    allCategories.clear();
    try {
      for (var item in temp) {
        if (item.type == "CULTURAL") {
          allCategories.add(item);
        }
      }
      allCategories.sort((a, b) {
        return a.name.compareTo(b.name);
      });
    } catch (e) {
      print(e);
      return "success";
    }
    //print('${allCategories.length}');
    return "success";
  }

  _fetchSchedule() async {
    List<ScheduleData> schedule = [];

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
      String data = preferences.getString('Schedule') ?? "";
      if (data == "" && isCon) {
        final response =
            await http.get(Uri.encodeFull("https://api.mitrevels.in/schedule"));

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        }
      } else {
        print(data);
        print(jsonDecode(jsonDecode(data)));
        jsonData = jsonDecode(jsonDecode(data));
      }

      for (var json in jsonData['data']) {
        try {
          var id = json['id'];
          var eventId = json['eventId'];
          var round = json['round'] ?? 3;
          var name = json['eventName'];
          var categoryId = json['categoryId'];
          var location = json['location'];
          var startTime = DateTime.parse(json['start']);
          var endTime = DateTime.parse(json['end']);

          ScheduleData temp = ScheduleData(
            id: id,
            eventId: eventId,
            round: round,
            name: name,
            categoryId: categoryId,
            startTime: startTime,
            endTime: endTime,
            location: location,
          );

          schedule.add(temp);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    return schedule;
  }

  Future<String> loadSchedule() async {
    allSchedule = await _fetchSchedule();

    print("Here at least");

    Schedule rem = getInvisibleEvent();

    allSchedule.remove(rem);

    allSchedule.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });
    return "success";
  }

  getInvisibleEvent() {
    int id;
    for (var event in allEvents) {
      print(event.visible);
      if (event.visible == 0) {
        print(event.name);
        id = event.id;
      }
    }

    for (var sched in allSchedule) {
      if (sched.eventId == id) return sched;
    }
  }
  // _buildBottomNavBarItem(String title, Icon icon) {
  //   return BottomNavigationBarItem(
  //       backgroundColor: Colors.black,
  //       activeIcon: icon,
  //       title: Text(title),
  //       icon: icon);
  // }
}

_buildBottomNavBarItem(String title, Icon icon) {
  return BottomNavigationBarItem(
      backgroundColor: Colors.black,
      activeIcon: icon,
      title: Text(title),
      icon: icon);
}

List<ScheduleData> scheduleForDay(List<ScheduleData> allSchedule, String day) {
  List<ScheduleData> temp = [];

  switch (day) {
    case 'Wednesday':
      for (var i in allSchedule) {
        if (i.startTime.day == 4) temp.add(i);
      }
      break;

    case 'Thursday':
      for (var i in allSchedule) {
        if (i.startTime.day == 5) temp.add(i);
      }
      break;

    case 'Friday':
      for (var i in allSchedule) {
        if (i.startTime.day == 6) temp.add(i);
      }
      break;

    case 'Saturday':
      for (var i in allSchedule) {
        if (i.startTime.day == 7) temp.add(i);
      }
      break;

    default:
      print("ERROR IN DAY WISE PARSINGG");
      break;
  }

  return temp;
}

String getTime(ScheduleData schedule) {
  return '${schedule.startTime.hour.toString()}:${schedule.startTime.minute.toString() == '0' ? '00' : schedule.startTime.minute.toString()} - ${schedule.endTime.hour.toString()}:${schedule.endTime.minute.toString() == '0' ? '00' : schedule.endTime.minute.toString()}';
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }

  static buildSliverAppBar(String name, String image, BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
        background: Stack(
          children: <Widget>[
            Container(
              height: 250,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.transparent.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(1)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.75, 1.0],
                    tileMode: TileMode.clamp),
              ),
            )
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
      actions: <Widget>[
        (name == "Schedule")
            ? Container(
                padding: EdgeInsets.all(12.0),
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  color: Color.fromRGBO(247, 176, 124, 1),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favorites()),
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }
}
