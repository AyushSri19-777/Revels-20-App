import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvenersPage extends StatefulWidget {
  @override
  _ConvenersPageState createState() => _ConvenersPageState();
}

class _ConvenersPageState extends State<ConvenersPage> {
  List<ConveyerModel> conveyers = [];
  addToConveyerList() {
    conveyers.add(ConveyerModel(
      name: 'Prakriti Parihar',
      image: 'https://i.imgur.com/K5PHw1t.jpg',
      designation: 'Cultural Convener',
      phoneNumber: '9782089675',
    ));
    conveyers.add(ConveyerModel(
        name: 'Mrigank Gautam',
        image: 'https://i.imgur.com/DCKH1DG.jpg',
        designation: 'Cultural Convener',
        phoneNumber: '9123114768'));
    conveyers.add(ConveyerModel(
      name: 'Rishikumar \n Mathiazhagan',
      image: 'https://i.imgur.com/0ebjq7d.jpg',
      designation: 'Sports Convener',
      phoneNumber: '8971915799',
    ));
    conveyers.add(ConveyerModel(
      name: 'Ankita Singh',
      image: 'https://i.ibb.co/XJKSnVw/ankita-min.png',
      designation: 'Sports Convener',
      phoneNumber: '9980297234',
    ));
  }

  @override
  void initState() {
    addToConveyerList();
    super.initState();
  }

  _launchURL(String num) async {
    String url = 'tel:$num';
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Product-Sans'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Conveners',
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Container(
            padding: EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 800),
                  child: ScaleAnimation(
                    child: FadeInAnimation(child: developerCard(index)),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget developerCard(index) {
    return Container(
      margin: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          gradient: index % 2 == 0
              ? LinearGradient(colors: [Colors.white12, Colors.white10])
              : LinearGradient(colors: [Colors.white12, Colors.white10]),
          shape: BoxShape.rectangle,
          border: Border.all(color: Color.fromARGB(200, 44, 183, 233)),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            )
          ]),
      child: Container(
        height: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10.0, bottom: 10),
              width: 110,
              height: 150,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: CachedNetworkImage(
                    imageUrl: '${conveyers[index].image}',
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: Color.fromARGB(200, 44, 183, 233),
                    ),
                    padding: const EdgeInsets.only(
                        left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(conveyers[index].designation,
                          style: TextStyle(
                            fontSize: 19.0,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(conveyers[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(220, 44, 183, 233),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0))),
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Call',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          onPressed: () {
                            _launchURL(conveyers[index].phoneNumber);
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConveyerModel {
  String name;
  String image;
  String designation;
  String phoneNumber;

  ConveyerModel({
    this.name,
    this.image,
    this.designation,
    this.phoneNumber,
  });
}
