import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperModel {
  String name;
  String image;
  String platform;
  String ccOrOrganizer;
  String quote;
  String insta;
  String linkedin;

  DeveloperModel({
    this.name,
    this.image,
    this.platform,
    this.ccOrOrganizer,
    this.quote,
    this.insta,
    this.linkedin,
  });
}

class Developers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Product-Sans'),
      debugShowCheckedModeBanner: false,
      home: DevPage(),
    );
  }
}

class DevPage extends StatefulWidget {
  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  List<DeveloperModel> developers = [];
  addToDevList() {
    developers.add(DeveloperModel(
        name: 'Arihant',
        image:
            'https://i.ibb.co/c6T8BXN/Whats-App-Image-2020-02-21-at-11-44-08-PM.jpg',
        platform: 'Android',
        ccOrOrganizer: 'Category Head',
        quote: '"Let your dreams be bigger than your fears"',
        insta: 'https://www.instagram.com/ajarihantjain54/',
        linkedin: 'https://www.linkedin.com/in/arihantjain54/'));
    developers.add(DeveloperModel(
        name: 'Naman',
        image:
            'https://i.ibb.co/3smxM9H/3ca88642-d267-4d7a-b501-68cab846e839.jpg',
        platform: 'IOS',
        ccOrOrganizer: 'Category Head',
        quote: '"Manners Maketh Man"',
        insta: 'https://www.instagram.com/nxmxnjxxn/',
        linkedin: 'https://www.linkedin.com/in/naman-jain-3252aa147/'));
    developers.add(DeveloperModel(
        name: 'Akshit',
        image:
            'https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992349/akshit.jpg',
        platform: 'Android',
        ccOrOrganizer: 'Category Head',
        quote:
            '"If you\'re having run problems, I feel bad for you son.\nI got 99 problems but a glitch ain\'t one."',
        insta: 'https://www.instagram.com/akshit.saxenamide/',
        linkedin: 'https://www.linkedin.com/in/akshit-saxena-b6b613184/'));
    developers.add(DeveloperModel(
        name: 'Akhilesh',
        image:
            'https://i.ibb.co/W6yHcCC/Whats-App-Image-2020-02-21-at-5-57-57-PM.jpg',
        platform: 'IOS',
        ccOrOrganizer: 'Category Head',
        quote: '"Do or do not. There is no try"',
        insta: 'https://www.instagram.com/akhileshxxenoy/',
        linkedin: 'www.linkedin.com/in/akhilesh-shenoy-a2255a15a'));
    developers.add(DeveloperModel(
        name: 'Ayush',
        image:
            'https://i.ibb.co/F3wh15X/Whats-App-Image-2020-02-22-at-11-50-02-PM.jpg',
        platform: 'Android',
        ccOrOrganizer: 'Category Head',
        quote: '"In order to be irreplaceable,\n one must always be efficient"',
        insta: 'https://www.instagram.com/ayush.m.s.1_9/',
        linkedin: 'https://www.linkedin.com/in/ayush-srivastava19777'));
    developers.add(DeveloperModel(
        name: 'Rohit',
        image:
            'https://i.ibb.co/zhg3zqW/Whats-App-Image-2020-02-22-at-12-02-57-AM.jpg',
        platform: 'IOS',
        ccOrOrganizer: 'Organizer',
        quote: '"Sic Parvis Magna"',
        insta: 'https://www.instagram.com/rohitkuber/',
        linkedin: 'https://www.linkedin.com/in/rohit-kuber-b55280164/'));
    developers.add(DeveloperModel(
        name: 'Tushar',
        image:
            'https://i.ibb.co/wQMTFcy/Whats-App-Image-2020-02-21-at-5-31-37-PM.jpg',
        platform: 'IOS',
        ccOrOrganizer: 'Organizer',
        quote: 'I\'d agree with you but then we\'d both be wrong',
        insta: 'https://www.instagram.com/tushar_tapadia/',
        linkedin: 'www.linkedin.com/in/tushar-tapadia'));
    developers.add(DeveloperModel(
        name: 'Hardik',
        image:
            'https://i.ibb.co/PgfJXWL/Whats-App-Image-2020-02-21-at-6-17-49-PM.jpg',
        platform: 'Android',
        ccOrOrganizer: 'Organizer',
        quote: '"Talent work, Genius create"',
        insta: 'https://www.instagram.com/hardik.bharunt/',
        linkedin: 'https://www.linkedin.com/in/hardik-bharunt/'));
    developers.add(DeveloperModel(
        name: 'Chakshu',
        image: 'https://i.ibb.co/7j6BhXL/ch.jpg',
        platform: 'Android',
        ccOrOrganizer: 'Organizer',
        quote:
            '"Dont spend your life thinking\n about what-ifs enjoy the present"',
        insta: 'https://www.instagram.com/chakshusaraswat/',
        linkedin: 'https://www.linkedin.com/in/chakshu-saraswat-836160171/'));
    developers.add(DeveloperModel(
        name: 'Anant',
        image:
            'https://i.ibb.co/rxgN4qx/Whats-App-Image-2020-02-21-at-5-31-30-PM.jpg',
        platform: 'Android',
        ccOrOrganizer: 'Organizer',
        quote: '"There\'s only the one truth"',
        insta: 'https://www.instagram.com/infinite_verma/',
        linkedin: 'https://www.linkedin.com/in/anant-verma/'));
  }

