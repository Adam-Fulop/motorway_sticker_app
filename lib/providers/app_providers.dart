import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorway_sticker_app/services/highway_api_service.dart';

final selectedVignetteProvider = StateProvider<String?>((ref) => null);

final apiServiceProvider = Provider((ref) => HighwayApiService());

final orderDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

final appDataProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(apiServiceProvider).fetchAllData();
});
