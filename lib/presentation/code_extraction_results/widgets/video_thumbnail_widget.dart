import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoThumbnailWidget extends StatelessWidget {
  final String videoThumbnail;
  final List<Map<String, dynamic>> detectedRegions;
  final Function(int) onRegionTap;

  const VideoThumbnailWidget({
    Key? key,
    required this.videoThumbnail,
    required this.detectedRegions,
    required this.onRegionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Video thumbnail
            CustomImageWidget(
              imageUrl: videoThumbnail,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // Detected code regions overlay
            ...detectedRegions.asMap().entries.map((entry) {
              final index = entry.key;
              final region = entry.value;
              return Positioned(
                left: (region['x'] as double) * 80.w / 100,
                top: (region['y'] as double) * 20.h / 100,
                width: (region['width'] as double) * 15.w / 100,
                height: (region['height'] as double) * 8.h / 100,
                child: GestureDetector(
                  onTap: () => onRegionTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            // Play overlay indicator
            Center(
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'play_arrow',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
