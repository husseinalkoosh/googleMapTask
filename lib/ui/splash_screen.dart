import 'dart:async';

 import 'package:flutter/material.dart';
 import 'package:locationtask/ui/login_screens.dart';
import 'package:locationtask/utils/size_config.dart';


class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void navigateNextRoute(Widget targetRoute) => Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => targetRoute,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    navigateNextRoute(LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Image.asset(
          "assets/splashImage.png"
           ,
          width: SizeConfig.blockSizeHorizontal * 70,
          height: SizeConfig.safeBlockVertical * 40,
        ),
      ),
    );
  }
}
