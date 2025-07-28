import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/initialization_status_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLoadingIndicator = false;
  bool _showStatusItems = false;
  String _loadingText = 'Initialisation de VideoCodeExtractor...';

  final List<Map<String, dynamic>> _initializationTasks = [
    {'title': 'Configuration des services OCR', 'status': 'pending'},
    {'title': 'Vérification des permissions caméra', 'status': 'pending'},
    {'title': 'Préparation du cache vidéo', 'status': 'pending'},
    {'title': 'Chargement des modèles ML Kit', 'status': 'pending'},
  ];

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
    _startInitializationSequence();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _startInitializationSequence() async {
    // Wait for logo animation to complete
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _showLoadingIndicator = true;
      });
    }

    // Show detailed status after initial loading
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _showStatusItems = true;
      });
    }

    // Simulate initialization tasks
    await _performInitializationTasks();

    // Navigate to next screen
    await Future.delayed(const Duration(milliseconds: 500));
    _navigateToNextScreen();
  }

  Future<void> _performInitializationTasks() async {
    for (int i = 0; i < _initializationTasks.length; i++) {
      if (mounted) {
        setState(() {
          _initializationTasks[i]['status'] = 'loading';
        });
      }

      // Simulate task completion time
      await Future.delayed(Duration(milliseconds: 400 + (i * 200)));

      if (mounted) {
        setState(() {
          _initializationTasks[i]['status'] = 'completed';
        });
      }

      // Update loading text based on current task
      if (mounted) {
        setState(() {
          _loadingText = _getLoadingTextForTask(i);
        });
      }
    }
  }

  String _getLoadingTextForTask(int taskIndex) {
    switch (taskIndex) {
      case 0:
        return 'Configuration des services OCR...';
      case 1:
        return 'Vérification des permissions...';
      case 2:
        return 'Préparation du stockage...';
      case 3:
        return 'Finalisation de l\'initialisation...';
      default:
        return 'Initialisation terminée';
    }
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // Check if this is first launch or permissions are needed
      final bool hasCompletedOnboarding = _checkOnboardingStatus();
      final bool hasRequiredPermissions = _checkPermissionStatus();

      if (!hasCompletedOnboarding) {
        // Navigate to onboarding (placeholder route)
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      } else if (!hasRequiredPermissions) {
        // Navigate to permission request (placeholder route)
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      } else {
        // Navigate to home dashboard
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    }
  }

  bool _checkOnboardingStatus() {
    // In a real app, this would check SharedPreferences
    // For now, assume onboarding is completed
    return true;
  }

  bool _checkPermissionStatus() {
    // In a real app, this would check actual permissions
    // For now, assume permissions are granted
    return true;
  }

  void _onLogoAnimationComplete() {
    // Logo animation completed, initialization will continue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackgroundWidget(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedLogoWidget(
                    onAnimationComplete: _onLogoAnimationComplete,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _showLoadingIndicator
                        ? LoadingIndicatorWidget(
                            loadingText: _loadingText,
                            isVisible: _showLoadingIndicator,
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 4.h),
                    _showStatusItems
                        ? InitializationStatusWidget(
                            statusItems: _initializationTasks,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Column(
                  children: [
                    Text(
                      'VideoCodeExtractor',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 4.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Extraction de code Python depuis vidéos',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 3.w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset system UI overlay
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
