
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadConfigureInit() async{
  await dotenv.load(fileName: ".env", mergeWith: {
    'TEST_VAR': '5',
  }); // mergeWith optional, you can i

  late String apiBaseUrl = dotenv.get('API_BASE_URL');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //pasamos la base url en el shared preference para usarlo en el package http2
  await prefs.setString('api_baseURL', apiBaseUrl);
}