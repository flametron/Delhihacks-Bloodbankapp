import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:dio/dio.dart';
import './search.dart';

class FullPreview extends StatefulWidget {
  String _phone;
  String _sex;
  String _email;
  String _location;
  String _name;
  String _group;
  String medreport;

  FullPreview(this._phone, this._sex, this._email, this._location, this._name,
      this._group);

  @override
  _FullPreviewState createState() =>
      _FullPreviewState(_phone, _sex, _email, _location, _name, _group);
}

class _FullPreviewState extends State<FullPreview> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controlName = TextEditingController();
  TextEditingController _controlNumber = TextEditingController();
  String _phone;
  String _sex;
  String _email;
  String _location;
  String _name;
  String _group;
  String medreport;
  String _recpname;
  String _recpphone;
  bool _buttonenabled;

  _FullPreviewState(this._phone, this._sex, this._email, this._location,
      this._name, this._group);

  String _gend(String g) {
    if (g == "M")
      return "Male";
    else if (g == "F")
      return "Female";
    else
      return "Other";
  }

  @override
  void initState() {
    _buttonenabled = true;
    super.initState();
  }

  void _sendRequest() async {
    Dio dio = Dio();
    FormData frm = FormData.fromMap({
      "key": "c82ba6a6dd6c4ed1a00cde4909a0aa",
      "name": "$_recpname",
      "location": location,
      "bloodgroup": _group,
      "phone": _phone,
      "recipentphone": _recpphone,
      "email": _email
    });
    var response = await dio
        .post("https://blood-bank-qkfjvcvewq-ez.a.run.app/notify", data: frm);
    print(response.statusCode);
    if (response.statusCode == 201) {
      print("Notification Sent");
      toast("Notification sent!");
    }
    setState(() {
      _buttonenabled = true;
    });
  }

  Widget _getButton() {
    if (_buttonenabled)
      return RaisedButton(
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          if (_formKey.currentState.validate()) {
            setState(() {
              _recpname = _controlName.text;
              _recpphone = _controlNumber.text;
              _sendRequest();
              _buttonenabled = false;
            });
          }
        },
        child: Text('Send Request'),
      );
    else
      return RaisedButton(
        onPressed: null,
        child: Text('Waiting for confirmation'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                trailing: Text(_group),
                title: Text(_name),
              ),
              ListTile(
                title: Text("Gender: ${_gend(_sex)}"),
              ),
              ListTile(
                subtitle: Text("Location: $_location"),
              ),
              ListTile(title: Text("Mobile: $_phone")),
              ListTile(title: Text("E-mail: $_email")),
            ],
          ),
          Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: TextFormField(
                          controller: _controlName,
                          decoration: const InputDecoration(
                            hintText: 'Enter you name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                            setState(() {
                              _recpname = value;
                            });
                            return null;
                          },
                        ),
                      ),
                      Center(
                        child: TextFormField(
                          controller: _controlNumber,
                          decoration: const InputDecoration(
                            hintText: 'Enter you number',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                            setState(() {
                              _recpphone = value;
                            });
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: _getButton(),
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}
