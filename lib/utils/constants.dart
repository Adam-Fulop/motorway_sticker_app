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
