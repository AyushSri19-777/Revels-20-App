import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:location/location.dart';
import 'package:revels20/models/MapModel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyMap extends StatefulWidget {
  MyMap({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController _controller;
  Position position;
  Widget _child;

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  //Defining the Set of Markers and Icons

  Set<Marker> _popularMarkers;
  Set<Marker> _sportsMarkers;
  Set<Marker> _foodMarkers;
  Set<Marker> _proshowMarkers;
  Set<Marker> _allMarkers;

  List<MapData> popularLocations = [];
  List<MapData> foodLocations = [];
  List<MapData> sportsLocations = [];
  List<MapData> proshowLocations = [];
  List<MapData> viewLocations = [];

  BitmapDescriptor popularIcon;
  BitmapDescriptor sportsIcon;
  BitmapDescriptor proshowIcon;
  BitmapDescriptor foodIcon;

  var currentTag = "All";

  List<MapData> allLocations = [];

  Future<String> loadLocations() async {
    print("Inside Load Locations");
    allLocations = await _fetchLocations();
    print(allLocations.length);
    _tagsForLocations();
    _getMarkers();
    return "success";
  }

  SharedPreferences preferences;
  var heading = "Click on a Category";

  _fetchLocations() async {
    List<MapData> locations = [];
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
        print("Here Res");
        jsonData = jsonDecode(jsonDecode(data));
      } else {
        final response = await http
            .get(Uri.encodeFull("http://aws.namanjain.me:3000/maps/all"));
        if (response.statusCode == 200) jsonData = json.decode(response.body);
      }

      for (var json in jsonData['data']) {
        try {
          var locId = json['_id'];
          var locName = json['locationName'];
          var locTag = json['locationTag'];
          var locLat = json['locCordLat'];
          var locLong = json['locCordLong'];
          var tagImage = json['tagImageUrl'];

          MapData temp = MapData(
              locId: locId,
              locName: locName,
              locTag: locTag,
              locLat: locLat,
              locLong: locLong,
              tagImage: tagImage);
          locations.add(temp);
        } catch (e) {
          print(e);
          print("Error in parsing Locations");
        }
      }
    } catch (e) {
      print(e);
    }
    return locations;
  }

  _tagsForLocations() {
    print("inside tags for Locations \n");
    for (var location in allLocations) {
      print(location.locTag);
      if (location.locTag == "Food")
        foodLocations.add(location);
      else if (location.locTag == "Sports")
        sportsLocations.add(location);
      else if (location.locTag == "Proshow")
        proshowLocations.add(location);
      else
        popularLocations.add(location);
    }
    viewLocations = [];
    print(foodLocations.length);
    print(sportsLocations.length);
  }

  @override
  void initState() {
    _child = Center(child: CircularProgressIndicator());
    getCurrentLocation();
    _fabHeight = _initFabHeight;
    super.initState();
    setIcons();
    loadLocations();
  }

  void setIcons() async {
    print("InsideSetIcons \n");
    popularIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/PopularMar.png");

    sportsIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/SportsMarker.png");

    proshowIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/ProshowMarker.png");

    foodIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/FoodMarker.png");
  }

  _getIcon(String url) async {
    final http.Response response = await http.get(url);
    var icon = BitmapDescriptor.fromBytes(response.bodyBytes);
    setState(() {
      popularIcon = icon;
    });
    print("inside get icon");
  }

  void getCurrentLocation() async {
    //waits till the current location is obtained and then opens the map on that location and rebuilds the widget tree

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen = 575.0;
  double _panelHeightClosed = 125.0;
  PanelController panelController = new PanelController();

  _getMarkers() {
    List<Marker> foodMarkerList = [];
    List<Marker> proshowMarkerList = [];
    List<Marker> popularMarkerList = [];
    List<Marker> sportsMarkerList = [];
    List<Marker> allMarkerList = [];

    for (var place in popularLocations) {
      //  _getIcon(place.tagImage);

      Marker temp = Marker(
        markerId: MarkerId(place.locId),
        position: LatLng(place.locLat, place.locLong),
        icon: popularIcon,
        infoWindow: InfoWindow(title: place.locName),
      );
      popularMarkerList.add(temp);
      allMarkerList.add(temp);
    }

    for (var place in foodLocations) {
      Marker temp = Marker(
        markerId: MarkerId(place.locId),
        position: LatLng(place.locLat, place.locLong),
        icon: foodIcon,
        infoWindow: InfoWindow(title: place.locName),
      );
      foodMarkerList.add(temp);
      allMarkerList.add(temp);
    }

    for (var place in proshowLocations) {
      Marker temp = Marker(
        markerId: MarkerId(place.locId),
        position: LatLng(place.locLat, place.locLong),
        icon: proshowIcon,
        infoWindow: InfoWindow(title: place.locName),
      );
      proshowMarkerList.add(temp);
      allMarkerList.add(temp);
    }

    for (var place in sportsLocations) {
      Marker temp = Marker(
        markerId: MarkerId(place.locId),
        position: LatLng(place.locLat, place.locLong),
        icon: sportsIcon,
        infoWindow: InfoWindow(title: place.locName),
      );
      sportsMarkerList.add(temp);
      allMarkerList.add(temp);
    }
    _popularMarkers = popularMarkerList.toSet();
    _sportsMarkers = sportsMarkerList.toSet();
    _proshowMarkers = proshowMarkerList.toSet();
    _foodMarkers = foodMarkerList.toSet();
    _allMarkers = allMarkerList.toSet();
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            backdropTapClosesPanel: true,
            // maxHeight: _panelHeightOpen,
            // minHeight: _panelHeightClosed,
            controller: panelController,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                  "Welcome to Revels!",
                  style: TextStyle(fontSize: 22),
                ),
                centerTitle: true,
                //backgroundColor: Colors.blueAccent,
              ),
              body: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: _child),
                ],
              ),
            ),

            panel: Panel(context),
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
            margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),
        ],
      ),
    );
  }

  int counter = 0;

  Set<Marker> _createMarker(var currentTag) {
    // the LIST of positions have to be used as a SET since
    // that's the data type GoogleMap widget expects, we change it later to
    // a list for ease of use.
    if (currentTag == "Popular")
      return _popularMarkers;
    else if (currentTag == "Sports") {
      print("I am alive");
      return _sportsMarkers;
    } else if (currentTag == "Proshow")
      return _proshowMarkers;
    else if (currentTag == "Food")
      return _foodMarkers;
    else {
      print("Geetalakshi");
      return _allMarkers;
    }
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.satellite,
      markers: _createMarker(currentTag),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
          zoom: 15.0, target: LatLng(position.latitude, position.longitude)),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  InkWell buildListTile(String str) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Center(
          child: Text(
            str,
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
      onTap: () {
        _goToLocation(str);
        panelController.close();
      },
    );
  }

  Future<void> _goToLocation(String str) async {
    List<Marker> _markerList = _allMarkers.toList();

    LatLng pos;

    MarkerId mak;
    // this is the onTap function for the list of locations. tapping will
    // search throught the list of locations and select the one whose name is
    // same as that of the tile we have tapped on (I'm passing the name of the tile as an argument)

    for (var i in _markerList) {
      if (i.infoWindow.title == str) {
        pos = i.position;
        mak = i.markerId;
      }
    }

    //simply animates the camera to the position we have selected
    setState(() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: pos, zoom: 19)));
      _controller.showMarkerInfoWindow(mak);
      if (counter == 0) {
        print("i am alive");
        Flushbar(
          titleText: Text(
            "Tap on the marker ",
            style: TextStyle(
                color: Color.fromRGBO(247, 176, 124, 1),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          messageText: RichText(
            text: TextSpan(
                text: 'The Direction button and Location name will be shown ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: '\n\n Swipe to Dismiss',
                      style:
                          TextStyle(color: Color.fromRGBO(247, 176, 124, 1))),
                ]),
          ),
          isDismissible: true,
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(_scaffoldKey.currentContext);
        counter = 1;
      }
    });
  }

  Widget widget2(context) {
    return Container(
      padding: EdgeInsets.only(bottom: 35),
      decoration: BoxDecoration(),
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        itemCount: viewLocations.length,
        itemBuilder: (context, index) {
          return buildListTile(viewLocations[index].locName);
        },
      ),
    );
  }

  Widget Panel(context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Explore Manipal",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                    color: Colors.blueAccent),
              ),
            ],
          ),
          SizedBox(
            height: 36.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _button("Popular", Icons.favorite, Colors.blue),
              _button("Food", Icons.restaurant, Colors.red),
              _button("Sports", Icons.directions_bike, Colors.amber),
              _button("Proshow", Icons.play_arrow, Colors.green),
            ],
          ),
          SizedBox(
            height: 36.0,
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  heading,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(247, 176, 124, 1)),
                ),
              )),
          widget2(context),
        ],
      ),
    );
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Material(
          //elevation: 10,

          borderRadius: BorderRadius.circular(40),
          color: color,
          child: InkWell(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.all(20),
              child: Icon(icon),
            ),
            onTap: () {
              print("Hello");
              print(label);
              LatLng pos;
              setState(() {
                currentTag = label;
                if (label == "Food") {
                  pos =
                      LatLng(foodLocations[1].locLat, foodLocations[1].locLong);
                  viewLocations = foodLocations;
                } else if (label == "Proshow") {
                  pos = LatLng(
                      proshowLocations[1].locLat, proshowLocations[1].locLong);
                  viewLocations = proshowLocations;
                } else if (label == "Sports") {
                  pos = LatLng(
                      sportsLocations[1].locLat, sportsLocations[1].locLong);
                  viewLocations = sportsLocations;
                } else if (label == "Popular") {
                  pos = LatLng(
                      popularLocations[1].locLat, popularLocations[1].locLong);
                  viewLocations = popularLocations;
                }
                heading = label;
                _child = mapWidget();
                _controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: pos, zoom: 14)));
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 15, color: Colors.white),
        )
      ],
    );
  }
}
