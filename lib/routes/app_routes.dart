import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/code_extraction_results/code_extraction_results.dart';
import '../presentation/video_upload/video_upload.dart';
import '../presentation/video_processing/video_processing.dart';
import '../presentation/settings/settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String codeExtractionResults = '/code-extraction-results';
  static const String videoUpload = '/video-upload';
  static const String videoProcessing = '/video-processing';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    codeExtractionResults: (context) => const CodeExtractionResults(),
    videoUpload: (context) => const VideoUpload(),
    videoProcessing: (context) => const VideoProcessing(),
    settings: (context) => const Settings(),
    // TODO: Add your other routes here
  };
}
