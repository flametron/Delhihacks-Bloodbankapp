import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import './loginscreen.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<SignupPage> {
  TextEditingController firstNameHandle = TextEditingController();
  TextEditingController lastNameHandle = TextEditingController();
  TextEditingController emailHandle = TextEditingController();
  TextEditingController passwordHandle = TextEditingController();
  TextEditingController weightHandle = TextEditingController();
  TextEditingController phoneHandle = TextEditingController();
  String _group;
  String _phone;
  String _sex;
  String _fname;
  String _lname;
  String _age;
  String _email;
  String _pass;
  String _weight;
  String datetext = 'Pick Date of birth';
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 200),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.year,
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Date of birth',
      fieldHintText: 'MM/DD/YYYY',
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        datetext = DateFormat("dd/MM/yyyy").format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blood Bank Login'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Blood Bank',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Center(
                  child: TextFormField(
                    controller: firstNameHandle,
                    decoration: const InputDecoration(
                      hintText: 'Enter your first name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      setState(() {
                        _fname = value;
                      });
                      return null;
                    },
                  ),
                ),
                Center(
                  child: TextFormField(
                    controller: lastNameHandle,
                    decoration: const InputDecoration(
                      hintText: 'Enter your last name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      setState(() {
                        _lname = value;
                      });
                      return null;
                    },
                  ),
                ),
                Center(
                  child: TextFormField(
                    controller: emailHandle,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      setState(() {
                        _email = value;
                      });
                      return null;
                    },
                  ),
                ),
                Center(
                  child: TextFormField(
                    controller: passwordHandle,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      setState(() {
                        _pass = value;
                      });
                      return null;
                    },
                  ),
                ),
                Center(
                  child: TextFormField(
                    controller: weightHandle,
                    decoration: const InputDecoration(
                      hintText: 'Enter your weight',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      setState(() {
                        _weight = value;
                      });
                      return null;
                    },
                  ),
                ),
                Center(
                  child: TextFormField(
                    controller: phoneHandle,
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
                DropDownFormField(
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
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      color: Colors.white,
                      textColor: Theme.of(context).accentColor,
                      child: Text(datetext),
                      onPressed: () {
                        _selectDate(context);
                      },
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      child: Text('Sign Up'),
                      onPressed: () {
                        showSimpleNotification(
                            Text(
                                "Signed up! Returning to login page. Please Login!"),
                            leading: Icon(Icons.check),
                            position: NotificationPosition.bottom,
                            background: Colors.green);

                        Navigator.of(context).pop();
                      },
                    )),
              ],
            )));
  }
}
