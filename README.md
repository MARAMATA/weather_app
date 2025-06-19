# 🇸🇳 Météo Sénégal - Application Flutter

> **Application météo professionnelle développée pour l'examen MDSIA/ISI 2025**  
> *Créée par Maramata DIOP*

## 📱 Aperçu

Une application météo moderne et élégante qui affiche les conditions météorologiques en temps réel pour 5 grandes villes du Sénégal : **Dakar**, **Saint-Louis**, **Thiès**, **Kaolack** et **Ziguinchor**.

### ✨ Fonctionnalités principales

- 🌤️ **Données météo en temps réel** via l'API WeatherAPI
- 🗺️ **Cartes interactives** avec OpenStreetMap (100% gratuit)
- 🌙 **Thèmes clair et sombre** adaptatifs
- 📍 **Géolocalisation** des villes sénégalaises
- 🎨 **Interface moderne** avec animations fluides
- 📊 **Informations détaillées** : température, humidité, vent, UV
- 🏛️ **Données culturelles** sur chaque ville

## 🖼️ Captures d'écran

| Écran d'accueil | Liste des villes | Détails d'une ville |
|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Cities](screenshots/cities.png) | ![Details](screenshots/details.png) |

## 🛠️ Technologies utilisées

### Frontend
- **Flutter** 3.1.0+ - Framework UI multiplateforme
- **Dart** - Langage de programmation

### APIs & Services
- **WeatherAPI.com** - Données météorologiques
- **OpenStreetMap** - Cartes interactives
- **HTTP** - Requêtes API

### Packages Flutter
```yaml
dependencies:
  flutter_map: ^6.1.0           # Cartes interactives
  latlong2: ^0.9.1              # Coordonnées géographiques
  http: ^1.1.0                  # Appels API
  flutter_spinkit: ^5.2.0       # Animations de chargement
  google_fonts: ^6.2.1          # Polices modernes
  shared_preferences: ^2.2.2    # Stockage local
  flutter_dotenv: ^5.1.0        # Variables d'environnement
  intl: ^0.19.0                 # Formatage français
  logger: ^2.2.0                # Logs colorés
  url_launcher: ^6.2.5          # Liens externes

dev_dependencies:
  flutter_launcher_icons: ^0.13.1  # Génération d'icônes
```

## 🚀 Installation

### Prérequis
- Flutter SDK 3.1.0 ou plus récent
- Android Studio / VS Code
- Git

### Étapes d'installation

1. **Clonez le repository**
```bash
git clone https://github.com/votre-username/weather-senegal-app.git
cd weather-senegal-app
```

2. **Installez les dépendances**
```bash
flutter pub get
```

3. **Configurez l'API WeatherAPI** (optionnel)
```bash
# Créez un fichier .env à la racine
echo "WEATHER_API_KEY=votre_cle_api" > .env
```

4. **Générez les icônes d'application**
```bash
flutter pub run flutter_launcher_icons:main
```

5. **Lancez l'application**
```bash
flutter run
```

## 📁 Structure du projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/
│   └── weather_model.dart    # Modèle de données météo
├── services/
│   └── weather_service.dart  # Service API météo
├── screens/
│   ├── home_screen.dart      # Écran d'accueil
│   ├── main_screen.dart      # Liste des villes
│   └── city_detail_screen.dart # Détails d'une ville
└── widgets/
    ├── progress_gauge.dart   # Jauge de progression
    ├── loading_messages.dart # Messages de chargement
    └── app_logo.dart         # Widget logo réutilisable

assets/
├── images/
│   └── logo.png             # Logo de l'application
└── icons/                   # Icônes personnalisées
```

## 🌍 Villes supportées

| Ville | Région | Population | Spécialités |
|-------|--------|------------|-------------|
| **Dakar** | Dakar | 1.1M hab. | Capitale, Île de Gorée (UNESCO) |
| **Saint-Louis** | Saint-Louis | 300K hab. | Jazz Festival, Pont Faidherbe |
| **Thiès** | Thiès | 400K hab. | Carrefour ferroviaire, Industries |
| **Kaolack** | Kaolack | 250K hab. | Commerce arachide, Port Saloum |
| **Ziguinchor** | Ziguinchor | 200K hab. | Casamance, Culture Diola |

## 🎨 Fonctionnalités détaillées

### Météo en temps réel
- Température actuelle et ressentie
- Conditions météorologiques (ensoleillé, nuageux, etc.)
- Taux d'humidité et vitesse du vent
- Index UV et prévisions

### Interface utilisateur
- **Thème adaptatif** : Mode clair/sombre automatique
- **Animations fluides** : Transitions et effets visuels
- **Design responsive** : S'adapte à toutes les tailles d'écran
- **Navigation intuitive** : UX optimisée

### Cartes interactives
- **OpenStreetMap** intégré (gratuit et open source)
- **Marqueurs personnalisés** avec températures
- **Zoom et navigation** fluides
- **Mode sombre** pour les cartes

## 🔧 Configuration avancée

### Variables d'environnement
Créez un fichier `.env` :
```env
WEATHER_API_KEY=votre_cle_weatherapi
DEBUG_MODE=true
```

### Personnalisation des thèmes
Les thèmes sont définis dans `main.dart` :
```dart
// Thème clair
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  // ...
);

// Thème sombre  
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  // ...
);
```

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration  
flutter test integration_test/

# Analyse du code
flutter analyze
```

## 📦 Build de production

### Android
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/AmazingFeature`)
3. Commitez vos changements (`git commit -m 'Add: Amazing Feature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👨‍💻 Auteur

**Maramata DIOP**
- 🎓 Étudiant MDSIA/ISI 2025
- 📍 Dakar, Sénégal
- 📧 Email: maramatad@gmail.com
- 🔗 LinkedIn: https://www.linkedin.com/in/maramata-diop/

## 🙏 Remerciements

- **WeatherAPI.com** pour les données météorologiques
- **OpenStreetMap** pour les cartes gratuites
- **Flutter Team** pour ce framework exceptionnel
- **Communauté sénégalaise** des développeurs

## 🔗 Liens utiles

- [Documentation Flutter](https://docs.flutter.dev/)
- [WeatherAPI Documentation](https://www.weatherapi.com/docs/)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Pub.dev](https://pub.dev/)

---

**Made with ❤️ in Senegal 🇸🇳**
