import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(
    String city,
    BuildContext context,
  ) async {
    try {
      return await _fetchWeather({'q': city}, context);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWeatherByCoordinates(
    double lat,
    double lon,
    BuildContext context,
  ) async {
    try {
      return await _fetchWeather({
        'lat': lat.toString(),
        'lon': lon.toString(),
      }, context);
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> _fetchWeather(
    Map<String, String> params,
    BuildContext context,
  ) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          ...params,
          'appid': dotenv.env['API_KEY'],
          'units': 'metric',
          'lang': 'pt_br',
        },
      );
      return response.data;
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(content: Text('Falha ao buscar dados do clima')),
      );
      throw e;
    }
  }
}
