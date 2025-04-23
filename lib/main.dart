import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:motorway_sticker_app/utils/utils.dart';
import 'package:motorway_sticker_app/views/views.dart';

void main() {
  runApp(const ProviderScope(child: HighwayApp()));
}

class HighwayApp extends StatelessWidget {
  const HighwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: green(context),
            statusBarIconBrightness: Brightness.light,
          ),
        );
        return child!;
      },
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => firstPage(DataDisplayView(), state),
      routes: [
        GoRoute(
          path: 'county_stickers',
          pageBuilder:
              (context, state) => defaultTransition(CountyStickers(), state),
        ),
        GoRoute(
          path: 'summary',
          pageBuilder:
              (context, state) => defaultTransition(SummaryPage(), state),
        ),
      ],
    ),
    GoRoute(
      path: '/payment_result',
      pageBuilder:
          (context, state) => defaultTransition(PaymentResultPage(), state),
    ),
  ],
);
