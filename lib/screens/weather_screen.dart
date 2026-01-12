import 'package:flutter/material.dart';

// 1. MOCK MODEL
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

// 2. MOCK STATES
abstract class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);
}
class WeatherError extends WeatherState {}

// 3. MAIN WIDGET
class WeatherScreen extends StatelessWidget {
  final WeatherState state;

  const WeatherScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background for a modern purple look
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white70, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          'Error fetching weather',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                if (state is WeatherLoaded) {
                  final weather = (state as WeatherLoaded).weather;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Location Header (Simulated)
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

                      // Condition Icon/Text
                      const Icon(Icons.wb_cloudy_rounded, size: 100, color: Colors.white),
                      Text(
                        weather.condition.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),

                      // Temperature
                      Text(
                        '${weather.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),

                      const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ).applyToText("Expect scattered clouds"),

                      const SizedBox(height: 60),

                      // Glass-morphism style Info Card
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoCard(
                              icon: Icons.opacity_rounded,
                              label: 'HUMIDITY',
                              value: '${weather.humidity}%',
                            ),
                            // Vertical Divider
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
                  child: Text('No data available', style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// 4. REUSABLE WIDGET (Designed with clean layout)
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

// Extension to fix the floating TextStyle in the snippet
extension TextStyleApply on TextStyle {
  Widget applyToText(String data) => Text(data, style: this);
}
