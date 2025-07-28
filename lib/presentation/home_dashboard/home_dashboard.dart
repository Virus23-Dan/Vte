import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/recent_extractions_section_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for recent extractions
  final List<Map<String, dynamic>> _recentExtractions = [
    {
      "id": 1,
      "thumbnail":
          "https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg?auto=compress&cs=tinysrgb&w=800",
      "date": "28 juil. 2025",
      "codePreview":
          "def calculate_fibonacci(n):\n    if n <= 1:\n        return n\n    return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)",
      "extractionTime": "14:30",
      "confidence": 0.95,
    },
    {
      "id": 2,
      "thumbnail":
          "https://images.pexels.com/photos/546819/pexels-photo-546819.jpeg?auto=compress&cs=tinysrgb&w=800",
      "date": "27 juil. 2025",
      "codePreview":
          "import pandas as pd\nimport numpy as np\n\ndata = pd.read_csv('data.csv')\nresult = data.groupby('category').mean()",
      "extractionTime": "09:15",
      "confidence": 0.88,
    },
    {
      "id": 3,
      "thumbnail":
          "https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&w=800",
      "date": "26 juil. 2025",
      "codePreview":
          "class BinaryTree:\n    def __init__(self, value):\n        self.value = value\n        self.left = None\n        self.right = None",
      "extractionTime": "16:45",
      "confidence": 0.92,
    },
    {
      "id": 4,
      "thumbnail":
          "https://images.pexels.com/photos/1181263/pexels-photo-1181263.jpeg?auto=compress&cs=tinysrgb&w=800",
      "date": "25 juil. 2025",
      "codePreview":
          "from flask import Flask, request, jsonify\n\napp = Flask(__name__)\n\n@app.route('/api/data', methods=['GET'])\ndef get_data():",
      "extractionTime": "11:20",
      "confidence": 0.90,
    },
    {
      "id": 5,
      "thumbnail":
          "https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?auto=compress&cs=tinysrgb&w=800",
      "date": "24 juil. 2025",
      "codePreview":
          "import tensorflow as tf\nfrom tensorflow import keras\n\nmodel = keras.Sequential([\n    keras.layers.Dense(128, activation='relu')",
      "extractionTime": "13:55",
      "confidence": 0.87,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showAdvancedOptions(String actionType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Options avancées',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildAdvancedOption(
              'Traitement par lots',
              'Traiter plusieurs vidéos simultanément',
              'batch_prediction',
              () {
                Navigator.pop(context);
                // Navigate to batch processing
              },
            ),
            _buildAdvancedOption(
              'Sélection de frames',
              'Choisir des frames spécifiques à analyser',
              'video_library',
              () {
                Navigator.pop(context);
                // Navigate to frame selection
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOption(
      String title, String subtitle, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 5.w,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 4.w,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Accueil'),
                  Tab(text: 'Historique'),
                  Tab(text: 'Paramètres'),
                ],
              ),
            ),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Home Tab
                  RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          // Greeting Header
                          GreetingHeaderWidget(
                            extractionCount: _recentExtractions.length,
                            processingStatus:
                                _isRefreshing ? 'processing' : 'success',
                          ),
                          SizedBox(height: 3.h),
                          // Action Cards
                          ActionCardWidget(
                            title: 'Enregistrer une vidéo',
                            iconName: 'videocam',
                            onTap: () {
                              Navigator.pushNamed(context, '/video-upload');
                            },
                            onLongPress: () => _showAdvancedOptions('record'),
                          ),
                          ActionCardWidget(
                            title: 'Importer une vidéo',
                            iconName: 'photo_library',
                            onTap: () {
                              Navigator.pushNamed(context, '/video-upload');
                            },
                            onLongPress: () => _showAdvancedOptions('upload'),
                          ),
                          SizedBox(height: 4.h),
                          // Recent Extractions
                          RecentExtractionsSectionWidget(
                            recentExtractions: _recentExtractions,
                            onRefresh: _handleRefresh,
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
                  // History Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Historique des extractions',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Settings Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'settings',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Paramètres de l\'application',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/video-upload');
              },
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 6.w,
              ),
            )
          : null,
    );
  }
}
