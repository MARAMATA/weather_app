import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class CityDetailScreen extends StatefulWidget {
  final Map<String, dynamic> cityData;
  final VoidCallback? toggleTheme;
  final bool isDarkMode;

  const CityDetailScreen({
    Key? key,
    required this.cityData,
    this.toggleTheme,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _mapAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final MapController _mapController = MapController();
  bool isMapLoaded = false;
  bool showAllDetails = true; // Afficher tous les détails par défaut

  // Coordonnées des villes sénégalaises 🇸🇳
  final Map<String, LatLng> cityCoordinates = {
    'Dakar': LatLng(14.6928, -17.4467),
    'Saint-Louis': LatLng(16.0300, -16.4889),
    'Thiès': LatLng(14.7886, -16.9260),
    'Kaolack': LatLng(14.1612, -16.0734),
    'Ziguinchor': LatLng(12.5600, -16.2722),
  };

  // Informations détaillées sur les villes sénégalaises
  final Map<String, Map<String, dynamic>> cityInfo = {
    'Dakar': {
      'region': 'Région de Dakar',
      'population': '1.1M habitants',
      'description': 'Capitale économique et politique du Sénégal',
      'specialite': 'Port autonome • Plateau • Médina • Île de Gorée',
      'altitude': '22m',
      'climat': 'Tropical semi-aride avec alizés',
      'patrimoine': '🏛️ Palais présidentiel • 🏝️ Île de Gorée (UNESCO) • 🕌 Grande Mosquée',
    },
    'Saint-Louis': {
      'region': 'Région de Saint-Louis',
      'population': '300K habitants',
      'description': 'Ancienne capitale de l\'AOF, patrimoine UNESCO',
      'specialite': 'Architecture coloniale • Festival de Jazz • Pont Faidherbe',
      'altitude': '4m',
      'climat': 'Sahélien sec',
      'patrimoine': '🎷 Festival de Jazz • 🌉 Pont Faidherbe • 🏘️ Centre historique (UNESCO)',
    },
    'Thiès': {
      'region': 'Région de Thiès',
      'population': '400K habitants',
      'description': 'Important carrefour ferroviaire et centre industriel',
      'specialite': 'Gare ferroviaire • Industries textiles • École normale',
      'altitude': '70m',
      'climat': 'Sahélien doux',
      'patrimoine': '🚂 Gare historique • 🎨 Manufacture de tapisseries • 🎓 Université',
    },
    'Kaolack': {
      'region': 'Région de Kaolack',
      'population': '250K habitants',
      'description': 'Centre commercial majeur sur le Saloum',
      'specialite': 'Marché central • Commerce arachide • Port fluvial',
      'altitude': '8m',
      'climat': 'Sahélien continental',
      'patrimoine': '🥜 Marché à l\'arachide • 🕌 Médina Baye • 🚢 Port sur le Saloum',
    },
    'Ziguinchor': {
      'region': 'Région de Ziguinchor',
      'population': '200K habitants',
      'description': 'Capitale de la Casamance, région tropicale',
      'specialite': 'Culture Diola • Fromagers géants • Tourisme vert',
      'altitude': '26m',
      'climat': 'Tropical humide (mousson)',
      'patrimoine': '🌳 Forêt de Casamance • 🏡 Architecture Diola • 🎭 Festivals culturels',
    },
  };

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _mapAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mapAnimationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          isMapLoaded = true;
        });
        _mapAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cityName = widget.cityData['city'];
    final cityLocation = cityCoordinates[cityName] ?? LatLng(14.6928, -17.4467);

    return Scaffold(
      appBar: AppBar(
        title: Text('🇸🇳 $cityName'),
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showCityInfo(context, isDark),
            tooltip: 'Informations détaillées',
          ),
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: isDark ? 'Mode clair' : 'Mode sombre',
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('📤 Partage de $cityName, Sénégal 🇸🇳'),
                  backgroundColor: isDark ? Colors.grey.shade700 : Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Partager',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Section informations météo avec indicateur de contenu
                  Expanded(
                    flex: showAllDetails ? 3 : 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [Colors.grey.shade800, Colors.grey.shade900]
                              : [Colors.orange.shade100, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header avec température principale et bouton d'expansion
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Température et météo principale
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getWeatherIcon(widget.cityData['desc']),
                                        size: 50,
                                        color: isDark ? Colors.orange.shade400 : Colors.orange.shade600,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.cityData['temp']}°C',
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            widget.cityData['desc'].toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Aperçu rapide des autres données
                                Column(
                                  children: [
                                    _buildQuickInfoCard('💧', '${widget.cityData['humidity']}%', isDark),
                                    SizedBox(height: 8),
                                    _buildQuickInfoCard('🌬️', '${_getRandomWind()} km/h', isDark),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Bouton pour afficher/masquer les détails
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  showAllDetails = !showAllDetails;
                                });
                              },
                              icon: Icon(
                                showAllDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 20,
                              ),
                              label: Text(
                                showAllDetails ? 'Masquer les détails' : 'Voir tous les détails météo',
                                style: TextStyle(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                foregroundColor: isDark ? Colors.white : Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),

                          // Détails météo (conditionnels)
                          if (showAllDetails) ...[
                            SizedBox(height: 16),
                            Expanded(
                              child: _buildWeatherDetails(isDark),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Section OpenStreetMap
                  Expanded(
                    flex: showAllDetails ? 2 : 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.4 : 0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // FlutterMap avec OpenStreetMap
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                center: cityLocation,
                                zoom: 12.0,
                                maxZoom: 18.0,
                                minZoom: 8.0,
                                onMapReady: () {
                                  print('🗺️ Carte OpenStreetMap chargée !');
                                },
                                onTap: (tapPosition, point) {
                                  print('📍 Carte touchée: ${point.latitude}, ${point.longitude}');
                                  _showMapTapInfo(point, isDark);
                                },
                              ),
                              children: [
                                // Couche de tuiles OpenStreetMap
                                TileLayer(
                                  urlTemplate: isDark
                                      ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
                                      : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.weather_app',
                                  maxZoom: 19,
                                  subdomains: const ['a', 'b', 'c', 'd'],
                                ),

                                // Marqueurs des villes
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: cityLocation,
                                      width: 80,
                                      height: 80,
                                      child: GestureDetector(
                                        onTap: () => _showMarkerDetails(isDark),
                                        child: AnimatedBuilder(
                                          animation: _scaleAnimation,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: _scaleAnimation.value,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isDark ? Colors.blue.shade700 : Colors.green.shade600,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 8,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 3,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.location_city,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                    Text(
                                                      '${widget.cityData['temp']}°',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Attribution OpenStreetMap
                                RichAttributionWidget(
                                  attributions: [
                                    TextSourceAttribution(
                                      '© OpenStreetMap contributors',
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('🗺️ Cartes libres et gratuites !'),
                                            backgroundColor: isDark ? Colors.blue.shade700 : Colors.green,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Overlay d'informations ville
                            Positioned(
                              top: 16,
                              right: 16,
                              child: AnimatedBuilder(
                                animation: _scaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.blue.shade700 : Colors.green.shade600,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.map, color: Colors.white, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '$cityName 🇸🇳',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Badge "GRATUIT"
                            Positioned(
                              top: 16,
                              left: 16,
                              child: AnimatedBuilder(
                                animation: _scaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade600,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '🆓 GRATUIT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Indicateur de chargement
                            if (!isMapLoaded)
                              Container(
                                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          isDark ? Colors.blue.shade400 : Colors.green.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '🗺️ Chargement OpenStreetMap...',
                                        style: TextStyle(
                                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '100% Gratuit !',
                                        style: TextStyle(
                                          color: isDark ? Colors.green.shade400 : Colors.green.shade600,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Boutons d'action
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      boxShadow: isDark ? null : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showCityInfo(context, isDark),
                            icon: Icon(Icons.info),
                            label: Text('Infos Ville'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _centerOnCity(cityLocation),
                            icon: Icon(Icons.my_location),
                            label: Text('Centrer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.blue.shade700 : Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickInfoCard(String emoji, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 12)),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _centerOnCity(LatLng location) {
    _mapController.move(location, 14.0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📍 Centré sur ${widget.cityData['city']}'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: widget.isDarkMode ? Colors.blue.shade700 : Colors.green.shade600,
      ),
    );
  }

  void _showMapTapInfo(LatLng point, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
        title: Text(
          '📍 Position sur la carte',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Latitude: ${point.latitude.toStringAsFixed(4)}°\n'
              'Longitude: ${point.longitude.toStringAsFixed(4)}°\n\n'
              '🗺️ Cartes OpenStreetMap gratuites !',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: isDark ? Colors.blue.shade400 : Colors.green.shade600),
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkerDetails(bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📍 ${widget.cityData['city']} - ${widget.cityData['temp']}°C'),
        backgroundColor: isDark ? Colors.blue.shade700 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildWeatherDetails(bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Titre des détails météo
          Text(
            '🌡️ Détails Météorologiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.orange.shade400 : Colors.orange.shade800,
            ),
          ),

          SizedBox(height: 16),

          // Grille avec les détails
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildDetailCard(
                icon: Icons.opacity,
                title: 'Humidité',
                value: '${widget.cityData['humidity']}%',
                color: Colors.blue,
                subtitle: _getHumidityStatus(widget.cityData['humidity']),
                isDark: isDark,
              ),
              _buildDetailCard(
                icon: Icons.air,
                title: 'Alizés',
                value: '${_getRandomWind()} km/h',
                color: Colors.green,
                subtitle: 'Vents dominants',
                isDark: isDark,
              ),
              _buildDetailCard(
                icon: Icons.wb_sunny,
                title: 'Index UV',
                value: '${_getRandomUV()}',
                color: Colors.orange,
                subtitle: _getUVStatus(_getRandomUV()),
                isDark: isDark,
              ),
              _buildDetailCard(
                icon: Icons.thermostat,
                title: 'Ressenti',
                value: '${_getFeelsLike()}°C',
                color: Colors.red,
                subtitle: 'Température perçue',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    String? subtitle,
    required bool isDark,
  }) {
    return Card(
      elevation: 6,
      color: isDark ? Colors.grey.shade800 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isDark
                ? [color.withOpacity(0.2), Colors.grey.shade800]
                : [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    description = description.toLowerCase();
    if (description.contains('soleil') || description.contains('clair') || description.contains('ensoleillé')) {
      return Icons.wb_sunny;
    } else if (description.contains('nuage')) {
      return Icons.cloud;
    } else if (description.contains('pluie') || description.contains('humide')) {
      return Icons.grain;
    } else if (description.contains('chaud') || description.contains('sec')) {
      return Icons.wb_sunny_outlined;
    } else {
      return Icons.wb_cloudy;
    }
  }

  String _getRandomWind() => (10 + (widget.cityData['humidity'] % 15)).toString();
  int _getRandomUV() => (8 + (widget.cityData['temp'] % 4)).toInt();
  int _getFeelsLike() => (widget.cityData['temp'] + 2 + (widget.cityData['humidity'] % 5));

  String _getHumidityStatus(int humidity) {
    if (humidity > 80) return 'Très humide';
    if (humidity > 60) return 'Humide';
    if (humidity > 40) return 'Modéré';
    return 'Sec';
  }

  String _getUVStatus(int uv) {
    if (uv > 8) return 'Très fort';
    if (uv > 6) return 'Fort';
    if (uv > 3) return 'Modéré';
    return 'Faible';
  }

  void _showCityInfo(BuildContext context, bool isDark) {
    final cityName = widget.cityData['city'];
    final info = cityInfo[cityName];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '🏙️ $cityName, Sénégal 🇸🇳',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('📍 Région:', info?['region'] ?? 'N/A', isDark),
                    _buildInfoRow('👥 Population:', info?['population'] ?? 'N/A', isDark),
                    _buildInfoRow('⛰️ Altitude:', info?['altitude'] ?? 'N/A', isDark),
                    _buildInfoRow('🌤️ Climat:', info?['climat'] ?? 'N/A', isDark),
                    _buildInfoRow('📝 Description:', info?['description'] ?? 'N/A', isDark),
                    _buildInfoRow('⭐ Spécialités:', info?['specialite'] ?? 'N/A', isDark),
                    _buildInfoRow('🏛️ Patrimoine:', info?['patrimoine'] ?? 'N/A', isDark),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                label: Text('Fermer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.blue.shade700 : Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.orange.shade400 : Colors.orange.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}