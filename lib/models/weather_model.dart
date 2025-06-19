class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final double latitude;
  final double longitude;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Support pour les deux formats : OpenWeatherMap et WeatherAPI
    if (json.containsKey('location') && json.containsKey('current')) {
      // Format WeatherAPI.com
      final location = json['location'];
      final current = json['current'];

      return WeatherModel(
        cityName: location['name'] ?? '',
        temperature: (current['temp_c'] ?? 0).toDouble(),
        description: current['condition']['text'] ?? '',
        icon: _parseWeatherAPIIcon(current['condition']['icon'] ?? ''),
        humidity: (current['humidity'] ?? 0).toDouble(),
        windSpeed: (current['wind_kph'] ?? 0).toDouble() / 3.6, // kph -> m/s
        latitude: (location['lat'] ?? 0).toDouble(),
        longitude: (location['lon'] ?? 0).toDouble(),
      );
    } else {
      // Format OpenWeatherMap (fallback)
      return WeatherModel(
        cityName: json['name'] ?? '',
        temperature: (json['main']['temp'] ?? 0).toDouble(),
        description: json['weather'][0]['description'] ?? '',
        icon: json['weather'][0]['icon'] ?? '',
        humidity: (json['main']['humidity'] ?? 0).toDouble(),
        windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
        latitude: (json['coord']['lat'] ?? 0).toDouble(),
        longitude: (json['coord']['lon'] ?? 0).toDouble(),
      );
    }
  }

  // Parse les icônes WeatherAPI vers format standard
  static String _parseWeatherAPIIcon(String iconUrl) {
    final icon = iconUrl.toLowerCase();

    if (icon.contains('sun') || icon.contains('clear')) {
      return icon.contains('night') ? '01n' : '01d';
    } else if (icon.contains('partly') || icon.contains('cloudy')) {
      return icon.contains('night') ? '02n' : '02d';
    } else if (icon.contains('cloud') || icon.contains('overcast')) {
      return '03d';
    } else if (icon.contains('rain') || icon.contains('drizzle')) {
      return '10d';
    } else if (icon.contains('storm') || icon.contains('thunder')) {
      return '11d';
    } else if (icon.contains('snow')) {
      return '13d';
    } else if (icon.contains('mist') || icon.contains('fog')) {
      return '50d';
    }

    return '02d'; // Par défaut
  }

  @override
  String toString() {
    return 'WeatherModel(cityName: $cityName, temperature: $temperature°C, description: $description)';
  }
}