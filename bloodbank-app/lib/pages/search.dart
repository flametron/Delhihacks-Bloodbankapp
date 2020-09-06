import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './searchform.dart';
import './searchform.dart';
var location;
var curgroup;
var radius = 5.0;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _address="LOCATION";
  Geolocator geo = Geolocator();



  @override
  void initState() {
    geo
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
      .then((Position pos) {
        _changeAddr(pos);
      });
    super.initState();
  }

  _changeAddr(pos) async{
        var _lst = await geo.placemarkFromPosition(pos);
    setState(() {
          _address = _lst.first.locality;
          location=_lst.first.locality;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: <Widget>[
          SearchForm(),

        ],)
        )
    );
  }
}