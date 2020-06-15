
import 'package:flutter/material.dart';


import 'package:locationtask/ui/googleMapScreen.dart';
import 'package:locationtask/utils/navigator.dart';
import 'package:locationtask/utils/size_config.dart';
import 'package:locationtask/utils/static_ui.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _PhoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/footer.png",
              width: SizeConfig.blockSizeHorizontal * 100,
              height: SizeConfig.safeBlockVertical * 25,
              fit: BoxFit.fill,
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              height: 50,
              decoration: StaticUI().containerDecoration(
                  colorValue: Colors.white, borderRidusValue: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextField(
                      controller: _PhoneController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Enter UserName",

                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Image.asset(
                        "assets/ic_phone.png",
                        width: 30,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              height: 50,
              decoration: StaticUI().containerDecoration(
                  colorValue: Colors.white, borderRidusValue: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextField(
                      controller: _passwordController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Enter Password",

                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Image.asset(
                        "assets/ic_password.png",
                        width: 30,
                      )),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  if (_PhoneController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    StaticUI().showSnackbar(
                        "Please Enter User Name and password",
                        _scaffoldKey);
                  } else {
                    if(_PhoneController.text!="google_task"||_passwordController.text!='123456'){
                      StaticUI().showSnackbar(
                          "Wrong User Name or password",
                          _scaffoldKey);
                    }
                    else {
                      navigateAndClearStack(context, GoogleMapScreen());

                    }

                  }
                },
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 80,
                  height: 50,
                  decoration: StaticUI().containerDecoration(
                      colorValue: Color.fromRGBO(69, 57, 137, 1.0),
                      borderRidusValue: 25),
                  child: Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.fontSize15),
                  )),
                )),



          ],
        ),
      ),
    );
  }
}
