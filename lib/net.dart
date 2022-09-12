import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<bool>get()
async {
  bool  result =await InternetConnectionChecker().hasConnection;
  return result;
}
class hiii{
  static  SharedPreferences? prefs;
}