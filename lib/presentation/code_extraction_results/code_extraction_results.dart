import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/video_analysis_service.dart';
import './widgets/action_toolbar_widget.dart';
import './widgets/code_editor_widget.dart';
import './widgets/video_thumbnail_widget.dart';

class CodeExtractionResults extends StatefulWidget {
  const CodeExtractionResults({Key? key}) : super(key: key);

  @override
  State<CodeExtractionResults> createState() => _CodeExtractionResultsState();
}

class _CodeExtractionResultsState extends State<CodeExtractionResults> {
  bool _isEditMode = false;
  int _currentBlockIndex = 0;
  bool _canUndo = false;
  bool _canRedo = false;
  List<String> _undoStack = [];
  List<String> _redoStack = [];

  // Data from OpenAI analysis
  VideoAnalysisResult? _analysisResult;
  List<Map<String, dynamic>> _codeBlocks = [];
  String _videoThumbnail = "";

  List<Map<String, dynamic>> get _detectedRegions {
    return _codeBlocks.map((block) {
      // Create mock regions for display - in real implementation,
      // these would come from frame analysis
      return {
        "x": 0.1 + (_codeBlocks.indexOf(block) * 0.1),
        "y": 0.2,
        "width": 0.8,
        "height": 0.3
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadAnalysisResults();
  }

  void _loadAnalysisResults() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args['analysisResult'] != null) {
        _analysisResult = args['analysisResult'] as VideoAnalysisResult;
        _videoThumbnail = args['videoInfo']['thumbnail'] ?? "";

        // Convert OpenAI analysis results to UI format
        _codeBlocks = _analysisResult!.codeBlocks
            .map((block) => {
                  "id": block.id,
                  "timestamp": block.formattedTimestamp,
                  "confidence": block.confidence,
                  "code": block.code,
                  "syntaxErrors": <int>[], // Would be analyzed separately
                  "region": {"x": 0.1, "y": 0.2, "width": 0.8, "height": 0.3}
                })
            .toList();

        // Initialize undo stack with current code
        if (_codeBlocks.isNotEmpty) {
          _undoStack.add(_codeBlocks[_currentBlockIndex]['code'] as String);
        }

        setState(() {});
      } else {
        // Fallback to mock data if no analysis result
        _loadMockData();
      }
    });
  }

  void _loadMockData() {
    // Fallback mock data
    _codeBlocks = [
      {
        "id": 1,
        "timestamp": "00:15",
        "confidence": 0.92,
        "code": """def fibonacci(n):
    if n <= 1:
        return n
    else:
        return fibonacci(n-1) + fibonacci(n-2)

# Calcul des 10 premiers nombres de Fibonacci
for i in range(10):
    print(f"F({i}) = {fibonacci(i)}")""",
        "syntaxErrors": <int>[],
        "region": {"x": 0.1, "y": 0.2, "width": 0.8, "height": 0.3}
      }
    ];

    _videoThumbnail =
        "https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";

    if (_codeBlocks.isNotEmpty) {
      _undoStack.add(_codeBlocks[_currentBlockIndex]['code'] as String);
    }

    setState(() {});
  }

  void _onRegionTap(int regionIndex) {
    setState(() {
      _currentBlockIndex = regionIndex;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Show snackbar with region info
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation vers le bloc de code ${regionIndex + 1}'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onCodeChanged(String newCode) {
    if (_isEditMode) {
      // Add current state to undo stack before making changes
      final currentCode = _codeBlocks[_currentBlockIndex]['code'] as String;
      if (_undoStack.isEmpty || _undoStack.last != currentCode) {
        _undoStack.add(currentCode);
        _redoStack.clear(); // Clear redo stack when new changes are made
      }

      setState(() {
        _codeBlocks[_currentBlockIndex]['code'] = newCode;
        _canUndo = _undoStack.isNotEmpty;
        _canRedo = _redoStack.isNotEmpty;
      });
    }
  }

  void _onBlockChanged(int newIndex) {
    setState(() {
      _currentBlockIndex = newIndex;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isEditMode ? 'Mode édition activé' : 'Mode lecture activé'),
        backgroundColor: _isEditMode
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _undo() {
    if (_undoStack.isNotEmpty && _isEditMode) {
      final currentCode = _codeBlocks[_currentBlockIndex]['code'] as String;
      _redoStack.add(currentCode);

      final previousCode = _undoStack.removeLast();
      setState(() {
        _codeBlocks[_currentBlockIndex]['code'] = previousCode;
        _canUndo = _undoStack.isNotEmpty;
        _canRedo = _redoStack.isNotEmpty;
      });

      HapticFeedback.lightImpact();
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty && _isEditMode) {
      final currentCode = _codeBlocks[_currentBlockIndex]['code'] as String;
      _undoStack.add(currentCode);

      final nextCode = _redoStack.removeLast();
      setState(() {
        _codeBlocks[_currentBlockIndex]['code'] = nextCode;
        _canUndo = _undoStack.isNotEmpty;
        _canRedo = _redoStack.isNotEmpty;
      });

      HapticFeedback.lightImpact();
    }
  }

  void _shareResults() {
    Navigator.pushNamed(context, '/home-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Résultats d\'extraction IA',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareResults,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Video thumbnail with detected regions
            if (_videoThumbnail.isNotEmpty)
              VideoThumbnailWidget(
                videoThumbnail: _videoThumbnail,
                detectedRegions: _detectedRegions,
                onRegionTap: _onRegionTap,
              ),

            SizedBox(height: 2.h),

            // Code extraction summary
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'analytics',
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_codeBlocks.length} blocs de code détectés par IA',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _codeBlocks.isNotEmpty
                              ? 'Confiance moyenne: ${(_codeBlocks.map((b) => b['confidence'] as double).reduce((a, b) => a + b) / _codeBlocks.length * 100).toInt()}%'
                              : 'Aucun code détecté',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'OpenAI',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Code editor
            Expanded(
              child: _codeBlocks.isNotEmpty
                  ? CodeEditorWidget(
                      codeBlocks: _codeBlocks,
                      currentBlockIndex: _currentBlockIndex,
                      isEditMode: _isEditMode,
                      onCodeChanged: _onCodeChanged,
                      onBlockChanged: _onBlockChanged,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'code',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 12.w,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Aucun code Python détecté',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'L\'IA n\'a pas trouvé de code dans cette vidéo',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),

            // Action toolbar
            if (_codeBlocks.isNotEmpty)
              ActionToolbarWidget(
                codeBlocks: _codeBlocks,
                isEditMode: _isEditMode,
                onEditModeToggle: _toggleEditMode,
                onUndo: _undo,
                onRedo: _redo,
                canUndo: _canUndo,
                canRedo: _canRedo,
              ),
          ],
        ),
      ),
    );
  }
}
