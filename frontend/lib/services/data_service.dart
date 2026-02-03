import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../interfaces/i_data_service.dart';
import '../models/profile.dart';
import '../utils/constants.dart';

/// Implémentation concrète du service de données (Dependency Inversion Principle + Open/Closed)
class DataService implements IDataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Profile>? _allProfiles;
  final Random _random = Random();

  @override
  Future<void> init() async {
    await loadProfiles();
  }

  @override
  Future<void> loadProfiles() async {
    try {
      final String jsonString = await rootBundle.loadString(
        AppConstants.profilesDataPath,
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> profilesJson = jsonData['profiles'];
      
      _allProfiles = profilesJson
          .map((json) => Profile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If loading fails, use empty list
      _allProfiles = [];
    }
  }

  @override
  List<Profile> getRandomProfiles(int count) {
    if (_allProfiles == null || _allProfiles!.isEmpty) {
      return [];
    }

    // Create a shuffled copy
    final List<Profile> shuffled = List.from(_allProfiles!);
    shuffled.shuffle(_random);

    // Return the requested number of profiles (or all if less available)
    return shuffled.take(count).toList();
  }

  @override
  int get availableProfilesCount => _allProfiles?.length ?? 0;
}
