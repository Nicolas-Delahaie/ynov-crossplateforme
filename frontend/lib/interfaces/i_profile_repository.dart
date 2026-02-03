import '../models/profile.dart';

/// Interface pour le repository de profils.
///
/// Gère l'accès et la manipulation des profils du jeu.
/// Implémente le Repository Pattern pour abstraire la logique
/// d'accès aux données et faciliter les tests.
abstract class IProfileRepository {
  /// Initialise le repository et charge les profils.
  ///
  /// Lance :
  /// - [NetworkException] si erreur réseau.
  /// - [DataParseException] si parsing échoue.
  Future<void> initialize();

  /// Retourne un nombre aléatoire de profils.
  ///
  /// [count] : Nombre de profils à retourner.
  ///
  /// Retourne une [List<Profile>] mélangée aléatoirement.
  /// Si [count] > nombre de profils disponibles, retourne tous les profils.
  ///
  /// Lance [NoProfilesAvailableException] si liste vide.
  Future<List<Profile>> getProfiles(int count);

  /// Retourne le nombre total de profils disponibles.
  ///
  /// Retourne 0 si les profils n'ont pas encore été chargés.
  int get totalProfilesCount;
}
