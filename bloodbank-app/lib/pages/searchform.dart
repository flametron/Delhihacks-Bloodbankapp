import 'package:flutter/material.dart';
import './search.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import './resulttile.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';

bool apicall = true;
var hoslist = [];

class Hospital {
  int phone;
  String sex;
  String email;
  String location;
  String name;
  String group;
  //String medreport;

  Hospital(
      {this.phone, this.sex, this.email, this.location, this.name, this.group});
  factory Hospital.fromJson(Map<String, dynamic> json) {
/*
    if(json['medicalreport']!=null)
      return Hospital(
      phone: json['phone'],
      sex: json['sex'],
      email: json['email'],
      location: json['location'],
      name: json['name'],
      group: json['bloodgroup'],
      medreport: json['medicalreport'],
      );
    */
    return Hospital(
      phone: json['phone'],
      sex: json['sex'],
      email: json['email'],
      location: json['location'],
      name: json['name'],
      group: json['bloodgroup'],
    );
  }
}

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class Blood {
  String group;
  Blood(this.group);
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _control = TextEditingController(text: location);
  var curgroup;
  var radius = 5.0;
  bool _buttonenabled;
  bool _isInitial;

  String getGroup(grp) {
    if (grp == null) return "<Select Group>";
    return grp;
  }

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _buttonenabled = true;
    _isInitial = true;
    _control.addListener(onChange);
    _control.text = location;
    super.initState();
  }

  void onChange() {
    setState(() {
      location = _control.text;
    });
  }

  void fetchHospitals() async {
    hoslist = [];
    Dio dio = Dio();
    FormData frm = FormData.fromMap({
      "key": "[REMOVED]",
      "location": "$location",
      "bloodgroup": "$curgroup",
      "radius": "$radius"
    });
    var response = await dio
        .post("https://[REMOVED]/find", data: frm);
    print(response.statusCode);
    if (response.statusCode == 201) {
      var res = response.data;
      if (res.length > 0)
        toast("Donors found!");
      else
        toast("No Donor Found!");
      for (var i = 0; i < res.length; i++) {
        hoslist.add(Hospital.fromJson(res[i]));
      }
      setState(() {
        apicall = false;
        _buttonenabled = true;
      });
    } else {
      toast("Failed to load donors!");
      print('Failed to load hospitals');
      setState(() {
        apicall = false;
        _buttonenabled = true;
      });
    }
  }

  Widget getProperWidget() {
    var _usednumbers = [];
    if (apicall) if (_isInitial)
      return Container();
    else
      return Center(
        child: CircularProgressIndicator(),
      );
    else {
      List<Widget> lst = [];
      for (var i = 0; i < hoslist.length; i++) {
        if (!_usednumbers.contains(hoslist[i].phone)) {
          _usednumbers.add(hoslist[i].phone);
          lst.add(SearchResultTile(
            "${hoslist[i].phone}",
            hoslist[i].sex,
            hoslist[i].email,
            hoslist[i].location,
            hoslist[i].name,
            hoslist[i].group,
          ));
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
      } else {
        return Center(
            child: Column(
          children: <Widget>[
            Text("No Blood Donor found with this group."),
            Text("Please request from Request Tab")
          ],
        ));
      }
    }
  }

  Widget _getButton() {
    if (_buttonenabled) {
      return RaisedButton(
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          if (_formKey.currentState.validate()) {
            setState(() {
              _buttonenabled = false;
              _isInitial = false;
              apicall = true;
              fetchHospitals();
            });
          }
        },
        child: Text(
            'Search for ${getGroup(curgroup)} within $radius km from $location'),
      );
    } else
      return RaisedButton(
        onPressed: null,
        child: Text(
            'Waiting for ${getGroup(curgroup)} within $radius km from $location'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: TextFormField(
                    controller: _control,
                    decoration: const InputDecoration(
                      hintText: 'Enter you location',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your location';
                      }
                      setState(() {
                        location = value;
                      });
                      return null;
                    },
                  ),
                ),
                Center(
                  child: DropDownFormField(
                    titleText: 'Select Blood Group',
                    hintText: 'Please choose one',
                    value: curgroup,
                    onSaved: (value) {
                      setState(() {
                        curgroup = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        curgroup = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "O+ (O Positive)",
                        "value": "O+",
                      },
                      {
                        "display": "O- (O Negative)",
                        "value": "O-",
                      },
                      {
                        "display": "A+ (A Positive)",
                        "value": "A+",
                      },
                      {
                        "display": "A- (A Negative)",
                        "value": "A-",
                      },
                      {
                        "display": "B+ (B Positive)",
                        "value": "B+",
                      },
                      {
                        "display": "B- (B Negative)",
                        "value": "B-",
                      },
                      {
                        "display": "AB+ (AB Positive)",
                        "value": "AB+",
                      },
                      {
                        "display": "AB- (AB Negative)",
                        "value": "AB-",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                Center(
                  child: Text("Select your range (in km):"),
                ),
                Center(
                  child: FlutterSlider(
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black12,
                        border: Border.all(width: 3, color: Colors.blue),
                      ),
                      activeTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.blue.withOpacity(0.5)),
                    ),
                    values: [5],
                    max: 50,
                    min: 5,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      radius = lowerValue;
                      setState(() {
                        radius = lowerValue;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: _getButton(),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: getProperWidget()),
              ],
            )));
  }
}
