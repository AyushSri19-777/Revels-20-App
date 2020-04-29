import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Registration.dart';
import 'package:url_launcher/url_launcher.dart';

class AutoComplete extends StatefulWidget {
  @override
  _AutoCompleteState createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  _AutoCompleteState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredSuggestions = suggestions;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  List<String> filteredSuggestions = [];
  List<String> suggestions = [];
  String selected;
  Map content;

  Future<Map> fetchColleges() async {
    var response = await http.get('https://api.mitrevels.in/colleges');
    return json.decode(response.body);
  }

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Color.fromARGB(255, 247, 176, 124),
  );
  Widget _appBarTitle = new Text('Search for your College');

  void filternames() {
    filteredSuggestions = [];
    print(_searchText);
    if (_searchText.length == 0) {
      filteredSuggestions = suggestions;
    } else {
      for (int i = 0; i < suggestions.length; i++) {
        if (suggestions[i].toLowerCase().startsWith(_searchText.toLowerCase()))
          filteredSuggestions.add(suggestions[i]);
      }
    }
  }

  @override
  Widget build(context1) {
    _appBarTitle = TextField(
      controller: _filter,
      style: TextStyle(color: Colors.white),
      decoration: new InputDecoration(
          prefixIcon:
              new Icon(Icons.search, color: Color.fromARGB(255, 247, 176, 124)),
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white70)),
      onChanged: (String value) {
        filternames();
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _buildBar(context1),
        body: FutureBuilder(
            future: fetchColleges(),
            builder: (BuildContext context1, AsyncSnapshot<Map> snapshot) {
              content = snapshot.data;
              if (content != null) {
                getcollegenames();
                filternames();
              }
              return Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child: ListView.builder(
                        itemCount: filteredSuggestions.length,
                        addRepaintBoundaries: true,
                        //primary: true,
                        itemBuilder: (context1, index) {
                          return Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, top: 5),
                              child: FlatButton(
                                padding: EdgeInsets.all(5),
                                color: Colors.grey[900],
                                child: Text(
                                  filteredSuggestions[index],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 2,
                                ),
                                onPressed: () {
                                  collname = filteredSuggestions[index];
                                  Navigator.pop(context);
                                },
                              ));
                        }),
                  ));
            }),
      ),
    );
  }

  void getcollegenames() {
    for (int i = 0; i < content['data'].length; i++) {
      if (content['data'][i]['MAHE'] == 1) {
        suggestions.add(content['data'][i]['name']);
      }
    }
    for (int i = 0; i < content['data'].length; i++) {
      if (content['data'][i]['MAHE'] == 0) {
        suggestions.add(content['data'][i]['name']);
      }
    }
    suggestions = suggestions.toSet().toList();
  }

  _launchURL() async {
    const url = 'tel:+918076740513';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 247, 176, 124),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        Container(
          child: IconButton(
            icon: Icon(Icons.info_outline),
            color: Color.fromARGB(255, 247, 176, 124),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: new Text(
                          "Please search for your college. \nIf you cannot find it, please contact Outstation Management."),
                      actions: <Widget>[
                        new FlatButton(
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.call,
                                  color: Color.fromARGB(255, 247, 176, 124),
                                  size: 18,
                                ),
                                margin: EdgeInsets.only(right: 5),
                              ),
                              Text(
                                "Call",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 247, 176, 124)),
                              )
                            ],
                          ),
                          onPressed: () {
                            _launchURL();
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text(
                            "Back",
                            style: TextStyle(
                                color: Color.fromARGB(255, 247, 176, 124)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        )
      ],
    );
  }
}
