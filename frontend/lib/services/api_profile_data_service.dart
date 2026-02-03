import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../interfaces/i_api_service.dart';
import '../interfaces/i_data_service.dart';
import '../models/profile.dart';
import '../utils/exceptions.dart';

/// API-based implementation of IDataService (ready for backend integration)
/// 
/// This service will replace DataService when the backend API is ready.
/// Uses dependency injection and implements retry logic.
class ApiProfileDataService implements IDataService, IApiService {
  final http.Client _client;
  final String baseUrl;
  
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 15);
  static const List<int> _retryableStatusCodes = [408, 429, 500, 502, 503, 504];

  ApiProfileDataService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? _getDefaultBaseUrl();

  static String _getDefaultBaseUrl() {
    // TODO: Load from environment configuration
    const env = String.fromEnvironment('ENV', defaultValue: 'development');
    switch (env) {
      case 'production':
        return 'https://api.linkedin-interpol.app/v1';
      case 'staging':
        return 'https://api-staging.linkedin-interpol.app/v1';
      default:
        return 'http://localhost:3000/v1';
    }
  }

  @override
  Future<void> init() async {
    // Check API health on initialization
    try {
      await checkHealth();
    } catch (e) {
      throw NetworkException(
        'Failed to connect to API during initialization',
        details: e.toString(),
      );
    }
  }

  @override
  Future<void> loadProfiles() async {
    // Not needed for API implementation - profiles are fetched on demand
  }

  @override
  List<Profile> getRandomProfiles(int count) {
    throw UnimplementedError(
      'Use fetchRandomProfiles() instead for async API calls',
    );
  }

  @override
  Future<List<Profile>> fetchRandomProfiles(int count) async {
    if (count < 1 || count > 50) {
      throw AppException(
        'Count must be between 1 and 50',
        code: 'INVALID_COUNT',
        details: {'provided': count, 'min': 1, 'max': 50},
      );
    }

    final uri = Uri.parse('$baseUrl/profiles/random').replace(
      queryParameters: {'count': count.toString()},
    );

    return _executeWithRetry(() => _fetchProfilesRequest(uri));
  }

  Future<List<Profile>> _fetchProfilesRequest(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonData['success'] != true) {
          throw ApiException(
            jsonData['error']?['message'] ?? 'API request failed',
            statusCode: response.statusCode,
            code: jsonData['error']?['code'],
          );
        }

        final profilesJson = jsonData['data']['profiles'] as List<dynamic>;
        return profilesJson
            .map((json) => Profile.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        throw ApiException(
          jsonData['error']?['message'] ?? 'HTTP ${response.statusCode}',
          statusCode: response.statusCode,
          code: jsonData['error']?['code'],
        );
      }
    } on SocketException catch (e) {
      throw NetworkException(
        'No internet connection',
        details: e.toString(),
      );
    } on FormatException catch (e) {
      throw DataParseException(
        'Invalid JSON response from server',
        details: e.toString(),
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        'Network request failed',
        details: e.toString(),
      );
    }
  }

  @override
  Future<Map<String, dynamic>> submitSession(
    Map<String, dynamic> sessionData,
  ) async {
    final uri = Uri.parse('$baseUrl/sessions');

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(sessionData),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonData['data'] as Map<String, dynamic>;
      } else {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        throw ApiException(
          jsonData['error']?['message'] ?? 'Failed to submit session',
          statusCode: response.statusCode,
          code: jsonData['error']?['code'],
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException('Failed to submit session', details: e.toString());
    }
  }

  @override
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/health');
      final response = await _client.get(uri).timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  int get availableProfilesCount {
    // For API implementation, return a large number since profiles are fetched on demand
    return 1000;
  }

  /// Execute a function with retry logic for network errors
  Future<T> _executeWithRetry<T>(Future<T> Function() function) async {
    int attempt = 0;
    
    while (attempt < _maxRetries) {
      try {
        return await function();
      } on ApiException catch (e) {
        // Retry on retryable status codes
        if (e.statusCode != null &&
            _retryableStatusCodes.contains(e.statusCode) &&
            attempt < _maxRetries - 1) {
          attempt++;
          await Future.delayed(_getBackoffDelay(attempt));
          continue;
        }
        rethrow;
      } on NetworkException catch (_) {
        // Retry on network errors
        if (attempt < _maxRetries - 1) {
          attempt++;
          await Future.delayed(_getBackoffDelay(attempt));
          continue;
        }
        rethrow;
      }
    }
    
    throw NetworkException('Max retries exceeded');
  }

  /// Get exponential backoff delay: 1s, 2s, 4s
  Duration _getBackoffDelay(int attempt) {
    return Duration(seconds: 1 << attempt); // 2^attempt
  }

  void dispose() {
    _client.close();
  }
}
