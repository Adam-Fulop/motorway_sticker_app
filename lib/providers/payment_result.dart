import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorway_sticker_app/services/highway_api_service.dart';

final paymentResultProvider =
    AsyncNotifierProvider<PaymentResultNotifier, String>(() {
      return PaymentResultNotifier();
    });

class PaymentResultNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    // Initial state - empty string
    return '';
  }

  Future<void> submitOrder(
    Map<String, dynamic> orderData,
    HighwayApiService apiService,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await apiService.submitOrder(orderData);
    });
  }

  void reset() {
    state = const AsyncValue.data('');
  }
}
