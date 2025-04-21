import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/views/views.dart';

void main() {
  runApp(const ProviderScope(child: HighwayApp()));
}

class HighwayApp extends StatelessWidget {
  const HighwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarColor = Color.fromRGBO(180, 255, 0, 1.0);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.black,
          elevation: 4,
        ),
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DataDisplayView(),
      routes: [
        GoRoute(
          path: 'county_stickers',
          builder: (context, state) => const CountyStickers(),
        ),
        GoRoute(
          path: 'summary',
          builder: (context, state) => const SummaryPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/payment_result',
      builder: (context, state) => const PaymentResultPage(),
    ),
  ],
);
