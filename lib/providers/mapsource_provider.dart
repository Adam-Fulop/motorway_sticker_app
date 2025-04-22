import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorway_sticker_app/providers/providers.dart';
import 'package:motorway_sticker_app/utils/utils.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

final mapSourceProvider = Provider<MapShapeSource>((ref) {
  final selectedCounties = ref.watch(selectedCountiesOnMapProvider);

  final highlightedRegionIds =
      selectedCounties
          .expand((county) => countyToRegionIDs[county] ?? [])
          .toList();

  final allRegionIds = countyToRegionIDs.values.expand((list) => list).toList();

  return MapShapeSource.asset(
    'assets/hungary_counties.geojson',
    shapeDataField: 'id',
    dataCount: allRegionIds.length,
    primaryValueMapper: (index) => allRegionIds[index],
    shapeColorValueMapper: (index) {
      final id = allRegionIds[index];
      return highlightedRegionIds.contains(id) ? custGreen : Colors.grey[300];
    },
  );
});
