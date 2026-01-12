import 'package:flutter_test/flutter_test.dart';
// Replace 'your_project_name' with your actual package name
import 'package:weather_app/weather_model.dart';

void main() {
  group('Weather Model - fromJson', () {
    test('should return a valid Weather model from OpenWeatherMap JSON', () {
      // 1. Arrange: Realistic Manila sample from OpenWeatherMap API
      final Map<String, dynamic> jsonResponse = {
        "coord": {"lon": 120.9822, "lat": 14.5995},
        "weather": [
          {
            "id": 802,
            "main": "Clouds",
            "description": "scattered clouds",
            "icon": "03d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 30.5,
          "feels_like": 35.2,
          "temp_min": 29.0,
          "temp_max": 31.5,
          "pressure": 1010,
          "humidity": 65
        },
        "visibility": 10000,
        "wind": {"speed": 3.6, "deg": 80},
        "clouds": {"all": 40},
        "dt": 1700000000,
        "sys": {
          "type": 1,
          "id": 8160,
          "country": "PH",
          "sunrise": 1700000000,
          "sunset": 1700040000
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      };

      // 2. Act: Call the fromJson method
      final result = Weather.fromJson(jsonResponse);

      // 3. Assert: Check if the values match the JSON
      expect(result.cityName, 'Manila');
      expect(result.temperature, 30.5);
      expect(result.description, 'scattered clouds');
      expect(result.humidity, 65);
    });

    test('should handle integer temperatures by converting to double', () {
      // OpenWeatherMap sometimes returns whole numbers (e.g., 30 instead of 30.0)
      final Map<String, dynamic> jsonWithInt = {
        "weather": [{"description": "clear sky"}],
        "main": {"temp": 30, "humidity": 70},
        "name": "Manila"
      };

      final result = Weather.fromJson(jsonWithInt);

      expect(result.temperature, 30.0);
      expect(result.temperature, isA<double>());
    });
  });
}