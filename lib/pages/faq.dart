import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:stretchy_header/stretchy_header.dart';

class Faq extends StatefulWidget {
  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List<FaqModel> parseQas(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<FaqModel>((json) => FaqModel.fromJson(json)).toList();
  }

  Future<List<FaqModel>> fetchQAs(http.Client client) async {
    final response = await client.get('https://appdev.mitrevels.in/faqs');

    return parseQas(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FaqModel>>(
        future: fetchQAs(http.Client()),
        builder: (context, snapshot) {
          List<FaqModel> list = snapshot.data;
          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.black,
                body: StretchyHeader.listViewBuilder(
                    headerData: HeaderData(
                        blurContent: false,
                        headerHeight: 120,
                        highlightHeaderAlignment:
                            HighlightHeaderAlignment.bottom,
                        header: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Center(
                              child: Text('FAQ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ))),
                        )),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 300),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 10.0,
                                    left: 10.0,
                                    right: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromRGBO(247, 176, 124, 0.8)
                                                  .withOpacity(0.75),
                                              Color.fromRGBO(247, 176, 124, 0.8)
                                                  .withOpacity(1)
                                              // Colors.white
                                            ]),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                      ),
                                      child: Text(
                                          '${index + 1}' +
                                              ': ' +
                                              list[index].question,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 17,
                                          )),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                247, 176, 124, 0.8),
                                            width: 0.5),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0)),
                                      ),
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(list[index].answer,
                                          style: TextStyle(
                                            color:
                                                Colors.white,
                                            fontSize: 15.0,
                                          )),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    }));
          }
          return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text('FAQ'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
              ),
              body: Center(child: CircularProgressIndicator()));
        });
  }
}

class FaqModel {
  String question;
  String answer;

  FaqModel({this.question, this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
        question: json['question'] as String, answer: json['answer'] as String);
  }
}
