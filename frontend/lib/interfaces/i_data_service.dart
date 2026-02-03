import '../models/profile.dart';

/// Interface pour le service de chargement des profils.
///
/// Abstraction permettant de charger des profils depuis différentes sources
/// (JSON local, API REST, base de données, etc.).
/// Suit le principe Dependency Inversion (SOLID).
abstract class IDataService {
  /// Initialise le service de données.
  ///
  /// Charge les profils depuis la source de données.
  ///
  /// Lance :
  /// - [NetworkException] si erreur réseau (pour sources distantes).
  /// - [DataParseException] si erreur de parsing des données.
  /// - [ApiException] si erreur API (code HTTP non-2xx).
  Future<void> init();

  /// Charge tous les profils disponibles depuis la source de données.
  ///
  /// Lance :
  /// - [NetworkException] si erreur réseau (pour sources distantes).
  /// - [DataParseException] si erreur de parsing des données.
  /// - [ApiException] si erreur API (code HTTP non-2xx).
  Future<void> loadProfiles();

  /// Retourne un nombre aléatoire de profils.
  ///
  /// [count] : Nombre de profils à retourner.
  ///
  /// Retourne une [List<Profile>] mélangée aléatoirement.
  /// Si [count] > nombre de profils disponibles, retourne tous les profils.
  List<Profile> getRandomProfiles(int count);

  /// Retourne le nombre total de profils disponibles.
  ///
  /// Retourne 0 si les profils n'ont pas encore été chargés.
  int get availableProfilesCount;
}
