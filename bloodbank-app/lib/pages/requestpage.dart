import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:dio/dio.dart';

class RequestPageExternal extends StatefulWidget {
  @override
  _RequestPageExternalState createState() => _RequestPageExternalState();
}

class _RequestPageExternalState extends State<RequestPageExternal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _control_phone = new TextEditingController();
  TextEditingController _control_sex = new TextEditingController();
  TextEditingController _control_location = new TextEditingController();
  TextEditingController _control_name = new TextEditingController();
  TextEditingController _control_group = new TextEditingController();
  TextEditingController _control_age = new TextEditingController();
  String _phone;
  String _sex;
  String _location;
  String _name;
  String _group;
  String _age;
  bool _buttonenabled;
  @override
  void initState() {
    _buttonenabled = true;
    super.initState();
    _control_name.addListener(onChange);
    _control_location.addListener(onChange);
    _control_phone.addListener(onChange);
  }

  void onChange() {
    setState(() {
      _location = _control_location.text;
      _name = _control_name.text;
      _phone = _control_phone.text;
    });
  }

  void _sendRequest() async {
    Dio dio = Dio();
    FormData frm = FormData.fromMap({
      "key": "[REMOVED]",
      "location": "$_location",
      "bloodgroup": "$_group",
      "name": "$_name",
      "phone": "$_phone",
      "sex": "$_sex",
      "age": "$_age"
    });
    var response = await dio.post(
        "https://[REMOVED]/requestblood",
        data: frm);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Data Sent");
      toast("Blood has been requested");
      setState(() {
        _buttonenabled = true;
      });
    } else {
      toast("Failed to send data ${response.statusCode}");
      print('Failed to send data ${response.statusCode}');
      setState(() {
        _buttonenabled = true;
      });
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
              _sendRequest();
            });
          }
        },
        child: Text('Send Request for $_group at $_location'),
      );
    } else
      return RaisedButton(
        onPressed: null,
        child: Text('Sending Request for $_group at $_location'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Center(
              child: TextFormField(
                controller: _control_name,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  setState(() {
                    _name = value;
                  });
                  return null;
                },
              ),
            ),
            Center(
              child: TextFormField(
                controller: _control_age,
                decoration: const InputDecoration(
                  hintText: 'Enter your age',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your age';
                  }
                  setState(() {
                    _age = value;
                  });
                  return null;
                },
              ),
            ),
            Center(
              child: TextFormField(
                controller: _control_phone,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone number',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10)
                    return 'Enter correct phone number (min 10 digits)';
                  setState(() {
                    _phone = value;
                  });
                  return null;
                },
              ),
            ),
            Center(
              child: TextFormField(
                controller: _control_location,
                decoration: const InputDecoration(
                  hintText: 'Enter your location',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your location';
                  }
                  setState(() {
                    _location = value;
                  });
                  return null;
                },
              ),
            ),
            Center(
              child: DropDownFormField(
                titleText: 'Select Blood Group',
                hintText: 'Please choose one',
                value: _group,
                onSaved: (value) {
                  setState(() {
                    _group = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _group = value;
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
              child: DropDownFormField(
                titleText: 'Select Gender',
                hintText: 'Please choose one',
                value: _sex,
                onSaved: (value) {
                  setState(() {
                    _sex = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _sex = value;
                  });
                },
                dataSource: [
                  {
                    "display": "Male",
                    "value": "M",
                  },
                  {
                    "display": "Female",
                    "value": "F",
                  },
                  {
                    "display": "Others",
                    "value": "O",
                  }
                ],
                textField: 'display',
                valueField: 'value',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: _getButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
