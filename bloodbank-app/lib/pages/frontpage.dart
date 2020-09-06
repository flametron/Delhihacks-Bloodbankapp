import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import './search.dart';
import './requestpage.dart';
import './required.dart';

DateTime currentBackPressTime;

class FrontPage extends StatelessWidget {
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toast("Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("TITLE TO BE THOUGHT OF LATER"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: "Requirements",
              ),
              Tab(
                icon: Icon(Icons.search),
                text: "Search",
              ),
              Tab(
                icon: Icon(Icons.receipt),
                text: "Request Blood",
              ),
            ],
          ),
        ),
        body: WillPopScope(
          child: TabBarView(
            children: <Widget>[
              RequiredPage(),
              SearchPage(),
              RequestPageExternal(),
            ],
          ),
          onWillPop: onWillPop,
        ),
      ),
    );
  }
}
