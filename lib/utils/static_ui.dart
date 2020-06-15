
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class StaticUI {
  Decoration containerDecoration({Color colorValue,double borderRidusValue,}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRidusValue),
      color: colorValue,
      border: Border.all(color: colorValue)

    );
  }





  void showSnackbar(String message, GlobalKey<ScaffoldState> scaffoldKey,{Color color = Colors.red}) {

    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ));
  }

  progressIndicatorWidget() {
    return Center(
        child: Container(
          child: CircularProgressIndicator(
            backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ));
  }


}


