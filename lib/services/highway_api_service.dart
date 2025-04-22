import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class HighwayApiService {
  HighwayApiService({this.baseUrl = 'http://10.0.2.2:8080'});

  final String baseUrl;
  static const _timeout = Duration(seconds: 10);

  Future<Map<String, dynamic>> fetchAllData() async {
    try {
      final userResponse = await http
          .get(
            Uri.parse('$baseUrl/v1/highway/vehicle'),
            headers: {'Accept-Charset': 'utf-8'},
          )
          .timeout(_timeout);

      final vignetteResponse = await http
          .get(
            Uri.parse('$baseUrl/v1/highway/info'),
            headers: {'Accept-Charset': 'utf-8'},
          )
          .timeout(_timeout);

      return {
        'user': _handleJson(utf8.decode(userResponse.bodyBytes)),
        'vignettes': _handleJson(utf8.decode(vignetteResponse.bodyBytes)),
      };
    } catch (e) {
      throw Exception('Failed to load data: ${e.toString()}');
    }
  }

  static Map<String, dynamic> _handleJson(String jsonString) {
    try {
      final trimmed = jsonString.trim();
      final fixedJson = trimmed.endsWith('}') ? trimmed : '$trimmed}';
      return jsonDecode(fixedJson) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw Exception('Invalid JSON: ${e.message}');
    }
  }

  Future<String> submitOrder(Map<String, dynamic> body) async {
    final String apiUrl = '$baseUrl/v1/highway/order';

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      final decoded = jsonDecode(response.body);
      return decoded['statusCode'] == 'OK' ? 'SUCCESS' : 'FAILURE';
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
