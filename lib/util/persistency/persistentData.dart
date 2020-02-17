import 'package:shared_preferences/shared_preferences.dart';

class PersistentData {
  static Future<bool> saveLoginTokens(String token, String refreshToken) async {
    
    if(token == null || refreshToken == null)
    return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('refresh_token', refreshToken);
    prefs.setBool('loaded', true);
    return true;
  }

  static Future<bool> save(StoredData storedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', storedData.token);
    prefs.setString('refresh_token', storedData.refreshToken);
    prefs.setBool('loaded', true);
    return true;
  }

  static Future<bool> erase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
    prefs.setString('refresh_token', "");
    prefs.setBool('loaded', false);
    return true;
  }

  static Future<StoredData> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loaded = prefs.getBool('loaded');
    var token = prefs.getString('token');
    var refreshT = prefs.getString('refresh_token');

    StoredData storeData = new StoredData();

    if (token != null && loaded == true) {
      storeData.token = prefs.getString('token');      
      storeData.refreshToken = prefs.getString('refresh_token');
      storeData.loaded = true;

      return storeData;
    }
    storeData.loaded = false;
    return storeData;
  }
}

class StoredData {
  String token;
  String refreshToken;
  bool loaded;

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}
