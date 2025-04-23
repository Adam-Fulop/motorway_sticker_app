import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorway_sticker_app/providers/providers.dart';
import 'package:motorway_sticker_app/services/highway_api_service.dart';

final selectedVignetteProvider = StateProvider<String?>((ref) => null);

final apiServiceProvider = Provider((ref) => HighwayApiService());

final orderDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final appDataProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(apiServiceProvider).fetchAllData();
});

final selectedCountiesOnMapProvider = StateProvider<List<String>>((ref) => []);

final mapLoadedProvider = StateProvider<bool>((ref) => false);

final countiesTotalProvider = Provider<int>((ref) {
  final selected = ref.watch(selectedCountiesProvider);
  final appData = ref.watch(appDataProvider).value;

  if (appData == null) return 0;

  final vignettes =
      appData['vignettes']['payload']?['highwayVignettes'] as List? ?? [];
  final annualVignette = vignettes.firstWhere(
    (v) => (v['vignetteType'] as List).contains('YEAR'),
    orElse: () => null,
  );

  if (annualVignette == null) return 0;

  return selected.entries.where((e) => e.value).length *
      (annualVignette['sum'] as num).toInt();
});
