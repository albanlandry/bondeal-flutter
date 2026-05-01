import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const BonDealApp());
}

class BonDealApp extends StatefulWidget {
  const BonDealApp({super.key});

  @override
  State<BonDealApp> createState() => _BonDealAppState();
}

class _BonDealAppState extends State<BonDealApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          onFinish: () => setState(() => _showSplash = false),
        ),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BonDeal',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
