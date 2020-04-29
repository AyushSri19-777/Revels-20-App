import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Newsletter extends StatefulWidget {
  @override
  _NewsletterState createState() => _NewsletterState();
}

List<String> liveLetter = [];

class _NewsletterState extends State<Newsletter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Newsletter"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
          future: loadLetter(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Container(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return PhotoViewGallery.builder(
                itemCount: liveLetter.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      liveLetter[index],
                    ),
                    // Contained = the smallest possible size to fit one dimension of the screen
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    // Covered = the smallest possible size to fit the whole screen
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                scrollDirection: Axis.vertical,
                loadingBuilder: (context, event) => Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  loadLetter() async {
    liveLetter = await _fetchLetter();
    print(liveLetter.length);
    return "success";
  }

  _fetchLetter() async {
    List<String> str = [];
    var jsonData;

    try {
      final resp = await http
          .get(Uri.encodeFull("http://newsletter-revels.herokuapp.com/"));
      if (resp.statusCode == 200) {
        jsonData = json.decode(resp.body);
        for (var json in jsonData['data']) {
          var img = json;
          str.add(img);
        }
      }
    } catch (e) {
      print(e);
    }
    return str;
  }
}
