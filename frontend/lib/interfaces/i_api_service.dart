import '../models/profile.dart';

/// Interface for API service (future backend integration)
abstract class IApiService {
  /// Fetch random profiles from the API
  /// 
  /// [count] - Number of profiles to fetch (1-50)
  /// 
  /// Throws [NetworkException] if network error occurs
  /// Throws [ApiException] if API returns an error
  /// Throws [DataParseException] if response cannot be parsed
  Future<List<Profile>> fetchRandomProfiles(int count);

  /// Submit game session results (future feature)
  /// 
  /// Returns session ID and rank if successful
  Future<Map<String, dynamic>> submitSession(Map<String, dynamic> sessionData);

  /// Check API health/availability
  Future<bool> checkHealth();
}
