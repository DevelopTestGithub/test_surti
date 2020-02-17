import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/location_point.dart';
import 'package:surtiSP/styles/colors.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/util/geo/map_image.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/wrappers/location.dart';

class LocationPage extends StatefulWidget {
  final LocationCallbackPetition callback;

  LocationPage(this.callback);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController latController = new TextEditingController();
  TextEditingController longController = new TextEditingController();
  static const DISTANCE_TO_MOVE = 0.00044915558;
  static const BUTTON_SIZE = 34.0;
  static Color NAVIGATION_BUTTON_COLOR = CS.NICE_BLUE;
  bool isLocationReady = false;
  LocationPoint location = LocationPoint(lat: 0, long: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocationSearcher.getCurrentLocation((position) {
      print("lo0cat = ${position.success}");
      print(position.location.lat);
      print(position.location.long);
      if (position.success) {
        setState(() {
          location = position.location;
          isLocationReady = true;
        });
      } else {
        //HANDLE
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    latController.text = location.lat.toString();
    longController.text = location.long.toString();
    return Material(
      color: C.DEEP_SEA_BLUE,
      child: Stack(
        children: <Widget>[
          MainHeader(
            () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          Container(
            height: MyApp.screenHeightRaw,
            width: MyApp.screenWidth,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: MyApp.screenWidth * .3,
                              child: Text(
                                "Latitud",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              width: MyApp.screenWidth * .07,
                            ),
                            Container(
                              width: MyApp.screenWidth * .3,
                              child: Text(
                                "Longitud",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: MyApp.screenWidth * .3,
                                child: Text(
                                  location.lat.toString(),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )),
                            SizedBox(
                              width: MyApp.screenWidth * .07,
                            ),
                            Container(
                                width: MyApp.screenWidth * .3,
                                child: Text(
                                  location.long.toString(),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Stack(alignment: Alignment.center, children: [
                    Container(
                        width: MyApp.screenWidth * .9,
                        height: MyApp.screenHeight * .4,
                        child: MapImage(
                          lat: location.lat,
                          long: location.long,
                          width: MyApp.screenWidth * .9,
                          height: MyApp.screenHeight * .4,
                        )),
                    Container(
                        width: MyApp.screenWidth * .9,
                        height: MyApp.screenHeight * .4,
                        alignment: Alignment.center,
                        child: Container(
                          width: 15.2,
                          height: 15.2,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2, color: CS.APPLE_GREEN),
                              borderRadius: BorderRadius.circular(15.2 / 2)),
                        )),
                    Container(
                      width: MyApp.screenWidth * .9,
                      height: MyApp.screenHeight * .4,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                location.lat += DISTANCE_TO_MOVE;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: NAVIGATION_BUTTON_COLOR,
                                  border:
                                      Border.all(width: 1, color: CS.WHITE)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_drop_up,
                                color: Colors.white,
                              ),
                              width: BUTTON_SIZE,
                              height: BUTTON_SIZE,
                            ),
                          ),
                          Container(
                            width: MyApp.screenWidth * .9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        location.long -= DISTANCE_TO_MOVE;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: NAVIGATION_BUTTON_COLOR,
                                          border: Border.all(
                                              width: 1, color: CS.WHITE)),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.arrow_left,
                                        color: Colors.white,
                                      ),
                                      width: BUTTON_SIZE,
                                      height: BUTTON_SIZE,
                                    )),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      location.long += DISTANCE_TO_MOVE;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: NAVIGATION_BUTTON_COLOR,
                                        border: Border.all(
                                            width: 1, color: CS.WHITE)),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_right,
                                      color: Colors.white,
                                    ),
                                    width: BUTTON_SIZE,
                                    height: BUTTON_SIZE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                location.lat -= DISTANCE_TO_MOVE;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: NAVIGATION_BUTTON_COLOR,
                                  border:
                                      Border.all(width: 1, color: CS.WHITE)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              width: BUTTON_SIZE,
                              height: BUTTON_SIZE,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      if (isLocationReady) {
                        Navigator.pop(context);
                        LocationPetition petition = LocationPetition(
                            location: LocationPoint(
                                lat: location.lat, long: location.long),
                            success: true);
                        widget.callback(petition);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      width: MyApp.screenWidth * .4,
                      alignment: Alignment.center,
                      child: Text(
                        isLocationReady ? "Continuar" : "Usando GPS",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      height: 48,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  final Color bgColor;

  final String hint;
  final TextEditingController controller;
  final double height, width;

  TextInput(
      {this.bgColor = Colors.white,
      this.hint = "",
      this.controller,
      this.height = 40,
      this.width = 200});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: height,
      width: width,
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          alignLabelWithHint: true,
          hintStyle: TextStyle(fontSize: 17),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
