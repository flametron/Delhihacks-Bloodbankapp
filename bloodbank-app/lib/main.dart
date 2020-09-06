import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './pages/frontpage.dart';
import './pages/loginscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  Future<Widget> getWidget() async {
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: "token");
    if (value == null) {
      return LoginPage();
    } else {
      return Center(
        child: Text("Need to fix login"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getWidget();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: OverlaySupport(
        child: MaterialApp(
          themeMode: ThemeMode.system,
          theme: ThemeData(primarySwatch: Colors.red),
          darkTheme: ThemeData.dark(),
          home: FutureBuilder<Widget>(
            future: getWidget(),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              Widget ret;
              if (snapshot.hasData) {
                ret = snapshot.data;
              } else {
                ret = CircularProgressIndicator();
              }
              return ret;
            },
          ),
        ),
      ),
    );
  }
}
