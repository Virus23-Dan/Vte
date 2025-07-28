import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import './openai_service.dart';

class VideoAnalysisService {
  static final VideoAnalysisService _instance =
      VideoAnalysisService._internal();
  factory VideoAnalysisService() => _instance;
  VideoAnalysisService._internal();

  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);

  /// Analyzes a video file and extracts Python code using OpenAI Vision API
  Future<VideoAnalysisResult> analyzeVideo({
    required File videoFile,
    Function(String)? onStatusUpdate,
    Function(double)? onProgressUpdate,
  }) async {
    try {
      onStatusUpdate?.call('Initialisation de l\'analyse vidéo...');

      final VideoPlayerController controller =
          VideoPlayerController.file(videoFile);
      await controller.initialize();

      final duration = controller.value.duration;
      final totalFrames = (duration.inSeconds * 30).toInt(); // Assuming 30fps

      onStatusUpdate?.call('Extraction des images clés...');

      // Extract frames at key intervals (every 5 seconds)
      final List<VideoFrame> extractedFrames = [];
      final frameInterval = Duration(seconds: 5);

      for (int i = 0; i < duration.inSeconds; i += frameInterval.inSeconds) {
        final timestamp = Duration(seconds: i);
        await controller.seekTo(timestamp);

        // Wait for seek to complete
        await Future.delayed(Duration(milliseconds: 500));

        final frameBytes = await _captureFrame(controller);
        if (frameBytes != null) {
          extractedFrames.add(VideoFrame(
            timestamp: timestamp,
            imageBytes: frameBytes,
          ));
        }

        onProgressUpdate?.call((i / duration.inSeconds) *
            0.5); // 50% progress for frame extraction
      }

      controller.dispose();

      onStatusUpdate?.call('Analyse des images avec OpenAI...');

      // Analyze each frame for Python code
      final List<CodeBlock> detectedCodeBlocks = [];

      for (int i = 0; i < extractedFrames.length; i++) {
        final frame = extractedFrames[i];

        try {
          final result = await _openAIClient.generateTextFromImage(
            imageBytes: frame.imageBytes,
            promptText:
                '''Analyze this video frame image carefully. If you can see any Python code in the image, extract it exactly as shown. 
            Return only the Python code that is visible, properly formatted. If no Python code is visible, return "NO_CODE_FOUND".
            Pay attention to:
            - Function definitions
            - Class declarations  
            - Import statements
            - Variable assignments
            - Comments
            - Control structures (if, for, while, etc.)
            
            Format the code exactly as it appears in the image, maintaining proper indentation and syntax.''',
          );

          final extractedCode = result.text.trim();

          if (extractedCode.isNotEmpty && extractedCode != "NO_CODE_FOUND") {
            // Calculate confidence score based on code structure
            final confidence = _calculateConfidenceScore(extractedCode);

            detectedCodeBlocks.add(CodeBlock(
              id: detectedCodeBlocks.length + 1,
              timestamp: frame.timestamp,
              code: extractedCode,
              confidence: confidence,
              frame: frame,
            ));
          }
        } catch (e) {
          debugPrint('Error analyzing frame at ${frame.timestamp}: $e');
          // Continue with next frame
        }

        onProgressUpdate?.call(
            0.5 + (i / extractedFrames.length) * 0.5); // Remaining 50% progress
      }

      onStatusUpdate?.call('Finalisation de l\'analyse...');

      return VideoAnalysisResult(
        videoFile: videoFile,
        duration: duration,
        totalFrames: totalFrames,
        extractedFrames: extractedFrames,
        codeBlocks: detectedCodeBlocks,
        analysisTimestamp: DateTime.now(),
      );
    } catch (e) {
      throw VideoAnalysisException('Erreur lors de l\'analyse vidéo: $e');
    }
  }

  /// Captures a frame from video controller
  Future<Uint8List?> _captureFrame(VideoPlayerController controller) async {
    try {
      // This is a simplified implementation
      // In a real scenario, you would need to use platform-specific methods
      // to capture actual video frames

      if (kIsWeb) {
        // Web implementation would require different approach
        return null;
      } else {
        // For mobile, you would use platform channels or video_thumbnail package
        // This is a placeholder implementation
        return null;
      }
    } catch (e) {
      debugPrint('Error capturing frame: $e');
      return null;
    }
  }

  /// Calculates confidence score based on code structure
  double _calculateConfidenceScore(String code) {
    double score = 0.0;

    // Check for Python keywords
    final pythonKeywords = [
      'def ',
      'class ',
      'import ',
      'from ',
      'if ',
      'for ',
      'while ',
      'try:',
      'except:',
      'return'
    ];
    for (final keyword in pythonKeywords) {
      if (code.contains(keyword)) {
        score += 0.1;
      }
    }

    // Check for proper indentation
    final lines = code.split('\n');
    bool hasIndentation =
        lines.any((line) => line.startsWith('    ') || line.startsWith('\t'));
    if (hasIndentation) score += 0.2;

    // Check for function/class structure
    if (code.contains('def ') && code.contains(':')) score += 0.15;
    if (code.contains('class ') && code.contains(':')) score += 0.15;

    // Check for comments
    if (code.contains('#')) score += 0.1;

    return (score).clamp(0.0, 1.0);
  }

  /// Alternative analysis using image picker for testing
  Future<CodeBlock?> analyzeImageForCode({
    required Uint8List imageBytes,
    String? customPrompt,
  }) async {
    try {
      final result = await _openAIClient.generateTextFromImage(
        imageBytes: imageBytes,
        promptText: customPrompt ??
            '''Extract any Python code visible in this image. 
        Return only the code that is clearly visible, properly formatted with correct indentation.
        If no Python code is visible, return "NO_CODE_FOUND".''',
      );

      final extractedCode = result.text.trim();

      if (extractedCode.isNotEmpty && extractedCode != "NO_CODE_FOUND") {
        return CodeBlock(
          id: 1,
          timestamp: Duration.zero,
          code: extractedCode,
          confidence: _calculateConfidenceScore(extractedCode),
          frame: VideoFrame(
            timestamp: Duration.zero,
            imageBytes: imageBytes,
          ),
        );
      }

      return null;
    } catch (e) {
      throw VideoAnalysisException('Erreur lors de l\'analyse d\'image: $e');
    }
  }
}

class VideoAnalysisResult {
  final File videoFile;
  final Duration duration;
  final int totalFrames;
  final List<VideoFrame> extractedFrames;
  final List<CodeBlock> codeBlocks;
  final DateTime analysisTimestamp;

  VideoAnalysisResult({
    required this.videoFile,
    required this.duration,
    required this.totalFrames,
    required this.extractedFrames,
    required this.codeBlocks,
    required this.analysisTimestamp,
  });
}

class VideoFrame {
  final Duration timestamp;
  final Uint8List imageBytes;

  VideoFrame({
    required this.timestamp,
    required this.imageBytes,
  });
}

class CodeBlock {
  final int id;
  final Duration timestamp;
  final String code;
  final double confidence;
  final VideoFrame frame;

  CodeBlock({
    required this.id,
    required this.timestamp,
    required this.code,
    required this.confidence,
    required this.frame,
  });

  String get formattedTimestamp {
    final minutes = timestamp.inMinutes;
    final seconds = timestamp.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class VideoAnalysisException implements Exception {
  final String message;
  VideoAnalysisException(this.message);

  @override
  String toString() => 'VideoAnalysisException: $message';
}
