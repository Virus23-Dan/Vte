import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/video_analysis_service.dart';
import './widgets/empty_gallery_widget.dart';
import './widgets/large_file_warning_widget.dart';
import './widgets/processing_queue_widget.dart';
import './widgets/video_context_menu_widget.dart';
import './widgets/video_grid_item_widget.dart';
import './widgets/video_search_bar_widget.dart';

class VideoUpload extends StatefulWidget {
  const VideoUpload({super.key});

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;

  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  bool _showLargeFileWarning = false;
  String _selectedLargeFile = '';
  String _selectedLargeFileSize = '';

  List<String> _selectedVideoIds = [];
  List<Map<String, dynamic>> _allVideos = [];
  List<Map<String, dynamic>> _filteredVideos = [];
  List<Map<String, dynamic>> _recentVideos = [];
  List<Map<String, dynamic>> _processingVideos = [];

  OverlayEntry? _contextMenuOverlay;

  List<Map<String, dynamic>> _uploadedVideos = [];
  String _searchQuery = '';

  // Selection state
  bool _isSelectionMode = false;
  Set<int> _selectedVideoIdsSet = {};

  // Upload state
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  // Animation controllers
  late AnimationController _fabController;
  late AnimationController _listController;
  late Animation<double> _fabAnimation;
  late Animation<Offset> _listAnimation;

