import 'package:flutter/material.dart';
import './fullpageshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchResultTile extends StatelessWidget {
  
  String _phone;
  String _sex;
  String _email;
  String _location;
  String _name;
  String _group; 
  String medreport;

  SearchResultTile(this._phone,this._sex,this._email,this._location,this._name,this._group);

  void open_large(context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullPreview(_phone,_sex,_email,_location,_name,_group)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 1.0,
      child: ListTile(
    leading: FaIcon(FontAwesomeIcons.tint) ,
    title: Text("$_name [$_sex]"),
    trailing: Text(_group),
    subtitle: Text(_location),
    onTap:() {
       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FullPreview(_phone,_sex,_email,_location,_name,_group)),
  );
    } ,),);
  }
}
