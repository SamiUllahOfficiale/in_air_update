library in_air_update;

import 'dart:convert';

import 'package:hive_quick/hive_quick.dart';
import 'package:http/http.dart' as http;

/// A manager class to handle Over-The-Air (OTA) patches and dynamic configurations in Flutter applications.
class InAirUpdate {
  // Private constructor to prevent instantiation
  InAirUpdate._internal();

  static String? _endpointUrl;
  static bool _isInitialized = false;
  static late final HiveQuickStore<Map<String, dynamic>> _patchStore;
  static const String _patchKey = 'latest_patch';

  /// Initializes the [InAirUpdate] service with the given remote [endpointUrl].
  static Future<void> initialize({required String endpointUrl}) async {
    _endpointUrl = endpointUrl;

    _patchStore = HiveQuick.store<Map<String, dynamic>>(
      boxName: 'in_air_update_box',
      fromJson: (json) => Map<String, dynamic>.from(json),
      toJson: (map) => map,
    );

    _isInitialized = true;
  }

  /// Checks and fetches the latest patch from the remote server endpoint, caching it locally.
  static Future<Map<String, dynamic>?> checkForUpdates() async {
    if (!_isInitialized || _endpointUrl == null) {
      throw Exception(
          'InAirUpdate is not initialized. Call initialize() first.');
    }

    try {
      final response = await http.get(Uri.parse(_endpointUrl!));
      if (response.statusCode == 200) {
        final Map<String, dynamic> patchData = jsonDecode(response.body);

        await _patchStore.updateOne({
          'id': _patchKey,
          ...patchData,
        });

        return patchData;
      }
    } catch (e) {
      print('Failed to fetch remote update, falling back to local cache: $e');
      return await getCachedPatch();
    }
    return await getCachedPatch();
  }

  /// Retrieves the locally cached patch from the store asynchronously.
  static Future<Map<String, dynamic>?> getCachedPatch() async {
    try {
      final patch = await _patchStore.findOne(_patchKey);
      if (patch != null) {
        return patch;
      }
    } catch (e) {
      print('Failed to retrieve cached patch: $e');
    }
    return null;
  }
}
