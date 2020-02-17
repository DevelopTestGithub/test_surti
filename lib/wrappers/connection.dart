import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';

/*here*/

///Conection detection manager requires to be innited
class Connection {

  static String _connectionStatus = 'Unknown';
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult> _connectivitySubscription;
  static bool _isThereInternetConnection = false;
  static BoolCallBack _connectionCallback = (bool) {};
  
  static init() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  static setConnectionStream(BoolCallBack connectionCallback) {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        print("CONNECTION STATUS: ${result.toString()}");
        switch (result) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            _isThereInternetConnection = true;
            break;
          case ConnectivityResult.none:
          default:
            _isThereInternetConnection = false;
        }
        connectionCallback(_isThereInternetConnection);
      },
    );

    connectionCallback(_isThereInternetConnection);

//fix
    //  _connectionCallback = connectionCallback;
    // _connectionCallback(_isThereInternetConnection);
  }

  static bool isConnectedOnline() {
    return _isThereInternetConnection;
  }

  static Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print("CONNECTION STATUS: ${result.toString()}");
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        _isThereInternetConnection = true;
        break;
      case ConnectivityResult.none:
      default:
        _isThereInternetConnection = false;
    }

    _connectionCallback(_isThereInternetConnection);

    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;
        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }
        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }
        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        /* setState(() {
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });*/
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        // setState(() => _connectionStatus = result.toString());
        break;
      default:
        //  setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}
