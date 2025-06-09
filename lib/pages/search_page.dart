import 'dart:ui';
import 'package:flutter/material.dart';

import '../components/card_widget.dart';
import '../services/weather.dart';
import '../utils/get_current_location.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  final weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();
  Map<String, dynamic> weatherData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocationAndFetchWeather(context);
    });
  }

  Future<void> _getCurrentLocationAndFetchWeather(BuildContext context) async {
    setState(() => isLoading = true);
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
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchData(String cidade, BuildContext context) async {
    setState(() => isLoading = true);
    try {
      final data = await weatherService.getWeather(cidade, context);

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Erro ao buscar clima pela cidade: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'Digite a cidade',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final cidade = cityController.text.trim();
                        if (cidade.isNotEmpty) {
                          fetchData(cidade, context);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (weatherData.isNotEmpty)
                  WeatherCard(data: weatherData)
                else
                  const Center(child: Text('Sem dados')),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
