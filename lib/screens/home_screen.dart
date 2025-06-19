import 'package:flutter/material.dart';
import 'main_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    this.toggleTheme,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey.shade800, Colors.grey.shade900]
                : [Colors.blue.shade400, Colors.purple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton toggle thème en haut à droite
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: toggleTheme,
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  Spacer(),

                  // Logo principal avec animation
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Titre d'accueil
                  Text(
                    '🇸🇳 Météo Sénégal ! 🌴',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  // Sous-titre avec référence au logo
                  Text(
                    'Du Sahel aux côtes atlantiques\nDécouvrez la météo en temps réel\npour 5 grandes villes du Sénégal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 60),

                  // Bouton magique avec icône du logo
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(
                            toggleTheme: toggleTheme,
                            isDarkMode: isDarkMode,
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: animation.drive(
                                Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.easeInOut)),
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Mini logo dans le bouton
                        Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Commencer l\'expérience',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Footer avec votre nom et design credit
                  Column(
                    children: [
                      Text(
                        '🎓 Projet d\'examen MDSIA/ISI 2025\n👨‍💻 Maramata DIOP',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '🎨 Design by SIRIUS • Made with ❤️ in Senegal',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}