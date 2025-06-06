import 'package:flutter/material.dart';

import '../utils/format_time.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> data;

  WeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final city = data['name'] ?? '---';
    final temp = data['main']?['temp'] ?? '---';
    final humidity = data['main']?['humidity'] ?? '---';
    final description = (data['weather'] != null && data['weather'].length > 0)
        ? data['weather'][0]['description']
        : '---';
    final iconCode = (data['weather'] != null && data['weather'].length > 0)
        ? data['weather'][0]['icon']
        : '01d';
    final windSpeed = data['wind']?['speed'] ?? '---';
    final sunrise = data['sys']?['sunrise'];
    final sunset = data['sys']?['sunset'];
    final timezone = data['timezone'] ?? 0;

    return Card(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              city,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${iconCode}@2x.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 8),
                Text('${temp} °C', style: TextStyle(fontSize: 20)),
              ],
            ),
            Text('Umidade: $humidity %'),
            Text('Condições: $description'),
            Text('Vento: $windSpeed m/s'),
            SizedBox(height: 8),
            Text(
              'Nascer do sol: ${sunrise != null ? formatTime(sunrise, timezone) : '---'}',
            ),
            Text(
              'Pôr do sol: ${sunset != null ? formatTime(sunset, timezone) : '---'}',
            ),
          ],
        ),
      ),
    );
  }
}
