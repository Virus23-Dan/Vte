import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class VideoGridItemWidget extends StatelessWidget {
  final Map<String, dynamic> video;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const VideoGridItemWidget({
    super.key,
    required this.video,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: isSelected
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary, width: 3)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video thumbnail
              CustomImageWidget(
                imageUrl: video['thumbnail'] as String,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Play button overlay
              Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),

              // Duration badge
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    video['duration'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // File size indicator
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    video['fileSize'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              // Selection checkmark
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
