import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class EmptyGalleryWidget extends StatelessWidget {
  final VoidCallback onCameraShortcut;

  const EmptyGalleryWidget({
    super.key,
    required this.onCameraShortcut,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'video_library',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 48,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Aucune vidéo trouvée',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Importez des vidéos depuis votre galerie ou enregistrez-en une nouvelle',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onCameraShortcut,
              icon: CustomIconWidget(
                iconName: 'videocam',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Enregistrer une vidéo'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
