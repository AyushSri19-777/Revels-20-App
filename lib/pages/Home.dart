import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart' as wv;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:revels20/HomeImages.dart';
import 'package:revels20/main.dart';
import 'package:revels20/models/UserModel.dart';
import 'package:revels20/pages/Categories.dart';
import 'package:revels20/pages/Conveners.dart';
import 'package:revels20/pages/DelegateCards.dart';
import 'package:revels20/pages/Flagshipevents.dart';
import 'package:revels20/pages/LiveBlog.dart';
import 'package:revels20/pages/Login.dart';
import 'package:revels20/pages/Events.dart';
import 'package:revels20/pages/NewsLetter.dart';
import 'package:revels20/pages/Proshow.dart';
import 'package:revels20/pages/Sponsors.dart';
import 'package:revels20/pages/drawer.dart';
import 'package:revels20/pages/faq.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Developers.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  String url = "";
  double progress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      key: _key,
      drawer: revelsDrawer(context),
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          Container(
            height: 250.0,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      height: 250.0,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Container(
                        child: Image.asset("assets/Revels20_logo.png"),
                      ),
                    ),
                    fadeInDuration: Duration(milliseconds: 100),
                    fadeOutDuration: Duration(milliseconds: 100),
                    imageUrl: images[Random.secure().nextInt(10)],
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: 24.0),
                    height: 250.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.3, 0.7, 1.0],
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(1.0),
                        ],
                      ),
                    ),
                    child: Container(
                      height: 50.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Revels'20",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 24.0),
                          ),
                          Text(
                            "Qainaat | A WORLD APART",
                            style: TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    )),
                // Container(
                //   width: 60,
                //   height: 50,
                //   color: Colors.red.withOpacity(0.1),
                //   child: IconButton(
                //       icon: Icon(
                //         Icons.menu,
                //         color: Colors.black,
                //       ),
                //       onPressed: () {
                //         _key.currentState.openDrawer();
                //       }),
                // )
                GestureDetector(
                  child: Container(
                    height: 250,
                    color: Colors.redAccent.withOpacity(0.0),
                  ),
                  onTap: () {
                    setState(() {});
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(55.0, 2.0, 55.0, 18.0),
            color: Colors.transparent,
            height: 0.5,
          ),
          _buildHeaderContainer(
              context,
              'Categories',
              'Curated just for you',
              FontAwesomeIcons.shapes,
              Color.fromRGBO(247, 176, 124, 1), // skin color
              Color.fromRGBO(247, 176, 124, 1).withOpacity(0.125)),
          _buildHeaderContainer(
              context,
              'Events',
              'Filtered by genre!',
              Icons.event,
              Colors.deepPurpleAccent,
              Colors.deepPurpleAccent.withOpacity(0.125)),
          _buildHeaderContainer(
              context,
              'Proshow',
              'Ground Zero',
              FontAwesomeIcons.solidGrinHearts,
              Colors.redAccent,
              Colors.redAccent.withOpacity(0.125)),
          _buildHeaderContainer(
              context,
              'Delegate Cards',
              'Your access to events!',
              FontAwesomeIcons.creditCard,
              Colors.greenAccent,
              Colors.greenAccent.withOpacity(0.125)),
          _buildHeaderContainer(
              context,
              'Featured Events',
              'Win exciting prizes!',
              Icons.monetization_on,
              Colors.deepOrangeAccent,
              Colors.deepOrangeAccent.withOpacity(0.125)),
          _buildMITPOSTHeader(context),
          // // _buildHeaderContainer(
          //     context,
          //     'Live Blog',
          //     'Powered by MIT Post',
          //     FontAwesomeIcons.userClock,
          //     Colors.yellowAccent,
          //     Colors.yellowAccent.withOpacity(0.125)),
          Container(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildIconButton(
                    FontAwesomeIcons.facebook,
                    "https://facebook.com/mitrevels",
                    Color.fromRGBO(59, 89, 152, 1),
                    Color.fromRGBO(59, 89, 152, 1).withOpacity(0.125)),
                buildIconButton(
                    FontAwesomeIcons.twitter,
                    "https://twitter.com/revelsmit",
                    Color.fromRGBO(29, 161, 242, 1),
                    Color.fromRGBO(29, 161, 242, 1).withOpacity(0.125)),
                buildIconButton(
                    FontAwesomeIcons.instagram,
                    "https://instagram.com/revelsmit",
                    Colors.pinkAccent,
                    Colors.pinkAccent.withOpacity(0.125)),
                buildIconButton(
                    FontAwesomeIcons.youtube,
                    "https://www.youtube.com/channel/UC9gwWd47a0q042qwEgutjWw",
                    Color.fromRGBO(196, 48, 43, 1),
                    Color.fromRGBO(196, 48, 43, 1).withOpacity(0.125)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
            color: Colors.blueAccent,
            height: 0.5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(24.0),
            child: Text(
              desc,
              style: TextStyle(color: Colors.white70, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            padding: EdgeInsets.fromLTRB(150, 20, 150, 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/Revels20_logo.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken),
                    alignment: Alignment.centerRight)),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Developed with  ",
                  style: TextStyle(color: Colors.white70),
                ),
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Color.fromRGBO(247, 176, 124, 1),
                  size: 12.0,
                ),
                Text(
                  "  by the App Dev Team",
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ),
          ),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }

  _buildPOSTHeader(colorShade, icon, color, title, context) {
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.44,
        decoration: BoxDecoration(
            color: colorShade, borderRadius: BorderRadius.circular(50.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        //    color: Colors.blueAccent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.1,
              child: CircleAvatar(
                backgroundColor: Colors.white12,
                child: Icon(
                  icon,
                  color: color,
                  size: 20.0,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 0),
              height: 80.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if (title == "Live Blog")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LiveBlog();
          }));
        else
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Newsletter();
          }));
      },
    );
  }

  Widget _buildMITPOSTHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildPOSTHeader(
              Colors.yellowAccent.withOpacity(0.123),
              FontAwesomeIcons.microphone,
              Colors.yellowAccent,
              "Live Blog",
              context),
          _buildPOSTHeader(
              Colors.cyanAccent.withOpacity(0.125),
              FontAwesomeIcons.newspaper,
              Colors.cyanAccent,
              "Newsletter",
              context),
        ],
      ),
    );
  }

  Widget buildIconButton(icon, link, color, colorBG) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(4.0),
        color: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
            size: 32.0,
          ),
          onPressed: () {
            _launchURL(link);
          },
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        "Home",
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }

  _buildHeaderContainer(context, title, desc, icon, color, colorShade) {
    return InkWell(
      onTap: () {
        if (title == "Categories")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Categories();
          }));
        else if (title == "Delegate Cards")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return DelegateCard();
          }));
        else if (title == "Live Blog")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LiveBlog();
          }));
        else if (title == "Proshow")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Proshow();
          }));
        else if (title == "Featured Events")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return FeaturedEvents();
          }));
        else if (title == "Events")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Sample2();
          }));

        for (var event in allEvents) {
          print(event.visible);
          print(event.name);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: colorShade, borderRadius: BorderRadius.circular(50.0)),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        //    color: Colors.blueAccent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60.0,
              width: 60.0,
              child: CircleAvatar(
                backgroundColor: Colors.white12,
                child: Icon(
                  icon,
                  color: color,
                  size: 28.0,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 0),
              width: 200.0,
              height: 80.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 6),
                    width: 190.0,
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  Container(height: 0.5, width: 400.0, color: Colors.white70),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 6.0, 0, 2.0),
                    alignment: Alignment.topLeft,
                    height: 30.0,
                    width: 190.0,
                    child: Text(
                      desc,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // _getUserObject(UserData user) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   user = UserData(
  //       id: int.parse(preferences.getString('userId')),
  //       name: preferences.getString('userName'),
  //       regNo: preferences.getString('userReg'),
  //       mobilNumber: preferences.getString('userMob'),
  //       emailId: preferences.getString('userEmail'),
  //       qrCode: preferences.getString('userQR'),
  //       collegeName: preferences.getString('userCollege'));

  //   return user;
  // }

  Widget revelsDrawer(BuildContext context) {
    // UserData user;
    // if (isLoggedIn) {
    //   user = _getUserObject(user);
    // }

    if (isLoggedIn == null) isLoggedIn = false;

    // if (isLogged && user == null){

    // }

    Widget name = Container(
        padding: EdgeInsets.all(0.0),
        child: Text(
          isLoggedIn ? "Revels'20" : "Not logged in?",
          style: TextStyle(fontSize: 24),
        ));
    Widget email = Container(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: Text(
          isLoggedIn
              ? "Qainaat | A WORLD APART"
              : "Please log in first in our user section.",
          style: TextStyle(color: Colors.white70),
        ));

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: name,
            accountEmail: email,
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(50),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/Revels20_logo.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.75), BlendMode.darken),
                    alignment: Alignment.centerRight)),
          ),
          _buildListTile(context, "Sponsors", FontAwesomeIcons.solidHandshake),
          _buildListTile(context, "FAQs", Icons.question_answer),
          Container(
            height: 0.5,
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.blueAccent,
          ),
          _buildListTile(context, "Developers", FontAwesomeIcons.code),
          _buildListTile(context, "Conveners", FontAwesomeIcons.tag),
          _buildListTile(context, "Report a bug", Icons.bug_report),
        ],
      ),
    );
  }

  ListTile _buildListTile(context, name, icon) {
    Color skinColor = Color.fromRGBO(247, 176, 124, 1);
    return ListTile(
      leading: Icon(icon, color: skinColor),
      title: Text(name),
      onTap: () {
        if (name == "Sponsors")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Sponsors();
          }));
        else if (name == "FAQs")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Faq();
          }));
        else if (name == "Developers")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return Developers();
          }));
        else if (name == "Conveners")
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return ConvenersPage();
          }));
        else {
          _launchURL("mailto:appdev.revels20@gmail.com?subject=BUGZZZ&body=");
        }
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Container _buildHeaderContainer(
  //     BuildContext context, String name, String image) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 14.0),
  //     child: Row(
  //       children: <Widget>[
  //         Container(
  //           margin: EdgeInsets.only(left: 18.0),
  //           height: 100.0,
  //           width: 100.0,
  //           color: Colors.red,
  //           child: Image.asset('/assets/Categories.png'),
  //           //child: Image.asset(image),
  //         ),
  //         Container(
  //           height: 100.0,
  //           width: 200.0,
  //           alignment: Alignment.bottomCenter,
  //           decoration: BoxDecoration(
  //             color: Colors.blue,
  //             borderRadius: BorderRadius.circular(18.0),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String desc =
      "The world as we know today is not what it used to be and is no more than a shadow cast in the dim blue lights from screens, barely a semblance to the lush green of the forests and icy blue of the mountain tops that it should have been. With every new day comes a report of yet another catastrophe and we find ourselves wondering, have we run out of time?\n\nHave we gone too far to turn back? And yet it is amidst disaster that another feeling arises, of hope, of a chance at rebuilding the world, a chance at making it a world apart.\n\nWith this hope in our hearts we present to you the theme for Revels '20, Qainaat : A world apart. Revels is a national level cultural and sports fest from Manipal Institute of Technology that aims to unite a crowd that is diverse in more ways than one. An arena for holistic learning and a chance to express thoughts and ideas through art, music , dance , drama , sports and numerous other events.";
}
