import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/providers/providers.dart';

class PaymentResultPage extends ConsumerWidget {
  const PaymentResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentResult = ref.watch(paymentResultProvider);

    return PopScope(
      // onWillPop: () async => false,
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: paymentResult.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, _) =>
                    _buildResultContent(context, error.toString(), ref),
            data:
                (result) => _buildResultContent(
                  context,
                  result == 'SUCCESS'
                      ? 'SIKERES FIZETÉS'
                      : 'SIKERTELEN FIZETÉS :-(',
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
    ref.invalidate(orderDataProvider);
    ref.invalidate(selectedCountiesOnMapProvider);
    ref.read(paymentResultProvider.notifier).reset();
    context.go('/');
  }
}
