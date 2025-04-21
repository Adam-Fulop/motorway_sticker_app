import 'package:flutter/material.dart';
import 'package:motorway_sticker_app/utils/constants.dart';

import 'info_row.dart';

class VehicleInfoSection extends StatelessWidget {
  const VehicleInfoSection({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    final vType = getVehicleDisplayName(userData['type']?.toString());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A jármű adatai',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 16),
            InfoRow('Tulajdonos', userData['name']?.toString() ?? 'N/A'),
            InfoRow(
              'Rendszám',
              userData['plate']?.toString().toUpperCase() ?? 'N/A',
            ),
            InfoRow('Jármű típusa', vType),
            if (userData['country'] != null)
              InfoRow(
                'Ország',
                userData['country']['hu']?.toString() ??
                    userData['country']['en']?.toString() ??
                    'N/A',
              ),
          ],
        ),
      ),
    );
  }
}
