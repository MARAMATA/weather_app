# Changelog - Météo Sénégal

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet respecte le [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-19

### 🎉 Version initiale - Projet d'examen MDSIA/ISI 2025

#### ✨ Ajouté
- **Interface d'accueil** avec thème aux couleurs du Sénégal
- **Données météo en temps réel** via WeatherAPI.com pour 5 villes :
  - Dakar (Capitale)
  - Saint-Louis (Patrimoine UNESCO)
  - Thiès (Carrefour industriel)
  - Kaolack (Commerce arachidier)
  - Ziguinchor (Casamance)
- **Cartes interactives** avec OpenStreetMap (100% gratuit)
- **Thèmes clair/sombre** adaptatifs avec transitions fluides
- **Animations avancées** : jauge de progression, effets visuels
- **Informations culturelles** détaillées pour chaque ville
- **Géolocalisation précise** avec coordonnées GPS
- **Fallback intelligent** en cas d'indisponibilité API

#### 🛠️ Technique
- **Architecture MVC** propre et scalable
- **Gestion d'état** optimisée avec setState
- **API REST** avec gestion d'erreurs robuste
- **Cache intelligent** pour les données météo
- **Optimisation performances** pour mobile
- **Support multiplateforme** iOS/Android/Web

#### 🎨 Design
- **Material Design 3** avec personnalisations Sénégal
- **Typography** optimisée avec Google Fonts
- **Responsive design** pour toutes tailles d'écran
- **Accessibility** conforme aux standards WCAG
- **Dark mode** complet avec cartes adaptées

#### 📱 Fonctionnalités utilisateur
- Navigation intuitive entre les écrans
- Chargement en temps réel avec feedback visuel
- Informations météo complètes (température, humidité, vent, UV)
- Exploration interactive des cartes
- Toggle thème accessible depuis toutes les pages
- Partage d'informations météo

#### 🔧 Configuration
- Variables d'environnement pour API keys
- Configuration CI/CD prête
- Scripts de build automatisés
- Documentation développeur complète

---

## [Unreleased] - Fonctionnalités futures

### 🚀 Prévisions
- **Notifications push** pour alertes météo
- **Widget home screen** Android/iOS
- **Mode hors ligne** avec cache étendu
- **Prévisions 7 jours** avec graphiques
- **Géolocalisation automatique** utilisateur
- **Partage social** intégré
- **Support PWA** pour installation web

### 🌍 Extensions
- **Plus de villes** africaines
- **Données satellite** météorologie
- **Indices de qualité de l'air**
- **Alertes météo** gouvernementales
- **Intégration calendrier** agricole sénégalais

---

## Types de changements

- **✨ Ajouté** : pour les nouvelles fonctionnalités
- **🔄 Modifié** : pour les changements de fonctionnalités existantes  
- **❌ Supprimé** : pour les fonctionnalités supprimées
- **🐛 Corrigé** : pour les corrections de bugs
- **🔒 Sécurité** : pour les vulnérabilités corrigées
- **⚡ Performance** : pour les améliorations de performance
- **📝 Documentation** : pour les changements de documentation
