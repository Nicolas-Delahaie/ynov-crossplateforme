import '../interfaces/i_statistics_repository.dart';
import '../interfaces/i_storage_service.dart';
import '../models/user_statistics.dart';

/// Repository pour l'accès aux statistiques (Repository Pattern + Single Responsibility)
class StatisticsRepository implements IStatisticsRepository {
  final IStorageService _storageService;

  StatisticsRepository(this._storageService);

  @override
  Future<void> initialize() async {
    await _storageService.init();
  }

  @override
  Future<void> save(UserStatistics statistics) async {
    await _storageService.saveStatistics(statistics);
  }

  @override
  UserStatistics? load() {
    return _storageService.loadStatistics();
  }

  @override
  Future<void> clear() async {
    await _storageService.clearStatistics();
  }
}
