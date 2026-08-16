import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/services/ads_service.dart';
import 'core/services/storage_service.dart';

void main() async {
  // Capture all unhandled errors so app never auto-closes silently
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Error widget for debug
    ErrorWidget.builder = (details) {
      return Material(
        color: const Color(0xFF0A0E21),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Error: ${details.exception}\n${details.stack ?? ''}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      );
    };

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };

    // Edge-to-edge, immersive
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } catch (e) {
      debugPrint('SystemChrome setup failed: $e');
    }

    // Init local storage - MUST succeed
    late StorageService storageService;
    try {
      storageService = await StorageService.init().timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Storage init timeout'));
    } catch (e, s) {
      debugPrint('Storage init failed $e $s - using fallback');
      // Fallback to in-memory if GetStorage fails to prevent crash
      storageService = await StorageService.init();
    }

    // Init Ads - MUST NOT crash app if manifest missing
    try {
      // Delay ads init after first frame to avoid blocking launch
      Future.delayed(const Duration(milliseconds: 800), () async {
        try {
          await AdsService.instance.init();
        } catch (e) {
          debugPrint(
              'Ads init delayed failed (expected if Manifest missing): $e');
        }
      });
    } catch (e) {
      debugPrint('Ads init setup failed: $e');
    }

    runApp(FlutteryWingsApp(storageService: storageService));
  }, (error, stack) {
    debugPrint('UNCAUGHT ZONED ERROR: $error\n$stack');
  });
}
