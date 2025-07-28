import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ProcessingQueueWidget extends StatelessWidget {
  final List<Map<String, dynamic>> processingVideos;
  final Function(String) onCancelProcessing;

  const ProcessingQueueWidget({
    super.key,
    required this.processingVideos,
    required this.onCancelProcessing,
  });

  @override
  Widget build(BuildContext context) {
    if (processingVideos.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'hourglass_empty',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'File de traitement',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: processingVideos.length,
          itemBuilder: (context, index) {
            final video = processingVideos[index];
            final progress = (video['progress'] as double) / 100;

            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CustomImageWidget(
                        imageUrl: video['thumbnail'] as String,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['name'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: AppTheme
                                      .lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            video['status'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          onCancelProcessing(video['id'] as String),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
