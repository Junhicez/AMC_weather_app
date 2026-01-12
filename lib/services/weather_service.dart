import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  static const String apiKey = '89db3bd34ab71fd8d48001c768832e38';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';


  static Future<Weather> getWeather(String cityName) async {
    try {
      final String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

      final http.Response response = await http.get(Uri.parse(url),
        headers: {'Content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Weather.fromJson(data);

      }

      else if (response.statusCode ==404) {
        throw Exception('City not found');
      }
      else{
        throw Exception('Failed to load the weather data');
      }
    }
    catch (e) {
      throw Exception('Failed to load the weather data');

    }
  }
}