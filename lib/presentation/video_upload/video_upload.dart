
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import './widgets/empty_gallery_widget.dart';
import './widgets/large_file_warning_widget.dart';
import './widgets/processing_queue_widget.dart';
import './widgets/recent_uploads_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeCamera();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cameraController?.dispose();
    _contextMenuOverlay?.remove();
    super.dispose();
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
      if (_selectedVideoIds.contains(videoId)) {
        _selectedVideoIds.remove(videoId);
      } else {
        _selectedVideoIds.add(videoId);
      }

      if (_selectedVideoIds.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedVideoIds.clear();
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
            },
          ),
        ),
      ),
    );

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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _shareVideo(Map<String, dynamic> video) {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Partage de ${video['name']}')),
    );
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
        SnackBar(content: Text('Erreur lors de la sélection de la vidéo')),
      );
    }
  }

  Future<void> _pickVideoFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

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
        SnackBar(content: Text('Erreur lors de la sélection du fichier')),
      );
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
        SnackBar(content: Text('Erreur lors de l\'enregistrement')),
      );
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Compression de $_selectedLargeFile en cours...')),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Upload'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_filteredVideos.isNotEmpty)
            IconButton(
              onPressed: _toggleMultiSelectMode,
              icon: CustomIconWidget(
                iconName: _isMultiSelectMode ? 'close' : 'checklist',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshGallery,
            child: CustomScrollView(
              slivers: [
                // Search bar
                if (_filteredVideos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: VideoSearchBarWidget(
                      controller: _searchController,
                      onChanged: _filterVideos,
                      onClear: _clearSearch,
                    ),
                  ),

                // Processing queue
                if (_processingVideos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: ProcessingQueueWidget(
                      processingVideos: _processingVideos,
                      onCancelProcessing: _onCancelProcessing,
                    ),
                  ),

                // Recent uploads
                if (_recentVideos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: RecentUploadsWidget(
                      recentVideos: _recentVideos,
                      onVideoTap: _previewVideo,
                    ),
                  ),

                // Multi-select header
                if (_isMultiSelectMode && _selectedVideoIds.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${_selectedVideoIds.length} vidéo(s) sélectionnée(s)',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Video grid or empty state
                _filteredVideos.isEmpty
                    ? SliverFillRemaining(
                        child: EmptyGalleryWidget(
                          onCameraShortcut: _recordVideo,
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final video = _filteredVideos[index];
                              final isSelected =
                                  _selectedVideoIds.contains(video['id']);

                              return VideoGridItemWidget(
                                video: video,
                                isSelected: isSelected,
                                onTap: () => _onVideoTap(video),
                                onLongPress: () {
                                  final RenderBox renderBox =
                                      context.findRenderObject() as RenderBox;
                                  final position =
                                      renderBox.localToGlobal(Offset.zero);
                                  _onVideoLongPress(video, position);
                                },
                              );
                            },
                            childCount: _filteredVideos.length,
                          ),
                        ),
                      ),
              ],
            ),
          ),

          // Large file warning overlay
          if (_showLargeFileWarning)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: LargeFileWarningWidget(
                  fileName: _selectedLargeFile,
                  fileSize: _selectedLargeFileSize,
                  onCompress: _handleLargeFileCompress,
                  onProceedAnyway: _handleLargeFileProceed,
                  onCancel: _handleLargeFileCancel,
                ),
              ),
            ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _filteredVideos.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "gallery",
                  onPressed: _pickVideoFromGallery,
                  child: CustomIconWidget(
                    iconName: 'photo_library',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: "files",
                  onPressed: _pickVideoFromFiles,
                  child: CustomIconWidget(
                    iconName: 'folder',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: "camera",
                  onPressed: _recordVideo,
                  child: CustomIconWidget(
                    iconName: 'videocam',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            )
          : null,
      bottomNavigationBar: _isMultiSelectMode && _selectedVideoIds.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: _processSelectedVideos,
                  child: Text('Traiter ${_selectedVideoIds.length} vidéo(s)'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
