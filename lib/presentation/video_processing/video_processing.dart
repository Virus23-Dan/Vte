import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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
  Timer? _processingTimer;
  Timer? _progressTimer;
  
  // Queue data
  int _currentVideoIndex = 1;
  int _totalVideos = 1;
  List<Map<String, dynamic>> _videoQueue = [];
  
  // Advanced details
  double _frameRate = 30.0;
  int _detectedTextRegions = 0;
  double _confidenceScore = 0.0;
  String _processingMode = 'Standard';
  Map<String, dynamic> _deviceInfo = {};
  
  // Mock video data
  final List<Map<String, dynamic>> _mockVideoData = [
    { 
      'name': 'python_tutorial_1.mp4',
      'thumbnail': 'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'duration': 180, // seconds 
      'frames': 5400, // 30fps * 180s 
    },
    { 
      'name': 'code_review_session.mp4',
      'thumbnail': 'https://images.pexels.com/photos/574071/pexels-photo-574071.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'duration': 240,
      'frames': 7200,
    },
    { 
      'name': 'algorithm_explanation.mp4',
      'thumbnail': 'https://images.pexels.com/photos/1181263/pexels-photo-1181263.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'duration': 300,
      'frames': 9000,
    },
  ];

  final List<String> _processingSteps = [
    'Initialisation...',
    'Analyse des images...',
    'Détection des blocs de code...',
    'Extraction de la syntaxe Python...',
    'Finalisation...',
  ];

  @override
  void initState() {
    super.initState();
    _initializeProcessing();
    _setupAnimations();
    _startProcessingSimulation();
  }

  void _initializeProcessing() {
    // Get arguments from navigation (if any)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      if (args != null) {
        _totalVideos = args['videoCount'] ?? 1;
        _videoQueue = args['videoQueue'] ?? [_mockVideoData.first];
      } else {
        _videoQueue = [_mockVideoData.first];
      }
      
      final currentVideo = _videoQueue.first;
      _totalFrames = currentVideo['frames'] ?? 5400;
      
      setState(() {});
    });
    
    // Initialize device info
    _deviceInfo = {
      'ram': '8 GB',
      'cpu': 'Snapdragon 888',
      'battery': 85,
      'gpuAcceleration': true,
    };
    
    _processingMode = kIsWeb ? 'Web Optimisé' : 'Mobile Standard';
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

  void _startProcessingSimulation() {
    int stepIndex = 0;
    int frameProcessed = 0;
    final random = Random();
    
    _processingTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_isCancelled || !_isProcessing) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (stepIndex < _processingSteps.length) {
          if (_currentStatus != _processingSteps[stepIndex]) {
            if (_currentStatus.isNotEmpty && _currentStatus != 'Initialisation...') {
              _statusHistory.add(_currentStatus);
            }
            _currentStatus = _processingSteps[stepIndex];
          }
          
          // Simulate frame processing
          if (stepIndex >= 1 && stepIndex <= 3) {
            frameProcessed += random.nextInt(50) + 20;
            _currentFrame = frameProcessed.clamp(0, _totalFrames);
            _progress = (_currentFrame / _totalFrames * 100).clamp(0, 100);
            
            // Update advanced metrics
            _detectedTextRegions = random.nextInt(15) + 5;
            _confidenceScore = (random.nextDouble() * 0.4 + 0.6).clamp(0.0, 1.0);
            
            // Calculate estimated time
            final remainingFrames = _totalFrames - _currentFrame;
            final estimatedSeconds = (remainingFrames / 45).round();
            _estimatedTime = '${(estimatedSeconds / 60).floor()}:${(estimatedSeconds % 60).toString().padLeft(2, '0')}';
          }
          
          if (_progress >= 100 || stepIndex >= _processingSteps.length - 1) {
            stepIndex = _processingSteps.length - 1;
            _progress = 100;
            _currentFrame = _totalFrames;
            _estimatedTime = '0:00';
            
            // Complete processing
            Timer(const Duration(seconds: 2), () {
              if (!_isCancelled) {
                _completeProcessing();
              }
            });
            timer.cancel();
          } else {
            if (random.nextBool()) {
              stepIndex++;
            }
          }
        }
      });
    });
  }

  void _completeProcessing() {
    setState(() {
      _isProcessing = false;
      _statusHistory.add(_currentStatus);
      _currentStatus = 'Traitement terminé avec succès !';
    });
    
    // Navigate to results after a brief delay
    Timer(const Duration(seconds: 1), () {
      if (mounted && !_isCancelled) {
        Navigator.pushReplacementNamed(
          context,
          '/code-extraction-results',
          arguments: {
            'extractedCode': _generateMockExtractedCode(),
            'videoInfo': _videoQueue.first,
            'processingStats': {
              'totalFrames': _totalFrames,
              'detectedRegions': _detectedTextRegions,
              'confidenceScore': _confidenceScore,
              'processingTime': '2:34',
            },
          },
        );
      }
    });
  }

  String _generateMockExtractedCode() {
    return '''def fibonacci(n):
    """
    Calcule la séquence de Fibonacci jusqu'à n termes
    """
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    
    sequence = [0, 1]
    for i in range(2, n):
        sequence.append(sequence[i-1] + sequence[i-2])
    
    return sequence

# Exemple d'utilisation
result = fibonacci(10)
print(f"Les 10 premiers nombres de Fibonacci: {result}")

# Fonction pour vérifier si un nombre est premier
def is_prime(num):
    if num < 2:
        return False
    for i in range(2, int(num ** 0.5) + 1):
        if num % i == 0:
            return False
    return True

# Trouver tous les nombres premiers jusqu'à 100
primes = [num for num in range(2, 101) if is_prime(num)]
print(f"Nombres premiers jusqu'à 100: {primes}")''';
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
                backgroundColor: AppTheme.getStatusColor('error', isLight: true),
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
    
    _processingTimer?.cancel();
    _progressTimer?.cancel();
    
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _processingTimer?.cancel();
    _progressTimer?.cancel();
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
                  AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
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
                        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
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
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.9),
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
                              'Traitement actif',
                              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
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