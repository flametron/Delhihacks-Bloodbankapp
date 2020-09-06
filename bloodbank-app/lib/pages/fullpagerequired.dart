import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './search.dart';
class FullRequiredPreview extends StatefulWidget {

  String _phone;
  String _sex;
  String _email;
  String _age;
  String _location;
  String _name;
  String _group; 
  String _created;

  FullRequiredPreview(this._phone,this._sex,this._age,this._location,this._name,this._group,this._created);

  @override
  _FullRequiredPreviewState createState() => _FullRequiredPreviewState(_phone,_sex,_age,_location,_name,_group,_created);
}

class _FullRequiredPreviewState extends State<FullRequiredPreview> {
    
  final _formKey = GlobalKey<FormState>();
  String _phone;
  String _sex;
  String _age;
  String _location;
  String _name;
  String _group; 
  String _created;
  String medreport;
  bool _buttonenabled;

  _FullRequiredPreviewState(this._phone,this._sex,this._age,this._location,this._name,this._group, this._created);

  String _gend(String g){
    if(g=="M")
      return "Male";
    else if(g=="F")
      return "Female";
    else
      return "Other";
  }

@override
  void initState() {
    _buttonenabled=true;
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(body: Column(children: <Widget>[
      ListView(shrinkWrap: true ,children: <Widget>[
      ListTile(trailing: Text(_group),title: Text(_name),),
      ListTile(title: Text("Gender: ${_gend(_sex)}"),),
      ListTile(subtitle: Text("Location: $_location"),),
      ListTile(title: Text("Phone number: $_phone")),
      ListTile(title: Text("Age: $_age")),
      ListTile(title: Text("Request Created on: $_created")),],),
    ],),);
  }
}