import '../models/user_statistics.dart';

/// Interface pour le repository de statistiques utilisateur.
///
/// Gère la persistance et la mise à jour des statistiques de jeu.
/// Implémente le Repository Pattern pour abstraire le stockage.
abstract class IStatisticsRepository {
  /// Initialise le repository de statistiques.
  ///
  /// Charge le service de stockage sous-jacent.
  Future<void> initialize();

  /// Sauvegarde les statistiques utilisateur.
  ///
  /// [statistics] : Objet [UserStatistics] à persister.
  Future<void> save(UserStatistics statistics);

  /// Charge les statistiques utilisateur depuis le stockage.
  ///
  /// Retourne les [UserStatistics] sauvegardées, ou null si aucune statistique n'existe.
  UserStatistics? load();

  /// Réinitialise toutes les statistiques à zéro.
  ///
  /// Action irréversible. Utilisé pour le bouton "Reset Stats".
  Future<void> clear();
}
