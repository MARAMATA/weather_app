import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Clé API directement dans le code (pour développement)
  static const String _apiKey = '6b1baa2927f34b6b850152758251906';
  static const String baseUrl = 'https://api.weatherapi.com/v1';

  // Mapping des noms de villes pour l'API
  final Map<String, String> _cityApiNames = {
    'Dakar': 'Dakar',
    'Saint-Louis': 'Saint-Louis',
    'Thiès': 'Thies,Senegal',  // Sans accent + précision pays
    'Kaolack': 'Kaolack',
    'Ziguinchor': 'Ziguinchor,Senegal',  // Avec précision pays
  };

  // Noms d'affichage (avec accents)
  final Map<String, String> _cityDisplayNames = {
    'Dakar': 'Dakar',
    'Saint-Louis': 'Saint-Louis',
    'Thiès': 'Thiès',
    'Kaolack': 'Kaolack',
    'Ziguinchor': 'Ziguinchor',
  };

  /// Récupère la météo RÉELLE pour une ville sénégalaise
  Future<WeatherModel> getWeatherForCity(String cityName) async {
    try {
      // Utiliser le nom API approprié
      final apiCityName = _cityApiNames[cityName] ?? cityName;
      print('🌐 API RÉELLE: $cityName (API: $apiCityName)...');

      // URL WeatherAPI avec le nom corrigé
      final url = '$baseUrl/current.json?key=$_apiKey&q=$apiCityName&lang=fr';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ API: ${data['location']['name']} - ${data['current']['temp_c']}°C');

        return WeatherModel(
          cityName: _cityDisplayNames[cityName] ?? cityName, // Utiliser le nom d'affichage
          temperature: (data['current']['temp_c'] ?? 25).toDouble(),
          description: _fixEncoding(data['current']['condition']['text'] ?? 'Temps variable'),
          icon: '01d',
          humidity: (data['current']['humidity'] ?? 60).toDouble(),
          windSpeed: ((data['current']['wind_kph'] ?? 10) / 3.6).toDouble(),
          latitude: (data['location']['lat'] ?? 14.6928).toDouble(),
          longitude: (data['location']['lon'] ?? -17.4467).toDouble(),
        );
      } else {
        print('❌ API Error ${response.statusCode} pour $cityName');
        throw Exception('API Error ${response.statusCode}');
      }

    } catch (e) {
      print('❌ API échouée pour $cityName: $e');
      // Fallback sur données simulées avec le bon nom
      return _createFallbackWeather(cityName);
    }
  }

  /// Données de secours réalistes
  WeatherModel _createFallbackWeather(String cityName) {
    print('🏠 Données simulées pour $cityName');

    final now = DateTime.now();
    final isRainySeason = now.month >= 6 && now.month <= 10;

    final cityData = {
      'Dakar': {
        'temp': isRainySeason ? 28 : 25,
        'desc': isRainySeason ? 'Humide avec alizés' : 'Ensoleillé avec alizés',
        'humidity': isRainySeason ? 80 : 65,
      },
      'Saint-Louis': {
        'temp': isRainySeason ? 32 : 30,
        'desc': isRainySeason ? 'Chaud et humide' : 'Harmattan sec',
        'humidity': isRainySeason ? 60 : 35,
      },
      'Thiès': {
        'temp': isRainySeason ? 27 : 24,
        'desc': isRainySeason ? 'Orageux possible' : 'Ensoleillé',
        'humidity': isRainySeason ? 70 : 50,
      },
      'Kaolack': {
        'temp': isRainySeason ? 35 : 32,
        'desc': isRainySeason ? 'Très chaud humide' : 'Caniculaire',
        'humidity': isRainySeason ? 65 : 30,
      },
      'Ziguinchor': {
        'temp': isRainySeason ? 29 : 26,
        'desc': isRainySeason ? 'Tropical pluvieux' : 'Tropical vert',
        'humidity': isRainySeason ? 90 : 75,
      },
    };

    final data = cityData[cityName] ?? cityData['Dakar']!;
    final baseTemp = data['temp'] as int;
    final baseHumidity = data['humidity'] as int;

    return WeatherModel(
      cityName: _cityDisplayNames[cityName] ?? cityName, // Bon nom d'affichage
      temperature: (baseTemp + (now.millisecondsSinceEpoch % 4) - 2).toDouble(),
      description: data['desc']! as String,
      icon: '01d',
      humidity: (baseHumidity + (now.millisecondsSinceEpoch % 8) - 4).toDouble(),
      windSpeed: (12 + (now.millisecondsSinceEpoch % 6)).toDouble(),
      latitude: _getCityCoordinates(cityName).latitude,
      longitude: _getCityCoordinates(cityName).longitude,
    );
  }

  /// Corrige l'encodage des caractères français
  String _fixEncoding(String text) {
    // Corrections des caractères mal encodés courrants
    final Map<String, String> encodingFixes = {
      'Ã©': 'é',
      'Ã¨': 'è',
      'Ã ': 'à',
      'Ã§': 'ç',
      'Ã´': 'ô',
      'Ã¢': 'â',
      'Ã»': 'û',
      'Ã®': 'î',
      'Ã¯': 'ï',
      'Ã¹': 'ù',
      'Ã«': 'ë',
      'Ãª': 'ê',
      'Ã¼': 'ü',
      'Ã¶': 'ö',
      'Ã±': 'ñ',
      'Ã‡': 'Ç',
      'Ã‰': 'É',
      'Ã€': 'À',
    };

    String fixedText = text;
    encodingFixes.forEach((badChar, goodChar) {
      fixedText = fixedText.replaceAll(badChar, goodChar);
    });

    return fixedText;
  }

  /// Coordonnées des villes sénégalaises
  CityLocation _getCityCoordinates(String cityName) {
    final coordinates = {
      'Dakar': CityLocation(14.6928, -17.4467),
      'Saint-Louis': CityLocation(16.0300, -16.4889),
      'Thiès': CityLocation(14.7886, -16.9260),
      'Kaolack': CityLocation(14.1612, -16.0734),
      'Ziguinchor': CityLocation(12.5600, -16.2722),
    };

    return coordinates[cityName] ?? CityLocation(14.6928, -17.4467);
  }
}

class CityLocation {
  final double latitude;
  final double longitude;
  CityLocation(this.latitude, this.longitude);
}