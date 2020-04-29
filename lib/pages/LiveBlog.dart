import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LiveBlog extends StatefulWidget {
  @override
  _LiveBlogState createState() => _LiveBlogState();
}

class _LiveBlogState extends State<LiveBlog> {
  List<LiveBlogModel> liveBlog = [];

  // _launchURL(url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("\n\n\nIAMONBLOG\n\n");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Live Blog"),
        backgroundColor: Colors.black,
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.web,
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ),
      body: FutureBuilder(
        future: loadBlog(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Container(
                height: 70.0,
                width: 70.0,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(2),
              child: ListView.builder(
                itemCount: liveBlog.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.white10),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              liveBlog[index].content,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            padding: EdgeInsets.only(bottom: 12.0),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 16.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Image.network(
                              liveBlog[index].imageUrl,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            color: Colors.blueAccent,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              liveBlog[index].author,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white70),
                            ),
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 6.0),
                              child: Text(
                                liveBlog[index].timeStamp,
                                style: TextStyle(color: Colors.white54),
                              ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  loadBlog() async {
    liveBlog = await _fetchLiveBlog();
    print(liveBlog.length);
    return "success";
  }

  _fetchLiveBlog() async {
    List<LiveBlogModel> blog = [];
    var jsonData;

    try {
      final resp =
          await http.get(Uri.encodeFull("http://revels.herokuapp.com/"));

      if (resp.statusCode == 200) {
        jsonData = json.decode(resp.body);

        for (var json in jsonData['data']) {
          try {
            var id = json['id'];
            var author = json['author'];
            var desc = json['content'];
            var image = json['imageURL'];
            var timestamp = json['timestamp'];

            LiveBlogModel temp = LiveBlogModel(
                id: id,
                author: author,
                content: desc,
                imageUrl: image,
                timeStamp: timestamp);
            print("****");
            print(temp.author);
            blog.add(temp);
          } catch (e) {
            print(e);
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return blog;
  }
}

class LiveBlogModel {
  final String author;
  final String content;
  final int id;
  final String imageUrl;
  final String timeStamp;

  LiveBlogModel(
      {this.author, this.content, this.id, this.imageUrl, this.timeStamp});
}