  // Services
  final VideoAnalysisService _analysisService = VideoAnalysisService();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUploadedVideos();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> _setupAnimations() async {
    _fabController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _listController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _fabAnimation =
        CurvedAnimation(parent: _fabController, curve: Curves.easeInOut);
    _listAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _listController, curve: Curves.easeInOut));
  }

  Future<void> _loadUploadedVideos() async {
    // Load uploaded videos from local storage or database
    // For now, just simulate loading
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _filteredVideos = List.from(_uploadedVideos);
    });
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
          await _cameraController!.initialize();
          await _applySettings();
        }
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported
        }
      }
    } catch (e) {
      // Settings not supported
    }
  }

  void _initializeData() {
    _allVideos = [
      {
        'id': '1',
        'name': 'Tutorial_Python_Basics.mp4',
        'thumbnail':
            'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=800',
        'duration': '15:32',
        'fileSize': '45 MB',
        'resolution': '1920x1080',
        'format': 'MP4',
        'date': '28/07/2025',
      },
      {
        'id': '2',
        'name': 'Django_Models_Demo.mov',
        'thumbnail':
            'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&w=800',
        'duration': '08:45',
        'fileSize': '32 MB',
        'resolution': '1280x720',
        'format': 'MOV',
        'date': '27/07/2025',
      },
      {
        'id': '3',
        'name': 'Flask_API_Tutorial.avi',
        'thumbnail':
            'https://images.pexels.com/photos/1181263/pexels-photo-1181263.jpeg?auto=compress&cs=tinysrgb&w=800',
        'duration': '22:18',
        'fileSize': '78 MB',
        'resolution': '1920x1080',
        'format': 'AVI',
        'date': '26/07/2025',
      },
      {
        'id': '4',
        'name': 'Machine_Learning_Code.mp4',
        'thumbnail':
            'https://images.pexels.com/photos/1181354/pexels-photo-1181354.jpeg?auto=compress&cs=tinysrgb&w=800',
        'duration': '35:12',
        'fileSize': '156 MB',
        'resolution': '1920x1080',
        'format': 'MP4',
        'date': '25/07/2025',
      },
      {
        'id': '5',
        'name': 'Data_Analysis_Pandas.mp4',
        'thumbnail':
            'https://images.pexels.com/photos/1181467/pexels-photo-1181467.jpeg?auto=compress&cs=tinysrgb&w=800',
        'duration': '18:56',
        'fileSize': '67 MB',
        'resolution': '1280x720',
        'format': 'MP4',
        'date': '24/07/2025',
      },
      {
        'id': '6',
        'name': 'Web_Scraping_BeautifulSoup.mov',
        'thumbnail':
            'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg?auto=compress&cs=tinysrgb&w=800',
        'duration': '12:34',
        'fileSize': '41 MB',
        'resolution': '1920x1080',
        'format': 'MOV',
        'date': '23/07/2025',
      },
    ];

    _recentVideos = [
      {
        'id': 'r1',
        'name': 'Python_OOP_Concepts.mp4',
        'thumbnail':
            'https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?auto=compress&cs=tinysrgb&w=800',
        'processedDate': '22/07/2025',
        'extractedLines': 45,
      },
      {
        'id': 'r2',
        'name': 'NumPy_Arrays_Tutorial.mov',
        'thumbnail':
            'https://images.pexels.com/photos/1181316/pexels-photo-1181316.jpeg?auto=compress&cs=tinysrgb&w=800',
        'processedDate': '21/07/2025',
        'extractedLines': 32,
      },
    ];

    _processingVideos = [
      {
        'id': 'p1',
        'name': 'Advanced_Python_Decorators.mp4',
        'thumbnail':
            'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=800',
        'progress': 65.0,
        'status': 'Extraction du code en cours...',
      },
    ];

    _filteredVideos = List.from(_allVideos);
  }

  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVideos = List.from(_allVideos);
      } else {
        _filteredVideos = _allVideos.where((video) {
          final name = (video['name'] as String).toLowerCase();
          final date = (video['date'] as String).toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) || date.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterVideos('');
  }

  void _toggleVideoSelection(String videoId) {
    setState(() {
      if (_selectedVideoIdsSet.contains(videoId)) {
        _selectedVideoIdsSet.remove(videoId);
      } else {
        _selectedVideoIdsSet.add(videoId);
      }

      if (_selectedVideoIdsSet.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedVideoIdsSet.clear();
      }
    });
  }

  void _onVideoTap(Map<String, dynamic> video) {
    if (_isMultiSelectMode) {
      _toggleVideoSelection(video['id'] as String);
    } else {
      _previewVideo(video);
    }
  }

  void _onVideoLongPress(Map<String, dynamic> video, Offset position) {
    _showContextMenu(video, position);
  }

  void _showContextMenu(Map<String, dynamic> video, Offset position) {
    _contextMenuOverlay?.remove();

    _contextMenuOverlay = OverlayEntry(
        builder: (context) => Positioned(
            left: position.dx - 100,
            top: position.dy - 50,
            child: Material(
                color: Colors.transparent,
                child: VideoContextMenuWidget(
                    video: video,
                    onPreview: () {
                      _contextMenuOverlay?.remove();
                      _previewVideo(video);
                    },
                    onDetails: () {
                      _contextMenuOverlay?.remove();
                      _showVideoDetails(video);
                    },
                    onShare: () {
                      _contextMenuOverlay?.remove();
                      _shareVideo(video);
                    },
                    onRemove: () {
                      _contextMenuOverlay?.remove();
                      _removeFromRecent(video);
                    }))));

    Overlay.of(context).insert(_contextMenuOverlay!);
  }

  void _previewVideo(Map<String, dynamic> video) {
    Navigator.pushNamed(context, '/video-processing');
  }

  void _showVideoDetails(Map<String, dynamic> video) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Détails de la vidéo'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nom: ${video['name']}'),
                      SizedBox(height: 8),
                      Text('Durée: ${video['duration']}'),
                      SizedBox(height: 8),
                      Text('Taille: ${video['fileSize']}'),
                      SizedBox(height: 8),
                      Text('Résolution: ${video['resolution']}'),
                      SizedBox(height: 8),
                      Text('Format: ${video['format']}'),
                      SizedBox(height: 8),
                      Text('Date: ${video['date']}'),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Fermer')),
                ]));
  }

  void _shareVideo(Map<String, dynamic> video) {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Partage de ${video['name']}')));
  }

  void _removeFromRecent(Map<String, dynamic> video) {
    setState(() {
      _recentVideos.removeWhere((v) => v['id'] == video['id']);
    });
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final XFile? video =
          await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        await _processSelectedVideo(video.path, video.name);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection de la vidéo')));
    }
  }

  Future<void> _pickVideoFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.video, allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileSizeInMB = (file.size / (1024 * 1024));

        if (fileSizeInMB > 100) {
          setState(() {
            _showLargeFileWarning = true;
            _selectedLargeFile = file.name;
            _selectedLargeFileSize = '${fileSizeInMB.toStringAsFixed(1)} MB';
          });
        } else {
          await _processSelectedVideo(file.path ?? '', file.name);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection du fichier')));
    }
  }

  Future<void> _processSelectedVideo(String path, String name) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate processing
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, '/video-processing');
  }

  Future<void> _recordVideo() async {
    try {
      final XFile? video =
          await _imagePicker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        await _processSelectedVideo(video.path, video.name);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement')));
    }
  }

  void _processSelectedVideos() {
    if (_selectedVideoIds.isEmpty) return;

    Navigator.pushNamed(context, '/video-processing');
  }

  void _onCancelProcessing(String videoId) {
    setState(() {
      _processingVideos.removeWhere((video) => video['id'] == videoId);
    });
  }

  Future<void> _refreshGallery() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _handleLargeFileCompress() {
    setState(() {
      _showLargeFileWarning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Compression de $_selectedLargeFile en cours...')));
  }

  void _handleLargeFileProceed() {
    setState(() {
      _showLargeFileWarning = false;
    });

    Navigator.pushNamed(context, '/video-processing');
  }

  void _handleLargeFileCancel() {
    setState(() {
      _showLargeFileWarning = false;
      _selectedLargeFile = '';
      _selectedLargeFileSize = '';
    });
  }

  /// Enhanced video upload with real file handling
  Future<void> _uploadVideoFromGallery() async {
    try {
      // Request permissions
      if (!kIsWeb) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          _showErrorMessage('Permission de stockage refusée');
          return;
        }
      }

      // Pick video file
      final XFile? videoFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10), // Limit video length
      );

      if (videoFile != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0.0;
        });

        // Simulate upload progress
        for (int i = 0; i <= 100; i += 10) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            _uploadProgress = i / 100.0;
          });
        }

        // Get file info
        final file = File(videoFile.path);
        final fileSize = await file.length();
        final fileName = videoFile.name;

        // Check file size (limit to 100MB)
        if (fileSize > 100 * 1024 * 1024) {
          _showLargeFileWarningDialog(fileName, fileSize);
          setState(() {
            _isUploading = false;
          });
          return;
        }

        // Add to uploaded videos list
        final videoData = {
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': fileName,
          'file': file,
          'path': videoFile.path,
          'size': fileSize,
          'duration': 120, // Would be calculated from actual video
          'frames': 3600, // Would be calculated from actual video
          'thumbnail': await _generateThumbnail(file),
          'uploadDate': DateTime.now(),
          'isProcessed': false,
        };

        setState(() {
          _uploadedVideos.insert(0, videoData);
          _filteredVideos = List.from(_uploadedVideos);
          _isUploading = false;
        });

        _showSuccessMessage('Vidéo ajoutée avec succès');
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorMessage('Erreur lors de l\'ajout de la vidéo: $e');
    }
  }

  /// Record video with camera
  Future<void> _recordVideoFromCamera() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      final microphoneStatus = await Permission.microphone.request();

      if (!cameraStatus.isGranted || !microphoneStatus.isGranted) {
        _showErrorMessage('Permissions caméra et microphone requises');
        return;
      }

      // Record video
      final XFile? videoFile = await _imagePicker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(minutes: 5));

      if (videoFile != null) {
        // Process the recorded video same as uploaded video
        await _processRecordedVideo(videoFile);
      }
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'enregistrement: $e');
    }
  }

  /// Upload video from file system
  Future<void> _uploadFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.video, allowMultiple: true);

      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (file.path != null) {
            final videoFile = File(file.path!);
            await _processUploadedFile(videoFile, file.name);
          }
        }
      }
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'importation: $e');
    }
  }

  /// Generate thumbnail for video (placeholder implementation)
  Future<String> _generateThumbnail(File videoFile) async {
    // In a real implementation, you would extract actual thumbnail
    // For now, return a placeholder image
    return 'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  }

  /// Process recorded video
  Future<void> _processRecordedVideo(XFile videoFile) async {
    final file = File(videoFile.path);
    await _processUploadedFile(file, videoFile.name);
  }

  /// Process uploaded file
  Future<void> _processUploadedFile(File file, String fileName) async {
    final fileSize = await file.length();

    final videoData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': fileName,
      'file': file,
      'path': file.path,
      'size': fileSize,
      'duration': 120,
      'frames': 3600,
      'thumbnail': await _generateThumbnail(file),
      'uploadDate': DateTime.now(),
      'isProcessed': false,
    };

    setState(() {
      _uploadedVideos.insert(0, videoData);
      _filteredVideos = List.from(_uploadedVideos);
    });
  }

  /// Start processing selected videos with OpenAI
  void _startProcessingSelected() {
    if (_selectedVideoIds.isEmpty) return;

    final selectedVideos = _uploadedVideos
        .where((video) => _selectedVideoIds.contains(video['id']))
        .toList();

    // Navigate to processing screen with real video files
    Navigator.pushNamed(context, '/video-processing', arguments: {
      'videoCount': selectedVideos.length,
      'videoQueue': selectedVideos,
    });
  }

  /// Test OpenAI integration with image
  Future<void> _testImageAnalysis() async {
    try {
      final XFile? imageFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        final imageBytes = await imageFile.readAsBytes();

        _showLoadingDialog('Analyse en cours avec OpenAI...');

        final result =
            await _analysisService.analyzeImageForCode(imageBytes: imageBytes);

        Navigator.pop(context); // Close loading dialog

        if (result != null) {
          _showCodeResultDialog(result.code);
        } else {
          _showErrorMessage('Aucun code Python détecté dans l\'image');
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if open
      _showErrorMessage('Erreur lors de l\'analyse: $e');
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                content: Row(children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ])));
  }

  void _showCodeResultDialog(String code) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Code détecté par OpenAI'),
                content: Container(
                    width: double.maxFinite,
                    height: 300,
                    child: SingleChildScrollView(
                        child: SelectableText(code,
                            style: const TextStyle(fontFamily: 'monospace')))),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fermer')),
                  ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        Navigator.pop(context);
                        _showSuccessMessage('Code copié dans le presse-papier');
                      },
                      child: const Text('Copier')),
                ]));
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating));
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  }

  void _showLargeFileWarningDialog(String fileName, int fileSize) {
    showDialog(
        context: context,
        builder: (context) => LargeFileWarningWidget(
            fileName: fileName,
            fileSize: fileSize.toString(),
            onCancel: () => Navigator.pop(context),
            onCompress: () {
              Navigator.pop(context);
              _handleLargeFileCompress();
            },
            onProceedAnyway: () {
              Navigator.pop(context);
              _handleLargeFileProceed();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: Text(
                _isSelectionMode
                    ? '${_selectedVideoIdsSet.length} sélectionnée(s)'
                    : 'Mes vidéos',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            leading: _isSelectionMode
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedVideoIdsSet.clear();
                      });
                    },
                    icon: const Icon(Icons.close))
                : IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w)),
            actions: [
              if (_isSelectionMode && _selectedVideoIdsSet.isNotEmpty) ...[
                IconButton(
                    onPressed: _startProcessingSelected,
                    icon: const Icon(Icons.play_arrow),
                    tooltip: 'Traiter avec IA'),
                IconButton(
                    onPressed: () {
                      // Delete selected videos
                      setState(() {
                        _uploadedVideos.removeWhere(
                            (video) => _selectedVideoIdsSet.contains(video['id']));
                        _filteredVideos = List.from(_uploadedVideos);
                        _selectedVideoIdsSet.clear();
                        _isSelectionMode = false;
                      });
                    },
                    icon: const Icon(Icons.delete),
                    tooltip: 'Supprimer'),
              ] else ...[
                IconButton(
                    onPressed: _testImageAnalysis,
                    icon: const Icon(Icons.image_search),
                    tooltip: 'Test IA sur image'),
                IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    icon: CustomIconWidget(
                        iconName: 'settings',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w)),
              ],
            ],
            elevation: 0,
            backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor),
        body: SafeArea(
            child: Column(children: [
          // Search bar
          VideoSearchBarWidget(
            controller: _searchController,
            onChanged: _filterVideos,
            onClear: _clearSearch,
          ),

          // Processing queue (if any)
          ProcessingQueueWidget(
            processingVideos: _processingVideos,
            onCancelProcessing: _onCancelProcessing,
          ),

          // Video grid or empty state
          Expanded(
              child: _filteredVideos.isEmpty
                  ? EmptyGalleryWidget(
                      onCameraShortcut: _recordVideoFromCamera,
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(4.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 3.w,
                          childAspectRatio: 0.8),
                      itemCount: _filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = _filteredVideos[index];
                        final isSelected =
                            _selectedVideoIdsSet.contains(video['id']);

                        return VideoGridItemWidget(
                            video: video,
                            isSelected: isSelected,
                            onTap: () {
                              if (_isSelectionMode) {
                                setState(() {
                                  if (isSelected) {
                                    _selectedVideoIdsSet.remove(video['id']);
                                  } else {
                                    _selectedVideoIdsSet.add(video['id']);
                                  }
                                });
                              } else {
                                // Show video details or start processing
                                _startProcessingSingle(video);
                              }
                            },
                            onLongPress: () {
                              setState(() {
                                _isSelectionMode = true;
                                _selectedVideoIdsSet.add(video['id']);
                              });
                              HapticFeedback.mediumImpact();
                            });
                      })),
        ])),
        floatingActionButton: _isUploading
            ? FloatingActionButton(
                onPressed: null,
                child: CircularProgressIndicator(
                    value: _uploadProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : FloatingActionButton.extended(
                onPressed: () {
                  _showUploadOptions();
                },
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
                backgroundColor: AppTheme.lightTheme.colorScheme.primary));
  }

  void _startProcessingSingle(Map<String, dynamic> video) {
    Navigator.pushNamed(context, '/video-processing', arguments: {
      'videoCount': 1,
      'videoQueue': [video],
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  leading: const Icon(Icons.video_library),
                  title: const Text('Galerie vidéo'),
                  onTap: () {
                    Navigator.pop(context);
                    _uploadVideoFromGallery();
                  }),
              ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const Text('Enregistrer vidéo'),
                  onTap: () {
                    Navigator.pop(context);
                    _recordVideoFromCamera();
                  }),
              ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Fichiers'),
                  onTap: () {
                    Navigator.pop(context);
                    _uploadFromFiles();
                  }),
            ])));
  }

  void _showVideoContextMenu(Map<String, dynamic> video) {
    showModalBottomSheet(
        context: context,
        builder: (context) => VideoContextMenuWidget(
            video: video,
            onPreview: () {
              Navigator.pop(context);
              _previewVideo(video);
            },
            onDetails: () {
              Navigator.pop(context);
              _showVideoDetails(video);
            },
            onShare: () {
              Navigator.pop(context);
              // Implement sharing functionality
            },
            onRemove: () {
              Navigator.pop(context);
              _removeFromRecent(video);
            }));
  }
}