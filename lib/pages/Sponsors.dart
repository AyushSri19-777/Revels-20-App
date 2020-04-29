import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SponsorModel {
  final String name;
  final String link;
  final String image;
  final String desc;

  SponsorModel({this.name, this.link, this.image, this.desc});
}

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  List<SponsorModel> sponsors = [];

  @override
  void initState() {
    //getSponsors();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Our Sponsors"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: _getSponsors(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: sponsors.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _launchURL(sponsors[index].link);
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  padding: EdgeInsets.all(24.0),
                                  color: Colors.white,
                                  height: 100.0,
                                  width: 300.0,
                                  child: CachedNetworkImage(
                                      imageUrl: sponsors[index].image,
                                      fit: BoxFit.fitHeight),
                                  // child: Image.asset(
                                  //   sponsors[index].image,
                                  //   fit: BoxFit.fitHeight,
                                  // ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                sponsors[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 32.0),
                              ),
                              //   color: Colors.blue,
                              padding: EdgeInsets.all(4.0),
                            ),
                            Container(
                              padding: EdgeInsets.all(7.0),
                              alignment: Alignment.center,
                              child: Text(
                                sponsors[index].desc,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(3.0),
                              alignment: Alignment.center,
                              child: Text(
                                "tap for more",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(12.0),
                              color: Colors.blueAccent,
                              height: 0.5,
                              width: 250.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }

  _getSponsors() async {
    sponsors = await _fetchSponsors();
    print(sponsors.length);
    return "success";
  }

  _fetchSponsors() async {
    List<SponsorModel> tempSponsors = [];

    var jsonData;

    final resp =
        await http.get(Uri.encodeFull("https://appdev.mitrevels.in/sponsors"));

    if (resp.statusCode == 200) jsonData = json.decode(resp.body);

    for (var json in jsonData) {
      var name = json['name'];
      var image = json['imageUrl'];
      var desc = json['description'];
      var url = json['webUrl'];

      SponsorModel temp =
          SponsorModel(name: name, image: image, desc: desc, link: url);

      tempSponsors.add(temp);
    }

    return tempSponsors;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
