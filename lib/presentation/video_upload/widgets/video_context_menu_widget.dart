import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class VideoContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> video;
  final VoidCallback onPreview;
  final VoidCallback onDetails;
  final VoidCallback onShare;
  final VoidCallback onRemove;

  const VideoContextMenuWidget({
    super.key,
    required this.video,
    required this.onPreview,
    required this.onDetails,
    required this.onShare,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: 'play_circle_outline',
            title: 'Aperçu',
            onTap: onPreview,
          ),
          Divider(height: 1),
          _buildMenuItem(
            icon: 'info_outline',
            title: 'Détails',
            onTap: onDetails,
          ),
          Divider(height: 1),
          _buildMenuItem(
            icon: 'share',
            title: 'Partager',
            onTap: onShare,
          ),
          Divider(height: 1),
          _buildMenuItem(
            icon: 'delete_outline',
            title: 'Supprimer des récents',
            onTap: onRemove,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
