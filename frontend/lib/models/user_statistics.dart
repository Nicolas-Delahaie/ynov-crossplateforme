import 'game_session.dart';
import 'profile.dart';

/// Statistiques globales de l'utilisateur.
///
/// Contient toutes les données de progression du joueur,
/// incluant le nombre de parties jouées, les meilleurs scores,
/// et les erreurs par type de profil.
class UserStatistics {
  /// Nombre total de parties jouées
  int totalGamesPlayed;

  /// Meilleur score obtenu dans une partie
  int bestScore;

  /// Plus longue série de bonnes réponses consécutives
  int bestStreak;

  /// Taux de précision global (0.0 à 1.0)
  double overallAccuracy;

  /// Nombre d'erreurs par type de profil (LinkedIn vs Interpol)
  Map<ProfileType, int> errorsByType;

  UserStatistics({
    this.totalGamesPlayed = 0,
    this.bestScore = 0,
    this.bestStreak = 0,
    this.overallAccuracy = 0.0,
    Map<ProfileType, int>? errorsByType,
  }) : errorsByType = errorsByType ?? {
          ProfileType.linkedin: 0,
          ProfileType.interpol: 0,
        };

  /// Met à jour les statistiques avec les résultats d'une session terminée.
  ///
  /// [session] : La session de jeu terminée.
  ///
  /// Incrémente le compteur de parties, met à jour les meilleurs scores/streaks,
  /// recalcule la précision globale et comptabilise les erreurs par type.
  void updateWithSession(GameSession session) {
    totalGamesPlayed++;

    if (session.correctAnswers > bestScore) {
      bestScore = session.correctAnswers;
    }

    if (session.bestStreak > bestStreak) {
      bestStreak = session.bestStreak;
    }

    // Recalcul de la précision globale
    double totalCorrect =
        (overallAccuracy * (totalGamesPlayed - 1) * session.profiles.length) +
            session.correctAnswers;
    double totalQuestions = (totalGamesPlayed * session.profiles.length).toDouble();
    overallAccuracy = totalCorrect / totalQuestions;

    // Mise à jour des erreurs par type
    for (int i = 0; i < session.answers.length; i++) {
      if (!session.answers[i]) {
        ProfileType type = session.profiles[i].type;
        errorsByType[type] = (errorsByType[type] ?? 0) + 1;
      }
    }
  }

  /// Convertit les statistiques en JSON pour persistance.
  Map<String, dynamic> toJson() {
    return {
      'totalGamesPlayed': totalGamesPlayed,
      'bestScore': bestScore,
      'bestStreak': bestStreak,
      'overallAccuracy': overallAccuracy,
      'errorsByType': {
        'linkedin': errorsByType[ProfileType.linkedin] ?? 0,
        'interpol': errorsByType[ProfileType.interpol] ?? 0,
      },
    };
  }

  /// Crée des [UserStatistics] depuis un objet JSON.
  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalGamesPlayed: json['totalGamesPlayed'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      overallAccuracy: (json['overallAccuracy'] as num?)?.toDouble() ?? 0.0,
      errorsByType: {
        ProfileType.linkedin: (json['errorsByType']?['linkedin'] as int?) ?? 0,
        ProfileType.interpol: (json['errorsByType']?['interpol'] as int?) ?? 0,
      },
    );
  }
}
