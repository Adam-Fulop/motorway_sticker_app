import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/components/components.dart';
import 'package:motorway_sticker_app/providers/providers.dart';
import 'package:motorway_sticker_app/utils/utils.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVignette = ref.watch(selectedVignetteProvider);
    final selectedCounties = ref.watch(selectedCountiesProvider);
    final appData = ref.watch(appDataProvider);

    ref.listen<AsyncValue<String>>(paymentResultProvider, (prev, next) {
      next.whenOrNull(
        data: (result) {
          if (result.isNotEmpty) {
            context.go('/payment_result');
          }
        },
        error: (_, __) => context.go('/payment_result'),
      );
    });

    return appData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (e, _) => ErrorRetryView(
            message: e.toString(),
            onRetry: () => ref.invalidate(appDataProvider),
          ),
      data: (data) {
        final total =
            selectedVignette == 'YEAR'
                ? ref.read(countiesTotalProvider) + sysUsageFee
                : _getVignettePrice(data['vignettes'], selectedVignette) +
                    sysUsageFee;

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Vásárlás megerősítése'),
              backgroundColor: green(context),
              foregroundColor: Colors.white,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Information
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: VehicleInfoSection(userData: data['user']),
                ),
                const SizedBox(height: 16),

                // Selection Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Vásárolni kívánt matricák',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Content based on selection
                if (selectedVignette != 'YEAR') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(getVignetteDisplayName(selectedVignette!)),
                    ),
                  ),
                ] else ...[
                  // County Vignettes Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Megyematricák:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Scrollable County List
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // itt
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...(data['vignettes']['payload']?['counties']
                                        as List? ??
                                    [])
                                .where((c) => selectedCounties[c['id']] == true)
                                .map(
                                  (county) => ListTile(
                                    leading: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    title: Text(county['name']),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // Bottom Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Divider(height: 32),
                      Text(
                        'Rendszerhasználati díj: ${numberFormatter(sysUsageFee)} Ft.-',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Összesen: ${numberFormatter(total)} Ft.-',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            final orderData = _prepareOrderData(
                              selectedVignette: selectedVignette,
                              selectedCounties: selectedCounties,
                              total: total,
                              userData: data['user'],
                              vignetteData: data['vignettes'],
                            );

                            ref.read(orderDataProvider.notifier).state =
                                orderData;
                            final apiService = ref.read(apiServiceProvider);
                            await ref
                                .read(paymentResultProvider.notifier)
                                .submitOrder(orderData, apiService);
                          },
                          child: const Text(
                            'Vásárlás',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getVignettePrice(Map<String, dynamic> vignetteData, String? type) {
    if (type == null) return 0;
    final vignettes =
        vignetteData['payload']?['highwayVignettes'] as List? ?? [];
    final vignette = vignettes.firstWhere(
      (v) => (v['vignetteType'] as List).contains(type),
      orElse: () => null,
    );
    return (vignette?['sum'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> _prepareOrderData({
    required String? selectedVignette,
    required Map<String, bool> selectedCounties,
    required int total,
    required Map<String, dynamic> userData,
    required Map<String, dynamic> vignetteData,
  }) {
    final orders = <Map<String, dynamic>>[];

    if (selectedVignette != 'YEAR') {
      // Single vignette purchase
      orders.add({
        'type': selectedVignette,
        'category': userData['type'] ?? 'CAR',
        'cost': total,
      });
    } else {
      // County vignettes
      final counties = vignetteData['payload']?['counties'] as List? ?? [];
      for (final county in counties) {
        if (selectedCounties[county['id']] == true) {
          orders.add({
            'type': 'YEAR',
            'category': userData['type'] ?? 'CAR',
            'county': county['id'],
            'cost': _getVignettePrice(vignetteData, 'YEAR'),
          });
        }
      }
    }

    return {
      'highwayOrders': orders,
      'vehiclePlate': userData['plate']?.toString().toUpperCase() ?? '',
      'ownerName': userData['name']?.toString() ?? '',
    };
  }
}
