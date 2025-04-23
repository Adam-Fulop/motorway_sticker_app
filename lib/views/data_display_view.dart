import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/components/components.dart';
import 'package:motorway_sticker_app/providers/providers.dart';
import 'package:motorway_sticker_app/utils/utils.dart';

class DataDisplayView extends ConsumerStatefulWidget {
  const DataDisplayView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DataDisplayViewState();
}

class _DataDisplayViewState extends ConsumerState<DataDisplayView> {
  @override
  void initState() {
    super.initState();
    // Preload the mapSource ...
    Future.microtask(() => ref.read(mapSourceProvider));
  }

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Autópálya matrica vásárlás', style: whiteFgColor),
          backgroundColor: green(context),
          centerTitle: true,
        ),
        body: appData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (e, _) => ErrorRetryView(
                message: e.toString(),
                onRetry: () => ref.invalidate(appDataProvider),
              ),
          data: (data) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: VehicleInfoSection(userData: data['user']),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: VignettesSection(vignetteData: data['vignettes']),
                  ),
                ),
                _buildBottomButton(ref, context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomButton(WidgetRef ref, BuildContext context) {
    final selectedVignette = ref.watch(selectedVignetteProvider);
    final isAnnualSelected = selectedVignette == VignetteType.year;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: 150,
        child: FilledButton(
          onPressed:
              selectedVignette != null
                  ? () => _handleButtonPress(ref, context)
                  : null,
          child: Text(isAnnualSelected ? 'Folytatás' : 'Megrendelés'),
        ),
      ),
    );
  }

  void _handleButtonPress(WidgetRef ref, BuildContext context) {
    final selected = ref.read(selectedVignetteProvider);
    if (selected == VignetteType.year) {
      context.push('/county_stickers');
    } else {
      context.push('/summary');
    }
  }
}
