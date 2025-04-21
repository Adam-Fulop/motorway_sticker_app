import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CountyStickers extends ConsumerWidget {
  const CountyStickers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('County Stickers'), centerTitle: true),
        body: Column(
          children: [
            Placeholder(),
            FilledButton(
              onPressed: () => context.push('/summary'),
              child: Text('PLACE ORDER'),
            ),
          ],
        ),
      ),
    );
  }
}
