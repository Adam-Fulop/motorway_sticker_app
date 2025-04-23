import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorway_sticker_app/providers/providers.dart';
import 'package:motorway_sticker_app/utils/utils.dart';

class VignettesSection extends ConsumerWidget {
  const VignettesSection({super.key, required this.vignetteData});

  final Map<String, dynamic> vignetteData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVignette = ref.watch(selectedVignetteProvider);
    final allVignettes =
        vignetteData['payload']?['highwayVignettes'] as List? ?? [];

    final daily = _findVignette(allVignettes, VignetteType.day);
    final weekly = _findVignette(allVignettes, VignetteType.week);
    final monthly = _findVignette(allVignettes, VignetteType.month);
    final annual = _findVignette(allVignettes, VignetteType.year);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        _buildSectionHeader('Országos matricák'),
        if (daily != null)
          _buildVignetteCard(daily, selectedVignette, ref, context),
        if (weekly != null)
          _buildVignetteCard(weekly, selectedVignette, ref, context),
        if (monthly != null)
          _buildVignetteCard(monthly, selectedVignette, ref, context),
        if (annual != null) ...[
          const SizedBox(height: 24),
          _buildSectionHeader('Éves vármegye matricák'),
          _buildVignetteCard(annual, selectedVignette, ref, context),
        ],
      ],
    );
  }

  Map<String, dynamic>? _findVignette(List<dynamic> vignettes, String type) {
    try {
      return vignettes.firstWhere(
        (v) => (v['vignetteType'] as List).contains(type),
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVignetteCard(
    Map<String, dynamic> v,
    String? selectedType,
    WidgetRef ref,
    BuildContext context,
  ) {
    final type = (v['vignetteType'] as List).first.toString();
    // final isSelected = selectedType == type;
    // final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      // color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => ref.read(selectedVignetteProvider.notifier).state = type,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Radio<String>(
                value: type,
                groupValue: selectedType,
                onChanged:
                    (value) =>
                        ref.read(selectedVignetteProvider.notifier).state =
                            value,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getVignetteDisplayName(type),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${numberFormatter(v['sum'])} Ft'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
