import 'package:flutter/material.dart';
import './fullpageshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './fullpagerequired.dart';

class RequiredListTile extends StatelessWidget {
  
  String _phone;
  String _sex;
  String _age;
  String _location;
  String _name;
  String _group; 
  String _created;
  

  RequiredListTile(this._phone,this._sex,this._age,this._location,this._name,this._group,this._created);


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
    MaterialPageRoute(builder: (context) => FullRequiredPreview(_phone,_sex,_age,_location,_name,_group,_created)),
  );
    } ,),);
  }
}
