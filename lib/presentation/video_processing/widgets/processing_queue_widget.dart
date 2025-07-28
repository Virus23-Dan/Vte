import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingQueueWidget extends StatelessWidget {
  final int currentVideoIndex;
  final int totalVideos;
  final List<Map<String, dynamic>> videoQueue;

  const ProcessingQueueWidget({
    super.key,
    required this.currentVideoIndex,
    required this.totalVideos,
    required this.videoQueue,
  });

  @override
  Widget build(BuildContext context) {
    if (totalVideos <= 1) return const SizedBox.shrink();

    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Queue header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'queue',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'File de traitement',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$currentVideoIndex/$totalVideos',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Queue progress bar
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: (82.w) * (currentVideoIndex / totalVideos),
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Video queue list
          SizedBox(
            height: 15.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoQueue.length,
              itemBuilder: (context, index) {
                final video = videoQueue[index];
                final isCurrentVideo = index == currentVideoIndex - 1;
                final isCompleted = index < currentVideoIndex - 1;
                final isPending = index > currentVideoIndex - 1;

                return Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    color: isCurrentVideo
                        ? AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1)
                        : isCompleted
                            ? AppTheme.getStatusColor('success', isLight: true)
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentVideo
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : isCompleted
                              ? AppTheme.getStatusColor('success',
                                  isLight: true)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                      width: isCurrentVideo ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Video thumbnail or icon
                      Container(
                        width: 12.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: video['thumbnail'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CustomImageWidget(
                                  imageUrl: video['thumbnail'],
                                  width: 12.w,
                                  height: 8.h,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: CustomIconWidget(
                                  iconName: 'video_file',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 24,
                                ),
                              ),
                      ),

                      SizedBox(height: 1.h),

                      // Status indicator
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          color: isCurrentVideo
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : isCompleted
                                  ? AppTheme.getStatusColor('success',
                                      isLight: true)
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2.5.w),
                        ),
                        child: isCurrentVideo
                            ? SizedBox(
                                width: 3.w,
                                height: 3.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.surface,
                                  ),
                                ),
                              )
                            : isCompleted
                                ? Center(
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      size: 12,
                                    ),
                                  )
                                : null,
                      ),

                      SizedBox(height: 0.5.h),

                      // Video name
                      Text(
                        video['name'] ?? 'Vidéo ${index + 1}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
