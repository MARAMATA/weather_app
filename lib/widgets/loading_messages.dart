import 'package:flutter/material.dart';
import 'dart:async';

class LoadingMessages extends StatefulWidget {
  final bool? isDarkMode;

  const LoadingMessages({Key? key, this.isDarkMode}) : super(key: key);

  @override
  _LoadingMessagesState createState() => _LoadingMessagesState();
}

class _LoadingMessagesState extends State<LoadingMessages>
    with SingleTickerProviderStateMixin {
  final List<String> messages = [
    '📡 Nous téléchargeons les données…',
    '⏳ C\'est presque fini…',
    '🎯 Plus que quelques secondes avant d\'avoir le résultat…',
    '🌤️ Récupération des données météo…',
    '🔄 Traitement en cours…',
    '📊 Analyse des informations…',
    '🌍 Géolocalisation des villes…',
    '☁️ Synchronisation des données…'
  ];

  int currentIndex = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Configuration des animations
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Démarrer la première animation
    _animationController.forward();

    // Timer pour changer les messages
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() {
              currentIndex = (currentIndex + 1) % messages.length;
            });
            _animationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode ?? (theme.brightness == Brightness.dark);

    return Container(
      height: 70, // Augmenté de 80 à 70
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Réduit le padding
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade800.withOpacity(0.9)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16), // Réduit de 20 à 16
                  border: Border.all(
                    color: isDark
                        ? Colors.blue.shade600.withOpacity(0.5)
                        : Colors.blue.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Message principal
                    Flexible( // Ajout de Flexible pour éviter l'overflow
                      child: Text(
                        messages[currentIndex],
                        style: TextStyle(
                          fontSize: 14, // Réduit de 16 à 14
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2, // Limite à 2 lignes
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 6), // Réduit de 8 à 6

                    // Indicateur de progression en points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          width: 5, // Réduit de 6 à 5
                          height: 5,
                          decoration: BoxDecoration(
                            color: _getLoadingDotColor(index, isDark),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getLoadingDotColor(int index, bool isDark) {
    // Animation des points de chargement
    int animationIndex = (DateTime.now().millisecondsSinceEpoch ~/ 300) % 3;
    if (index == animationIndex) {
      return isDark ? Colors.blue.shade400 : Colors.blue.shade600;
    } else if (index == (animationIndex - 1) % 3) {
      return isDark ? Colors.blue.shade600 : Colors.blue.shade400;
    } else {
      return isDark ? Colors.grey.shade600 : Colors.grey.shade300;
    }
  }
}