import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/components/components.dart';
import 'package:motorway_sticker_app/providers/providers.dart';
import 'package:motorway_sticker_app/utils/utils.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CountyStickers extends ConsumerStatefulWidget {
  const CountyStickers({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountyStickersState();
}

class _CountyStickersState extends ConsumerState<CountyStickers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapLoadedProvider.notifier).state = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);
    final selectedCounties = ref.watch(selectedCountiesProvider);
    final selectedOnMap = ref.watch(selectedCountiesOnMapProvider.notifier);
    final mapSource = ref.watch(mapSourceProvider);
    final total = ref.watch(countiesTotalProvider);

    return appData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (e, _) => ErrorRetryView(
            message: e.toString(),
            onRetry: () => ref.invalidate(appDataProvider),
          ),
      data: (data) {
        final dataPayload = data['vignettes']['payload'];
        final vignettes = dataPayload?['highwayVignettes'] as List? ?? [];
        final counties = dataPayload?['counties'] as List? ?? [];
        final annualVignette = vignettes.firstWhere(
          (v) => (v['vignetteType'] as List).contains('YEAR'),
          orElse: () => null,
        );

        if (annualVignette == null) {
          return const Center(
            child: Text('Nem található éves megyematrica ...'),
          );
        }

        final price = (annualVignette['sum'] as num).toInt();

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('County Vignettes', style: whiteFgColor),
              backgroundColor: green(context),
              foregroundColor: Colors.white,
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: 1.0,
                      child: SfMaps(
                        layers: [
                          MapShapeLayer(
                            source: mapSource,
                            showDataLabels: false,
                            color: Colors.grey[300],
                            dataLabelSettings: const MapDataLabelSettings(
                              textStyle: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: counties.length,
                    itemBuilder: (context, index) {
                      final county = counties[index] as Map<String, dynamic>;
                      final countyId = county['id'] as String;
                      final countyName = county['name'] as String;
                      final isSelected = selectedCounties[countyId] ?? false;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          title: Text(
                            countyName,
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text('${numberFormatter(price)} HUF'),
                          value: isSelected,
                          onChanged: (value) {
                            selectedOnMap.update(
                              (state) =>
                                  value!
                                      ? [...state, countyName] // if true, add
                                      : state
                                          .where((item) => item != countyName)
                                          .toList(), // if false, remove
                            );
                            ref
                                .read(selectedCountiesProvider.notifier)
                                .toggleCounty(countyId);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${numberFormatter(total)} HUF',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      FilledButton(
                        onPressed:
                            total > 0 ? () => context.push('/summary') : null,
                        child: const Text('Megrendelés'),
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
}

// class CountyStickers extends ConsumerWidget {
//   const CountyStickers({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref)
