# LinkedIn ou Interpol

Application mobile de jeu "swipe" où l'utilisateur devine si une photo de profil appartient à un profil LinkedIn professionnel ou à un criminel recherché par Interpol.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

## 📋 Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Structure du projet](#-structure-du-projet)
- [Principes SOLID](#-principes-solid)
- [Tests](#-tests)
- [API Backend](#-api-backend)
- [Contribution](#-contribution)

## ✨ Fonctionnalités

### MVP (Version actuelle)
- ✅ Système de swipe gauche/droite ou boutons pour répondre
- ✅ Score et série (streak) en temps réel
- ✅ Barre de progression
- ✅ Vibrations haptiques sur succès/erreur
- ✅ Confettis sur bon score (>70%)
- ✅ Statistiques persistantes (meilleur score, taux de réussite)
- ✅ 3 niveaux de difficulté (10/20/30 photos)
- ✅ Paramètres personnalisables (son, vibration)

### Fonctionnalités futures
- 🔲 Intégration API backend pour données dynamiques
- 🔲 Système de sons
- 🔲 Partage de score sur réseaux sociaux
- 🔲 Mode timer/challenge
- 🔲 Leaderboard en ligne

## 🏗️ Architecture

Le projet suit les **principes SOLID** et utilise une architecture en couches :

```
lib/
├── interfaces/           # Abstractions (Dependency Inversion)
│   ├── i_data_service.dart
│   ├── i_storage_service.dart
│   ├── i_profile_repository.dart
│   └── i_statistics_repository.dart
├── models/              # Modèles de données
│   ├── profile.dart
│   ├── game_session.dart
│   └── user_statistics.dart
├── providers/           # State Management (Provider)
│   ├── game_provider.dart
│   ├── settings_provider.dart
│   └── statistics_provider.dart
├── repositories/        # Repository Pattern
│   ├── profile_repository.dart
│   └── statistics_repository.dart
├── services/            # Services concrets
│   ├── data_service.dart
│   └── storage_service.dart
├── screens/             # UI Screens
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── result_screen.dart
│   ├── statistics_screen.dart
│   └── settings_screen.dart
├── widgets/             # Composants réutilisables
│   └── profile_card.dart
└── utils/               # Constantes et utilitaires
    └── constants.dart
```

### Patterns utilisés
- **Repository Pattern** : Abstraction de l'accès aux données
- **Dependency Injection** : Injection des dépendances via constructeurs
- **Provider Pattern** : Gestion d'état réactive
- **Singleton Pattern** : Services (DataService, StorageService)

## 🎯 Principes SOLID

### S - Single Responsibility Principle ✅
Chaque classe a une seule responsabilité :
- `GameProvider` : Logique du jeu uniquement
- `StatisticsProvider` : Gestion des statistiques uniquement
- `SettingsProvider` : Gestion des paramètres uniquement

### O - Open/Closed Principle ✅
Les interfaces permettent l'extension sans modification :
- Facile d'ajouter une nouvelle source de données (API) en implémentant `IDataService`
- Facile de changer le système de stockage en implémentant `IStorageService`

### L - Liskov Substitution Principle ✅
Les implémentations peuvent être substituées sans casser le code :
- `DataService` peut être remplacé par `ApiDataService`
- `StorageService` peut être remplacé par `SecureStorageService`

### I - Interface Segregation Principle ✅
Interfaces spécifiques et ciblées :
- `IProfileRepository` : Uniquement opérations sur les profils
- `IStatisticsRepository` : Uniquement opérations sur les stats

### D - Dependency Inversion Principle ✅
Les dépendances pointent vers des abstractions :
```dart
class GameProvider {
  final IProfileRepository _profileRepository;  // ✅ Interface
  final StatisticsProvider _statisticsProvider; // ✅ Abstraction
  
  GameProvider(this._profileRepository, this._statisticsProvider);
}
```

## 📦 Prérequis

- **Flutter SDK** : 3.10.0 ou supérieur
- **Dart SDK** : 3.0.0 ou supérieur
- **Android Studio** / **Xcode** (pour émulateurs)
- **VS Code** (recommandé) avec extensions Flutter/Dart

## 🚀 Installation

### 1. Cloner le repository
```bash
git clone https://github.com/Nicolas-Delahaie/ynov-cross-plateform.git
cd ynov-cross-plateform
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Lancer l'application

**Sur Android :**
```bash
flutter run -d android
```

**Sur iOS :**
```bash
flutter run -d ios
```

**Sur Web :**
```bash
flutter run -d chrome
```

**Sur Windows (nécessite le mode développeur activé) :**
```bash
# Activer le mode développeur Windows
start ms-settings:developers

# Puis lancer
flutter run -d windows
```

## 📁 Structure du projet

### Dépendances principales

```yaml
dependencies:
  provider: ^6.1.0              # State management
  shared_preferences: ^2.2.0    # Stockage local
  hive: ^2.2.3                  # Base de données locale
  flutter_card_swiper: ^6.0.0   # Swipe UI
  vibration: ^1.8.0             # Retour haptique
  confetti: ^0.7.0              # Animations
  http: ^1.1.0                  # Requêtes HTTP (API future)
```

### Assets

Les données de profils sont actuellement stockées dans `assets/data/profiles.json` (35 profils de test).

**⚠️ Important :** Ces données seront remplacées par l'API backend une fois intégrée.

## 🧪 Tests

### Lancer les tests
```bash
flutter test
```

### Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🌐 API Backend

### Intégration prévue

Le projet est prêt pour l'intégration d'une API REST. Voir [API_CONTRACT.md](./API_CONTRACT.md) pour :
- Format des endpoints
- Modèles de données
- Exemples de requêtes/réponses
- Codes d'erreur

### Migration de local vers API

Pour basculer vers l'API :
1. Créer `ApiDataService implements IDataService`
2. Remplacer `DataService()` par `ApiDataService()` dans `main.dart`
3. Aucune modification du reste du code nécessaire (grâce à SOLID)

Exemple :
```dart
// main.dart
final IDataService dataService = ApiDataService(baseUrl: 'https://api.example.com');
```

## 🤝 Contribution

### Workflow Git

1. Créer une branche feature
```bash
git checkout -b feature/nom-feature
```

2. Commit avec messages clairs
```bash
git commit -m "feat: ajout de [fonctionnalité]"
```

3. Push et créer une Pull Request
```bash
git push origin feature/nom-feature
```

### Conventions de code

- Suivre les [Dart style guidelines](https://dart.dev/guides/language/effective-dart/style)
- Commenter les interfaces et méthodes publiques
- Écrire des tests pour les nouvelles fonctionnalités
- Respecter les principes SOLID

### Messages de commit

Format : `type(scope): message`

Types :
- `feat` : Nouvelle fonctionnalité
- `fix` : Correction de bug
- `docs` : Documentation
- `style` : Formatage
- `refactor` : Refactoring
- `test` : Tests
- `chore` : Maintenance

Exemples :
```bash
git commit -m "feat(game): ajout du mode timer"
git commit -m "fix(storage): correction sauvegarde stats"
git commit -m "docs(readme): mise à jour installation"
```

## 📝 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Auteurs

- **Frontend** : [Nicolas Delahaie](https://github.com/Nicolas-Delahaie)
- **Backend** : [En cours de développement]

## 📞 Contact

Pour toute question ou suggestion :
- 🐛 Issues : [GitHub Issues](https://github.com/Nicolas-Delahaie/ynov-cross-plateform/issues)

---

**Version** : 1.0.0-MVP  
**Dernière mise à jour** : 3 février 2026
