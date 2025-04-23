import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Color countyColor = Color.fromRGBO(39, 106, 74, 1.0);

const TextStyle whiteFgColor = TextStyle(color: Colors.white);

Color green(BuildContext ctx) {
  return Theme.of(ctx).colorScheme.primary;
}

const int sysUsageFee = 100;

class VignetteType {
  static const String day = 'DAY';
  static const String week = 'WEEK';
  static const String month = 'MONTH';
  static const String year = 'YEAR';
}

const Map<String, String> vignetteTypeDisplayNames = {
  VignetteType.day: 'D1 - napi (1 napos)',
  VignetteType.week: 'D1 - heti (10 napos)',
  VignetteType.month: 'D1 - havi',
  VignetteType.year: 'D1 - éves',
};

const Map<String, String> vehicleTypeDisplayNames = {'CAR': 'Személygépkocsi'};

String getVignetteDisplayName(String type) {
  return vignetteTypeDisplayNames[type] ?? type;
}

String getVehicleDisplayName(String? type) {
  const unknown = 'ismeretlen';
  return vehicleTypeDisplayNames[type] ?? unknown;
}

final countyToRegionIDs = <String, List<String>>{
  'Baranya': ['HUPS', 'HUBA'],
  'Bács-Kiskun': ['HUKM', 'HUBK'],
  'Békés': ['HUBC', 'HUBE'],
  'Borsod-Abaúj-Zemplén': ['HUMI', 'HUBZ'],
  'Csongrád': ['HUHV', 'HUSD', 'HUCS'],
  'Fejér': ['HUSF', 'HUFE', 'HUDU'],
  'Gyor-Moson-Sopron': ['HUGY', 'HUGS'],
  'Hajdú-Bihar': ['HUDE', 'HUHB'],
  'Heves': ['HUEG', 'HUHE'],
  'Jász-Nagykun-Szolnok': ['HUSK', 'HUJN'],
  'Komárom-Esztergom': ['HUTB', 'HUKE'],
  'Nógrád': ['HUST', 'HUNO'],
  'Pest': ['HUBU', 'HUER', 'HUPE'],
  'Somogy': ['HUKV', 'HUSO'],
  'Szabolcs-Szatmár-Bereg': ['HUNY', 'HUSZ'],
  'Tolna': ['HUSS', 'HUTO'],
  'Vas': ['HUSH', 'HUVA'],
  'Veszprém': ['HUVM', 'HUVE'],
  'Zala': ['HUZE', 'HUNK', 'HUZA'],
};

class SvgPic {
  static const String success = 'assets/images/highway_success.svg';
  static const String failure = 'assets/images/highway_failure.svg';

  static Future<void> preloadSVGs() async {
    final assets = [success, failure];
    for (final asset in assets) {
      final loader = SvgAssetLoader(asset);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    }
  }
}
