import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DataDisplayView extends ConsumerWidget {
  const DataDisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Highway Vignettes'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Placeholder(),
            FilledButton(
              onPressed: () => context.push('/county_stickers'),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
