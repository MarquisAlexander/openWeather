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
  final weatherService = WeatherService();

  final TextEditingController cityController = TextEditingController();
  Map<String, dynamic> weatherData = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocationAndFetchWeather(context);
    });
  }

  Future<void> _getCurrentLocationAndFetchWeather(BuildContext context) async {
    try {
      final position = await getCurrentLocation();
      if (position == null) return;

      final data = await weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
        context,
      );

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Erro ao buscar clima por localização: $e');
    }
  }

  Future<void> fetchData(String cidade, BuildContext context) async {
    try {
      final data = await weatherService.getWeather(cidade, context);

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Erro ao buscar clima pela cidade: $e');
    }
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
                      fetchData(cidade, context);
                    }
                  },
                ),
              ),
            ),
            weatherData.isEmpty
                ? Center(child: Text('Sem dados'))
                : WeatherCard(data: weatherData),
          ],
        ),
      ),
    );
  }
}
