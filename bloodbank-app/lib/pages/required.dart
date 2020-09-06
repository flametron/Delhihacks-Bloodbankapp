import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:overlay_support/overlay_support.dart';
import './requiredlisttile.dart';

class ReQ {
  int phone;
  String sex;
  String created;
  String location;
  String name;
  String group;
  String age;

  ReQ(
      {this.phone,
      this.sex,
      this.created,
      this.location,
      this.name,
      this.group,
      this.age});
  factory ReQ.fromJson(Map<String, dynamic> json) {
    return ReQ(
      phone: json['phone'],
      sex: json['sex'],
      created: json['created'],
      location: json['location'],
      name: json['name'],
      group: json['bloodgroup'],
      age: json['age'],
    );
  }
}

class RequiredPage extends StatefulWidget {
  @override
  _RequiredPageState createState() => _RequiredPageState();
}

class _RequiredPageState extends State<RequiredPage> {
  var reqs = [];
  bool _apicall;
  bool _buttonenabled;

  void _fetchRequirements() async {
    Dio dio = Dio();
    FormData frm = FormData.fromMap({"key": "c82ba6a6dd6c4ed1a00cde4909a0aa"});
    try {
      var response = await dio.post(
          "https://blood-bank-qkfjvcvewq-ez.a.run.app/requireblood",
          data: frm);
      print(response.statusCode);
      if (response.statusCode == 201) {
        var res = response.data;
        if (res.length > 0) toast("Blood Requirements Loaded!");
        for (var i = 0; i < res.length; i++) {
          reqs.add(ReQ.fromJson(res[i]));
        }
        setState(() {
          _apicall = false;
          _buttonenabled = true;
        });
      } else {
        print('Failed to load requirements');
        setState(() {
          _apicall = false;
          _buttonenabled = true;
        });
      }
    } on DioError catch (e) {
      toast("${e.response.statusCode}");
      showSimpleNotification(Text("Error on Loading!"),
          leading: Icon(Icons.error), position: NotificationPosition.bottom);
      setState(() {
        _apicall = false;
        _buttonenabled = true;
      });
    }
  }

  Widget _getProperWidget() {
    var _usednumbers = [];
    if (_apicall)
      return Center(
        child: CircularProgressIndicator(),
      );
    else {
      List<Widget> lst = [];
      for (var i = 0; i < reqs.length; i++) {
        if (!_usednumbers.contains(reqs[i].phone)) {
          _usednumbers.add(reqs[i].phone);
          lst.add(RequiredListTile("${reqs[i].phone}", reqs[i].sex, reqs[i].age,
              reqs[i].location, reqs[i].name, reqs[i].group, reqs[i].created));
        }
      }
      if (lst.length > 0) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              children: lst,
            ),
          ),
        );
      } else
        return Center(
            child: Column(
          children: <Widget>[Text("No Blood Requirements.")],
        ));
    }
  }

  @override
  void initState() {
    _fetchRequirements();
    _apicall = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getProperWidget(),
    );
  }
}
