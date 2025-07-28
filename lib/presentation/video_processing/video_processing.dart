import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/video_analysis_service.dart';
import './widgets/advanced_details_widget.dart';
import './widgets/processing_animation_widget.dart';
import './widgets/processing_queue_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/status_text_widget.dart';

class VideoProcessing extends StatefulWidget {
  const VideoProcessing({super.key});

  @override
  State<VideoProcessing> createState() => _VideoProcessingState();
}

class _VideoProcessingState extends State<VideoProcessing>
    with TickerProviderStateMixin {
  // Processing state
  double _progress = 0.0;
  String _currentStatus = 'Initialisation...';
  List<String> _statusHistory = [];
  bool _isProcessing = true;
  bool _isCancelled = false;

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  // Processing data
  int _currentFrame = 0;
  int _totalFrames = 0;
  String _estimatedTime = '0:00';

  // Queue data
  int _currentVideoIndex = 1;
  int _totalVideos = 1;
  List<Map<String, dynamic>> _videoQueue = [];

  // Advanced details
  double _frameRate = 30.0;
  int _detectedTextRegions = 0;
  double _confidenceScore = 0.0;
  String _processingMode = 'OpenAI Vision';
  Map<String, dynamic> _deviceInfo = {};

  // Services
  final VideoAnalysisService _analysisService = VideoAnalysisService();

  // Analysis result
  VideoAnalysisResult? _analysisResult;

  @override
  void initState() {
    super.initState();
    _initializeProcessing();
    _setupAnimations();
    _startRealProcessing();
  }

  void _initializeProcessing() {
    // Get arguments from navigation (if any)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        _totalVideos = args['videoCount'] ?? 1;
        _videoQueue = args['videoQueue'] ?? [];
      }

      setState(() {});
    });

    // Initialize device info
    _deviceInfo = {
      'ram': '8 GB',
      'cpu': 'Snapdragon 888',
      'battery': 85,
      'gpuAcceleration': true,
      'aiModel': 'GPT-4 Vision',
    };

    _processingMode = kIsWeb ? 'Web + OpenAI' : 'Mobile + OpenAI';
  }

  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startRealProcessing() async {
    if (_videoQueue.isEmpty) {
      _showError('Aucune vidéo à traiter');
      return;
    }

    try {
      final videoData = _videoQueue.first;
      final videoFile = videoData['file'] as File?;

      if (videoFile == null) {
        _showError('Fichier vidéo non trouvé');
        return;
      }

      setState(() {
        _currentStatus = 'Démarrage de l\'analyse avec OpenAI...';
        _totalFrames = videoData['frames'] ?? 5400;
      });

      // Start real video analysis
      _analysisResult = await _analysisService.analyzeVideo(
        videoFile: videoFile,
        onStatusUpdate: (status) {
          setState(() {
            if (_currentStatus != status) {
              if (_currentStatus.isNotEmpty) {
                _statusHistory.add(_currentStatus);
              }
              _currentStatus = status;
            }
          });
        },
        onProgressUpdate: (progress) {
          setState(() {
            _progress = (progress * 100).clamp(0, 100);
            _currentFrame = (_totalFrames * progress).round();

            // Update advanced metrics based on actual analysis
            if (_analysisResult != null) {
              _detectedTextRegions = _analysisResult!.codeBlocks.length;
              _confidenceScore = _analysisResult!.codeBlocks.isNotEmpty
                  ? _analysisResult!.codeBlocks
                          .map((block) => block.confidence)
                          .reduce((a, b) => a + b) /
                      _analysisResult!.codeBlocks.length
                  : 0.0;
            }

            // Calculate estimated time
            final remainingProgress = 1.0 - progress;
            final estimatedSeconds =
                (remainingProgress * 120).round(); // Rough estimate
            _estimatedTime =
                '${(estimatedSeconds / 60).floor()}:${(estimatedSeconds % 60).toString().padLeft(2, '0')}';
          });
        },
      );

      if (!_isCancelled) {
        _completeProcessing();
      }
    } catch (e) {
      if (!_isCancelled) {
        _showError('Erreur lors de l\'analyse: $e');
      }
    }
  }

  void _completeProcessing() {
    setState(() {
      _isProcessing = false;
      _progress = 100;
      _currentFrame = _totalFrames;
      _estimatedTime = '0:00';
      _statusHistory.add(_currentStatus);
      _currentStatus = 'Analyse terminée avec succès !';
    });

    // Navigate to results after a brief delay
    Timer(const Duration(seconds: 1), () {
      if (mounted && !_isCancelled && _analysisResult != null) {
        Navigator.pushReplacementNamed(
          context,
          '/code-extraction-results',
          arguments: {
            'analysisResult': _analysisResult,
            'videoInfo': _videoQueue.first,
            'processingStats': {
              'totalFrames': _totalFrames,
              'detectedRegions': _detectedTextRegions,
              'confidenceScore': _confidenceScore,
              'processingTime': _formatDuration(_analysisResult!
                  .analysisTimestamp
                  .difference(DateTime.now())
                  .abs()),
            },
          },
        );
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showError(String message) {
    setState(() {
      _isProcessing = false;
      _currentStatus = 'Erreur: $message';
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur de traitement'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/home-dashboard');
            },
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.getStatusColor('warning', isLight: true),
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Annuler le traitement',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Êtes-vous sûr de vouloir annuler le traitement en cours ? Tout le progrès sera perdu.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continuer',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelProcessing();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppTheme.getStatusColor('error', isLight: true),
              ),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _cancelProcessing() {
    setState(() {
      _isCancelled = true;
      _isProcessing = false;
    });

    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: _backgroundAnimation.value,
                colors: [
                  AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Main content
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Processing animation
                          ProcessingAnimationWidget(
                            videoThumbnail: _videoQueue.isNotEmpty
                                ? _videoQueue.first['thumbnail']
                                : null,
                            progress: _progress,
                            statusText: _currentStatus,
                          ),

                          SizedBox(height: 4.h),

                          // Progress indicator
                          ProgressIndicatorWidget(
                            progress: _progress,
                            estimatedTime: _estimatedTime,
                            currentFrame: _currentFrame,
                            totalFrames: _totalFrames,
                          ),

                          SizedBox(height: 3.h),

                          // Status text
                          StatusTextWidget(
                            currentStatus: _currentStatus,
                            statusHistory: _statusHistory,
                          ),

                          SizedBox(height: 3.h),

                          // Processing queue (if multiple videos)
                          ProcessingQueueWidget(
                            currentVideoIndex: _currentVideoIndex,
                            totalVideos: _totalVideos,
                            videoQueue: _videoQueue,
                          ),

                          SizedBox(height: 3.h),

                          // Advanced details
                          AdvancedDetailsWidget(
                            frameRate: _frameRate,
                            detectedTextRegions: _detectedTextRegions,
                            confidenceScore: _confidenceScore,
                            processingMode: _processingMode,
                            deviceInfo: _deviceInfo,
                          ),

                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),

                  // Cancel button
                  Positioned(
                    top: 2.h,
                    right: 4.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _isProcessing ? _showCancelDialog : null,
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: _isProcessing
                              ? AppTheme.getStatusColor('error', isLight: true)
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 24,
                        ),
                        tooltip: 'Annuler le traitement',
                      ),
                    ),
                  ),

                  // Processing status indicator
                  if (_isProcessing)
                    Positioned(
                      top: 2.h,
                      left: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 4.w,
                              height: 4.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.surface,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'IA Active',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
