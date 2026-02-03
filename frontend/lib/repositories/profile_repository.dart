import '../interfaces/i_profile_repository.dart';
import '../interfaces/i_data_service.dart';
import '../models/profile.dart';

/// Repository pour l'accès aux profils (Repository Pattern + Single Responsibility)
class ProfileRepository implements IProfileRepository {
  final IDataService _dataService;

  ProfileRepository(this._dataService);

  @override
  Future<void> initialize() async {
    await _dataService.init();
  }

  @override
  Future<List<Profile>> getProfiles(int count) async {
    return _dataService.getRandomProfiles(count);
  }

  @override
  int get totalProfilesCount => _dataService.availableProfilesCount;
}
