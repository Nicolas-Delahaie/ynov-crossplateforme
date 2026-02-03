import 'package:flutter/foundation.dart';
import '../interfaces/i_profile_repository.dart';
import '../models/game_session.dart';
import '../models/profile.dart';
import '../utils/constants.dart';
import 'statistics_provider.dart';

/// Provider pour la logique du jeu (Single Responsibility + Dependency Injection)
class GameProvider with ChangeNotifier {
  final IProfileRepository _profileRepository;
  final StatisticsProvider _statisticsProvider;

  GameSession? _currentSession;
  bool _isLoading = false;

  GameProvider(this._profileRepository, this._statisticsProvider);

  GameSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  bool get isGameActive => _currentSession != null && !_currentSession!.isFinished;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _profileRepository.initialize();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> startNewGame({int? profilesCount}) async {
    _isLoading = true;
    notifyListeners();

    final int count = profilesCount ?? AppConstants.defaultProfilesPerGame;
    final profiles = await _profileRepository.getProfiles(count);

    _currentSession = GameSession(profiles: profiles);
    
    _isLoading = false;
    notifyListeners();
  }

  void answerQuestion(ProfileType userAnswer) {
    if (_currentSession == null || _currentSession!.isFinished) return;

    final currentProfile = _currentSession!.currentProfile;
    if (currentProfile == null) return;

    final bool isCorrect = currentProfile.type == userAnswer;
    _currentSession!.answerQuestion(isCorrect);

    if (_currentSession!.isFinished) {
      _finishGame();
    }

    notifyListeners();
  }

  void _finishGame() {
    if (_currentSession == null) return;

    // Délègue la gestion des statistiques au StatisticsProvider
    _statisticsProvider.updateWithSession(_currentSession!);
  }

  void endGame() {
    _currentSession = null;
    notifyListeners();
  }
}
