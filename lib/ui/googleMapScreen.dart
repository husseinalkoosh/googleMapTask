import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:locationtask/Model/userModel.dart';
import 'package:locationtask/functions/functions.dart';
import 'package:locationtask/utils/static_ui.dart';

String femaleOnly = 'Female Only';
String maleOnly = 'Male Only';
String maleAndFemale = 'Male And Female';
String searchByName = 'search By Name';
String nearby2000Km = 'nearby 2000 Km';
String selectedField = "";

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  var location = new Location();
  int idIncreament = 6;
  int firstNameIncreament = 7;
  int lastNameIncreament = 8;
  int genderIncreament = 9;
  int latIncreament = 10;
  int loncreament = 11;
  String female = 'Female';
  String male = 'Male';

  Completer<GoogleMapController> _controller = Completer();
  bool cameraMoveStop = false;
  GlobalKey<ScaffoldState> _GlobalKey = GlobalKey();
  static double lat = 31.0598508;
  static double long = 32.3537609;
  List<UserModel> userModelList = List();
  List<Marker> markers_list = List();
  String radioItem = '';
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    getDataFromFile();
    location.getLocation().then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      location.onLocationChanged().listen((LocationData currentLocation) {
        lat = currentLocation.latitude;
        long = currentLocation.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _GlobalKey,
      appBar: AppBar(
        title: Text("Google Map Task"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showAlertDailog();
//            String femaleOnly='Female Only';
//            String maleOnly='Male Only';
            },
          )
        ],
      ),
      body: userModelList.length==0?StaticUI().progressIndicatorWidget():Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(16),
        child: GoogleMap(
           myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, long),
            zoom: 1,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: (position) {
            if (cameraMoveStop) {
              setState(() {
                lat = position.target.latitude;
                long = position.target.longitude;
              });
            }
          },
          markers: Set<Marker>.of(markers_list),
