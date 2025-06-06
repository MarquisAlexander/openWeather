import 'dart:ui';
import 'package:flutter/material.dart';

import '../components/card_widget.dart';
import '../services/weather.dart';
import '../utils/get_current_location.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndFetchWeather();
  }

  final weatherService = WeatherService();

  Future<void> _getCurrentLocationAndFetchWeather() async {
    final position = await getCurrentLocation();
    if (position == null) return;

    final data = await weatherService.getWeatherByCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      weatherData = data;
    });
  }

  final TextEditingController cityController = TextEditingController();
  Map<String, dynamic> weatherData = {};

  Future<void> fetchData(String cidade) async {
    final data = await weatherService.getWeather(cidade);

    setState(() {
      weatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clima')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Digite a cidade',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final cidade = cityController.text.trim();
                    if (cidade.isNotEmpty) {
                      fetchData(cidade);
                    }
                  },
                ),
              ),
            ),
            weatherData == null
                ? Center(child: Text('Sem dados'))
                : WeatherCard(data: weatherData),
          ],
        ),
      ),
    );
  }
}
