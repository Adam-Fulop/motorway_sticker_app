import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/components/components.dart';
import 'package:motorway_sticker_app/providers/providers.dart';

class PaymentResultPage extends ConsumerStatefulWidget {
  const PaymentResultPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentResultPageState();
}

class _PaymentResultPageState extends ConsumerState<PaymentResultPage> {
  @override
  void initState() {
    super.initState();
    _submitOrder();
  }

  void _submitOrder() {
    Future.microtask(() async {
      final apiService = ref.read(apiServiceProvider);
      final orderData = ref.read(orderDataProvider);

      if (orderData.isNotEmpty) {
        await ref
            .read(paymentResultProvider.notifier)
            .submitOrder(orderData, apiService);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentResult = ref.watch(paymentResultProvider);

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: paymentResult.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, _) => ErrorRetryView(
                  message: error.toString(),
                  onRetry: _submitOrder,
                ),
            data:
                (result) => _buildResultContent(
                  context,
                  result == 'SUCCESS'
                      ? 'SUCCESSFUL PAYMENT'
                      : 'UNSUCCESSFUL ORDER',
                  ref,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultContent(
    BuildContext context,
    String message,
    WidgetRef ref,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => _resetAndNavigateHome(ref, context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetAndNavigateHome(WidgetRef ref, BuildContext context) {
    ref.invalidate(selectedVignetteProvider);
    ref.invalidate(selectedCountiesProvider);
    ref.invalidate(selectedCountiesOnMapProvider);
    ref.invalidate(orderDataProvider);
    ref.read(paymentResultProvider.notifier).reset();
    context.go('/');
  }
}
