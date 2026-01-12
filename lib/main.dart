import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherScreen(
      // Manually setting state to 'Loaded' so you see the design immediately
      state: WeatherLoaded(
        Weather(
          condition: "Scattered Clouds",
          temperature: 30.5,
          humidity: 65,
          windSpeed: 3.6,
        ),
      ),
    ),
  ));
}

// 1. MODEL
class Weather {
  final String condition;
  final double temperature;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.condition,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });
}

// 2. STATES
abstract class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);
}
class WeatherError extends WeatherState {}

// 3. MAIN UI
class WeatherScreen extends StatelessWidget {
  final WeatherState state;

  const WeatherScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // Deep Purple
              Color(0xFF7B1FA2), // Medium Purple
              Color(0xFF9C27B0), // Light Purple
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Builder(
              builder: (context) {
                if (state is WeatherLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state is WeatherError) {
                  return const Center(
                    child: Text('Error fetching weather',
                        style: TextStyle(color: Colors.white)),
                  );
                }

                if (state is WeatherLoaded) {
                  final weather = (state as WeatherLoaded).weather;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "MANILA",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Icon(Icons.wb_cloudy_rounded,
                          size: 100, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        weather.condition.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '${weather.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Expect scattered clouds",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Glass-morphism Info Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoCard(
                              icon: Icons.opacity_rounded,
                              label: 'HUMIDITY',
                              value: '${weather.humidity}%',
                            ),
                            Container(height: 40, width: 1, color: Colors.white24),
                            WeatherInfoCard(
                              icon: Icons.air_rounded,
                              label: 'WIND',
                              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return const Center(
                  child: Text('No data available',
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// 4. INFO CARD COMPONENT
class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}