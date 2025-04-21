import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Summary'), centerTitle: true),
        body: Column(
          children: [
            Placeholder(),
            FilledButton(
              onPressed: () => context.go('/payment_result'),
              child: Text('PAY'),
            ),
          ],
        ),
      ),
    );
  }
}