//          icon: BitmapDescriptor.defaultMarkerWithHue(200),
        ),
      ),
    );
  }
  Widget showAlertDailog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: RadioListBuilder(
                    num: 5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .grey //                   <--- border width here
                            ),
                          ),
                          child: Text(
                            "Filter",
                            style: TextStyle(color: Colors.white),
                          )),
                      onTap: () async {
                        if (selectedField == femaleOnly) {
                          // clear markers list
                          markers_list.clear();

                          for (int i = 0; i < userModelList.length; i++) {
                            if (userModelList[i].gender == female) {
                              setState(() {
                                markers_list.add(Marker(
                                    draggable: true,
                                    markerId:
                                    MarkerId("${userModelList[i].id}"),
                                    position: LatLng(userModelList[i].lat,
                                        userModelList[i].lon),
                                    icon: BitmapDescriptor
                                        .defaultMarkerWithHue(300),
                                    infoWindow: InfoWindow(
                                      title: "${userModelList[i].first_name} : ${userModelList[i].last_name}",
                                    )));
                              });
                            } else {}
                          }
                          Navigator.of(context).pop();

                        }
                        else if (selectedField == maleOnly) {
                          markers_list.clear();

                          for (int i = 0; i < userModelList.length; i++) {
                            if (userModelList[i].gender == male) {
                              setState(() {
                                markers_list.add(Marker(
                                    draggable: true,
                                    markerId:
                                    MarkerId("${userModelList[i].id}"),
                                    position: LatLng(userModelList[i].lat,
                                        userModelList[i].lon),
                                    icon: BitmapDescriptor
                                        .defaultMarkerWithHue(200),
                                    infoWindow: InfoWindow(
                                      title: "${userModelList[i].first_name} : ${userModelList[i].last_name}",
                                    )));
                              });
                            } else {}
                          }
                          Navigator.of(context).pop();
                        }
                        else if(selectedField == maleAndFemale){

                          markers_list.clear();

                          for (int i = 0; i < userModelList.length; i++) {
                            setState(() {
                              markers_list.add(Marker(
                                  draggable: true,
                                  markerId:
                                  MarkerId("${userModelList[i].id}"),
                                  position: LatLng(userModelList[i].lat,
                                      userModelList[i].lon),
                                  icon: userModelList[i].gender == female
                                      ? BitmapDescriptor.defaultMarkerWithHue(300)
                                      : BitmapDescriptor.defaultMarkerWithHue(200),
                                  infoWindow: InfoWindow(
                                    title: "${userModelList[i].first_name} : ${userModelList[i].last_name}",
                                  )));
                            });
                          }
                          // disable alert Dailog
                          Navigator.of(context).pop();



                        }
                        // searching by name
                        else if(selectedField==searchByName){
                          Navigator.of(context).pop();
                          dailogName();
                        }
                        else if(selectedField==nearby2000Km){

                          markers_list.clear();

                          for (int i = 0; i < userModelList.length; i++) {

//chick if distance less than 2000 KM
                            if(double.parse(functionsClass().distanceInKmBetweenEarthCoordinates(lat,lat, userModelList[i].lat,
                                userModelList[i].lon))<=2000){
                              setState(() {
                                markers_list.add(Marker(
                                    draggable: true,
                                    markerId:
                                    MarkerId("${userModelList[i].id}"),
                                    position: LatLng(userModelList[i].lat,
                                        userModelList[i].lon),
                                    icon: userModelList[i].gender == female
                                        ? BitmapDescriptor.defaultMarkerWithHue(300)
                                        : BitmapDescriptor.defaultMarkerWithHue(200),
                                    infoWindow: InfoWindow(
                                      title: "${userModelList[i].first_name} : ${userModelList[i].last_name}",
                                    )));


                              });
                            }
                          }
                          Navigator.of(context).pop();
                        }
                        else {}
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .grey //                   <--- border width here
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )),
                      onTap: () {
                        print('Tappped');
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
  Widget dailogName() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height /3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.right,
                    //     keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Enter First Or Last Name",

                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .grey //                   <--- border width here
                            ),
                          ),
                          child: Text(
                            "Filter",
                            style: TextStyle(color: Colors.white),
                          )),
                      onTap: () async {
                        if(_nameController.text.isEmpty){
                          _GlobalKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              'Please Enter Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                        else {
                          markers_list.clear();
                          for (int i = 0; i < userModelList.length; i++) {
                            if (userModelList[i].first_name .contains(_nameController.text)||userModelList[i].last_name .contains(_nameController.text)) {
                              setState(() {
                                markers_list.add(Marker(
                                    draggable: true,
                                    markerId:
                                    MarkerId("${userModelList[i].id}"),
                                    position: LatLng(userModelList[i].lat,
                                        userModelList[i].lon),
                                    icon: userModelList[i].gender == female
                                        ? BitmapDescriptor.defaultMarkerWithHue(300)
                                        : BitmapDescriptor.defaultMarkerWithHue(200),
                                    infoWindow: InfoWindow(
                                      title: "${userModelList[i].first_name} : ${userModelList[i].last_name}",
                                    )));
                              });
                            } else {}
                          }
                          _nameController.clear();

                          Navigator.of(context).pop();
                        }

                      },
                    ),
                    GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .grey //                   <--- border width here
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )),
                      onTap: () {
                        print('Tappped');
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

// getting file from assets
  getDataFromFile() async {
    getFileData('assets/mock.txt').then((RespondedData) {
      var singleline = RespondedData.replaceAll("\n", ",");
      for (int i = 0; i < singleline.split(",").length; i++) {
        if (firstNameIncreament == singleline.split(",").length) {
          break;
        } else {
          setState(() {
            userModelList.add(UserModel(
                id: int.parse(singleline.split(",")[idIncreament]),
                first_name: singleline.split(",")[firstNameIncreament],
                last_name: singleline.split(",")[lastNameIncreament],
                gender: singleline.split(",")[genderIncreament],
                lat: double.parse(singleline.split(",")[latIncreament]),
                lon: double.parse(singleline.split(",")[loncreament])));

            markers_list.add(Marker(
                draggable: true,
                markerId: MarkerId(
                    "${int.parse(singleline.split(",")[idIncreament])}"),
                position: LatLng(
                    double.parse(singleline.split(",")[latIncreament]),
                    double.parse(singleline.split(",")[loncreament])),
                icon: singleline.split(",")[genderIncreament] == female
                    ? BitmapDescriptor.defaultMarkerWithHue(300)
                    : BitmapDescriptor.defaultMarkerWithHue(200),
                infoWindow: InfoWindow(
                  title: singleline.split(",")[firstNameIncreament]+singleline.split(",")[lastNameIncreament],
                )));
            idIncreament = idIncreament + 6;
            firstNameIncreament = firstNameIncreament + 6;
            lastNameIncreament = lastNameIncreament + 6;
            genderIncreament = genderIncreament + 6;
            latIncreament = latIncreament + 6;
            loncreament = loncreament + 6;
          });
        }
      }
    });
  }
}
// radio buttons list
class RadioListBuilder extends StatefulWidget {
  final int num;

  const RadioListBuilder({Key key, this.num}) : super(key: key);

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  int value;

  @override
  Widget build(BuildContext context) {
    List filterList = [femaleOnly, maleOnly,maleAndFemale,searchByName,nearby2000Km];
    return SingleChildScrollView(
      child: Container(
//        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.2,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            if (value == 0) {
              selectedField = femaleOnly;
            } else if (value == 1) {
              selectedField = maleOnly;
            } else if (value == 2) {
              selectedField = maleAndFemale;
            } else if (value == 3) {
              selectedField = searchByName;
            }else if (value == 4) {
              selectedField = nearby2000Km;
            }

            print("${value}ewdwfewfwef");

            return Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: new Text(
                      "${filterList[index]}",
                      style: new TextStyle(
                        color: Color(0xff4D409A),
                      ),
                    ),
                  ),
                  index == 0
                      ? SizedBox(
                          width: 15,
                        )
                      : index == 1
                          ? SizedBox()
                          : SizedBox(
                              width: 10,
                            ),
                  new Radio(
                    activeColor: Color(0xff4D409A),
                    value: index,
                    groupValue: value,
                    onChanged: (ind) => setState(() => value = ind),
                  ),
                ],
              ),
            );
          },
          itemCount: widget.num,
        ),
      ),
    );
  }
}
