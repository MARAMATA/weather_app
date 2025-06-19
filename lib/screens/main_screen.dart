import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/progress_gauge.dart';
import '../widgets/loading_messages.dart';
import 'city_detail_screen.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback? toggleTheme;
  final bool isDarkMode;

  const MainScreen({
    Key? key,
    this.toggleTheme,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<String> cities = ['Dakar', 'Saint-Louis', 'Thiès', 'Kaolack', 'Ziguinchor'];

  List<WeatherModel> weatherData = [];
  double progress = 0.0;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Timer? _apiTimer;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startWeatherFetching();
  }

  @override
  void dispose() {
    _apiTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startWeatherFetching() {
    setState(() {
      isLoading = true;
      hasError = false;
      weatherData.clear();
      progress = 0.0;
    });

    int cityIndex = 0;

    _apiTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (cityIndex < cities.length) {
        try {
          print('🌐 Appel API WeatherAPI pour ${cities[cityIndex]}...');
          final weather = await _weatherService.getWeatherForCity(cities[cityIndex]);

          if (mounted) {
            setState(() {
              weatherData.add(weather);
              print('✅ Météo reçue: ${weather.cityName} - ${weather.temperature}°C');
            });
          }
          cityIndex++;
        } catch (e) {
          print('❌ Erreur API pour ${cities[cityIndex]}: $e');
          if (mounted) {
            setState(() {
              hasError = true;
              errorMessage = 'Erreur lors du chargement de ${cities[cityIndex]}:\n${e.toString()}';
            });
          }
          timer.cancel();
          return;
        }
      } else {
        timer.cancel();
      }
    });

    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          if (progress < 1.0) {
            progress += 0.007;
          } else {
            timer.cancel();
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.wb_sunny,
                        color: Colors.white,
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
            ),
            Text(
              '🌤️ Météo en temps réel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: isDark ? 'Mode clair' : 'Mode sombre',
          ),
        ],
        elevation: 4,
        shadowColor: theme.primaryColor.withOpacity(0.3),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.grey.shade800, Colors.grey.shade900]
                  : [theme.primaryColor, theme.primaryColorDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.black]
                : [theme.primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading ? _buildLoadingView(isDark) : _buildWeatherView(isDark),
      ),
    );
  }

  Widget _buildLoadingView(bool isDark) {
    if (hasError) {
      return _buildErrorView(isDark);
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'loading_logo',
              child: Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.blue.shade300 : Colors.blue)
                          .withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            ProgressGauge(progress: progress, isDarkMode: isDark),
            SizedBox(height: 40),
            LoadingMessages(isDarkMode: isDark),
            SizedBox(height: 20),
            Text(
              'Chargement: ${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 30),
            if (weatherData.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade800.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Données API temps réel:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.blue.shade300 : Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    ...weatherData.map((weather) => Text(
                      '✅ ${weather.cityName} - ${weather.temperature.toInt()}°C - ${weather.description}',
                      style: TextStyle(
                        color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                        fontSize: 12,
                      ),
                    )).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.red.withOpacity(0.3),
                    BlendMode.color,
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.red.shade800 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Oups ! Une erreur est survenue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startWeatherFetching,
              child: Text('🔄 Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.blue.shade700 : Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherView(bool isDark) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.green.shade800 : Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.green.shade600 : Colors.green,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.check_circle,
                        color: isDark ? Colors.green.shade400 : Colors.green,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '💥 BOOM ! Données météo chargées avec succès !',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.green.shade200 : Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: weatherData.length,
            itemBuilder: (context, index) {
              final weather = weatherData[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                color: isDark ? Colors.grey.shade800 : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityDetailScreen(
                          cityData: {
                            'city': weather.cityName,
                            'temp': weather.temperature.toInt(),
                            'desc': weather.description,
                            'humidity': weather.humidity.toInt(),
                            'wind': weather.windSpeed,
                            'lat': weather.latitude,
                            'lng': weather.longitude,
                          },
                          toggleTheme: widget.toggleTheme,
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.grey.shade800, Colors.grey.shade700]
                            : [Colors.blue.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.blue.shade800
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                _getWeatherIcon(weather.description),
                                size: 30,
                                color: isDark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade600,
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'API',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                weather.cityName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.blue.shade300
                                      : Colors.blue.shade800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                weather.description.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.thermostat, size: 16, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text(
                                    '${weather.temperature.toInt()}°C',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(Icons.opacity, size: 16, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text(
                                    '${weather.humidity.toInt()}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _startWeatherFetching,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.refresh, size: 20);
                      },
                    ),
                  ),
                ),
                Text(
                  '🔁 Recommencer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String description) {
    description = description.toLowerCase();
    if (description.contains('soleil') || description.contains('clair') || description.contains('ensoleillé')) {
      return Icons.wb_sunny;
    } else if (description.contains('nuage')) {
      return Icons.cloud;
    } else if (description.contains('pluie')) {
      return Icons.grain;
    } else {
      return Icons.wb_cloudy;
    }
  }
}