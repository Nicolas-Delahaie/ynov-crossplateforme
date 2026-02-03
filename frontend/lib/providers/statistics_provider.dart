import 'package:flutter/foundation.dart';
import '../interfaces/i_statistics_repository.dart';
import '../models/game_session.dart';
import '../models/user_statistics.dart';

/// Provider dédié aux statistiques (Single Responsibility Principle)
class StatisticsProvider with ChangeNotifier {
  final IStatisticsRepository _repository;
  
  UserStatistics _statistics = UserStatistics();
  bool _isLoading = false;

  StatisticsProvider(this._repository);

  UserStatistics get statistics => _statistics;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _repository.initialize();

    final savedStats = _repository.load();
    if (savedStats != null) {
      _statistics = savedStats;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateWithSession(GameSession session) async {
    _statistics.updateWithSession(session);
    await _repository.save(_statistics);
    notifyListeners();
  }

  Future<void> reset() async {
    _statistics = UserStatistics();
    await _repository.clear();
    notifyListeners();
  }
}