  @override
  void initState() {
    addToDevList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimationLimiter(
        child: StretchyHeader.listViewBuilder(
          headerData: HeaderData(
              blurContent: false,
              headerHeight: 180,
              highlightHeaderAlignment: HighlightHeaderAlignment.bottom,
              header: Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Center(
                    child: Text('App Dev Team',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                        ))),
              )),
          itemCount: 5,
          itemBuilder: (BuildContext context, index) {
            return AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: 2,
                duration: Duration(milliseconds: 800),
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          giveDevRow(index),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  height: 2.0,
                                  width: MediaQuery.of(context).size.width / 3,
                                  color: Color.fromRGBO(32, 32, 96, 0.5)),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  height: 2.0,
                                  width: MediaQuery.of(context).size.width / 3,
                                  color: Color.fromRGBO(32, 32, 96, 0.5))
                            ],
                          )
                        ]),
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget giveDevRow(index) {
    int i = index;
    if (i != 0) i *= 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        developerCard(i),
        borderWidget(),
        developerCard(i + 1)
      ],
    );
  }

  Widget borderWidget() {
    return Container(
        height: 120.0, width: 2.0, color: Color.fromRGBO(32, 32, 96, 0.5));
  }

  Widget developerCard(index) {
    return GestureDetector(
      onTap: () {
        print('tapped: ' + index.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Dev2(developerDetails: developers[index])));
      },
      child: Container(
        height: 180.0,
        width: 150.0,
        padding: EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            gradient: index % 2 == 0
                ? LinearGradient(colors: [Colors.white12, Colors.white10])
                : LinearGradient(colors: [Colors.white12, Colors.white10]),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(18.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              )
            ]),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                width: 100,
                height: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    child: Image.network(
                      '${developers[index].image}',
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 2.0, top: 10.0),
                child: Center(
                  child: Text(developers[index].name,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      )),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      child: Center(
                        child: Text('${developers[index].ccOrOrganizer}',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[300],
                            )),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      child: Center(
                        child: Text('${developers[index].platform}',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[300],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dev2 extends StatelessWidget {
  final DeveloperModel developerDetails;
  int gindex = 0;
  Dev2({this.developerDetails});

  @override
  Widget build(BuildContext context) {
    final Color color1 = Color.fromRGBO(44, 183, 233, 0.8); //Color(0xff00b09b);
    final Color color2 = Color.fromRGBO(247, 176, 126, 0.8);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black87,
        body: Stack(children: <Widget>[
          Container(
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: RadialGradient(
                    colors: [Colors.transparent, Colors.transparent],
                    center: Alignment.topCenter,
                    radius: 1.3),
              )
              //begin: Alignment.topLeft,
              //end: Alignment.bottomRight)),
              ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(35.0)),
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "#APPkoDEVanakarde",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "${developerDetails.quote}\t",
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(color: Colors.white12, blurRadius: 2.0)
                            ]),
                        height: 250.0,
                        width: 200.0,
                        //margin: const EdgeInsets.only(
                        //left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          //borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0)),
                          child: Image.network(
                            developerDetails.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  color2,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  color1
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter),
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 270.0,
                        width: 220.0,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  developerDetails.name.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white),
                ),
                SizedBox(height: 1.50),
                Text(developerDetails.ccOrOrganizer.toUpperCase() + ", MIT",
                    style: TextStyle(
                      color: color2.withOpacity(0.5),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 30.0),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 16.0),
                        margin: const EdgeInsets.only(
                            top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: color2, width: 4.0),
                            gradient: RadialGradient(
                              colors: [color1, Colors.transparent],
                              center: Alignment.topCenter,
                              radius: 1.8,
                              //begin: Alignment.topLeft,
                            ), //end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.linkedinIn,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                var url = '${developerDetails.linkedin}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                            IconButton(
                              color: Colors.black87,
                              icon: Icon(FontAwesomeIcons.instagram,
                                  color: Colors.white),
                              onPressed: () async {
                                var url = '${developerDetails.insta}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FloatingActionButton(
                          shape: CircleBorder(
                              side: BorderSide(color: color2, width: 3.0)),
                          child: Container(
                            margin: EdgeInsets.all(3.0),
                            child: Image.asset(
                              'logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          backgroundColor: Color(0xffffffff),
                          onPressed: () {
                            gindex++;
                            if (gindex == 3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => EasterEggChakshu()));
                            }
                            if (gindex == 4) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => EasterEggAyush()));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}

class EasterEggAyush extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.asset(
              'hackerman2.png',
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class EasterEggChakshu extends StatefulWidget {
  @override
  _ChakshuState createState() => _ChakshuState();
}

class _ChakshuState extends State<EasterEggChakshu> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.network('https://i.imgur.com/Hdqasuu.mp4')
          ..initialize().then((_) {
            setState(() {
              _controller.play();
              _controller.setLooping(true);
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}
