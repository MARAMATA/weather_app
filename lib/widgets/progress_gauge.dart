import 'package:flutter/material.dart';

class ProgressGauge extends StatefulWidget {
  final double progress;
  final bool? isDarkMode;

  const ProgressGauge({
    Key? key,
    required this.progress,
    this.isDarkMode,
  }) : super(key: key);

  @override
  _ProgressGaugeState createState() => _ProgressGaugeState();
}

class _ProgressGaugeState extends State<ProgressGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
      _animation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode ?? (theme.brightness == Brightness.dark);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cercle de fond avec ombre
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),

              // Indicateur de progression principal
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 8,
                  backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(_animation.value, isDark),
                  ),
                ),
              ),

              // Indicateur de progression secondaire (effet de glow)
              SizedBox(
                width: 170,
                height: 170,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(_animation.value, isDark).withOpacity(0.5),
                  ),
                ),
              ),

              // Contenu au centre
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône animée
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300),
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    builder: (context, double scale, child) {
                      return Transform.scale(
                        scale: scale + (0.1 * _animation.value),
                        child: Icon(
                          _getProgressIcon(_animation.value),
                          size: 40,
                          color: _getProgressColor(_animation.value, isDark),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 8),

                  // Pourcentage
                  Text(
                    '${(_animation.value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(_animation.value, isDark),
                    ),
                  ),

                  SizedBox(height: 4),

                  // Texte de statut
                  Text(
                    _getStatusText(_animation.value),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Particules d'animation (effet bonus)
              if (_animation.value > 0.8)
                ..._buildParticles(isDark),
            ],
          ),
        );
      },
    );
  }

  Color _getProgressColor(double progress, bool isDark) {
    if (progress < 0.3) {
      return isDark ? Colors.orange.shade400 : Colors.orange;
    } else if (progress < 0.7) {
      return isDark ? Colors.blue.shade400 : Colors.blue;
    } else if (progress < 1.0) {
      return isDark ? Colors.green.shade400 : Colors.green;
    } else {
      return isDark ? Colors.green.shade300 : Colors.green.shade600;
    }
  }

  IconData _getProgressIcon(double progress) {
    if (progress < 0.2) {
      return Icons.cloud_download;
    } else if (progress < 0.5) {
      return Icons.sync;
    } else if (progress < 0.8) {
      return Icons.trending_up;
    } else if (progress < 1.0) {
      return Icons.check_circle_outline;
    } else {
      return Icons.check_circle;
    }
  }

  String _getStatusText(double progress) {
    if (progress < 0.2) {
      return 'Initialisation...';
    } else if (progress < 0.5) {
      return 'Récupération...';
    } else if (progress < 0.8) {
      return 'Traitement...';
    } else if (progress < 1.0) {
      return 'Finalisation...';
    } else {
      return 'Terminé !';
    }
  }

  List<Widget> _buildParticles(bool isDark) {
    return List.generate(6, (index) {
      return Positioned(
        left: 100 + (50 * (index % 2 == 0 ? 1 : -1)),
        top: 100 + (50 * (index % 3 == 0 ? 1 : -1)),
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 1000),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.green.shade400 : Colors.green).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}