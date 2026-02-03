import 'profile.dart';

/// Représente une session de jeu en cours.
///
/// Contient tous les profils à deviner, le score actuel,
/// la série (streak) et l'historique des réponses.
class GameSession {
  /// Liste des profils à deviner dans cette session
  final List<Profile> profiles;

  /// Index du profil actuel (0-based)
  int currentIndex;

  /// Nombre total de bonnes réponses
  int correctAnswers;

  /// Nombre total de mauvaises réponses
  int incorrectAnswers;

  /// Série de bonnes réponses consécutives
  int currentStreak;

  /// Historique des réponses (true = correct, false = incorrect)
  List<bool> answers;

  /// Heure de début de la session
  DateTime startTime;

  GameSession({
    required this.profiles,
    this.currentIndex = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.currentStreak = 0,
    List<bool>? answers,
    DateTime? startTime,
  })  : answers = answers ?? [],
        startTime = startTime ?? DateTime.now();

  /// Indique si la session est terminée (tous les profils traités).
  bool get isFinished => currentIndex >= profiles.length;

  /// Calcule le taux de précision (bonnes réponses / total).
  ///
  /// Retourne 0.0 si aucune réponse n'a encore été donnée.
  double get accuracy {
    final total = correctAnswers + incorrectAnswers;
    if (total == 0) return 0.0;
    return correctAnswers / total;
  }

  /// Retourne le profil actuel à deviner.
  ///
  /// Retourne `null` si la session est terminée.
  Profile? get currentProfile {
    if (isFinished) return null;
    return profiles[currentIndex];
  }

  /// Enregistre la réponse pour le profil actuel.
  ///
  /// [isCorrect] : `true` si la réponse est correcte, `false` sinon.
  ///
  /// Met à jour le score, la streak et avance au profil suivant.
  void answerQuestion(bool isCorrect) {
    answers.add(isCorrect);

    if (isCorrect) {
      correctAnswers++;
      currentStreak++;
    } else {
      incorrectAnswers++;
      currentStreak = 0;
    }

    currentIndex++;
  }

  /// Calcule la meilleure série de réponses correctes.
  ///
  /// Parcourt l'historique des réponses et trouve la plus longue
  /// séquence de bonnes réponses consécutives.
  int get bestStreak {
    if (answers.isEmpty) return 0;

    int streak = 0;
    int maxStreak = 0;

    for (var answer in answers) {
      if (answer) {
        streak++;
        if (streak > maxStreak) {
          maxStreak = streak;
        }
      } else {
        streak = 0;
      }
    }

    return maxStreak;
  }

  /// Calcule la durée écoulée depuis le début de la session.
  Duration get duration => DateTime.now().difference(startTime);
}
