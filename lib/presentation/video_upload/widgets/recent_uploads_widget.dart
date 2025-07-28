import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RecentUploadsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentVideos;
  final Function(Map<String, dynamic>) onVideoTap;

  const RecentUploadsWidget({
    super.key,
    required this.recentVideos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentVideos.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Récemment traités',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentVideos.length,
            itemBuilder: (context, index) {
              final video = recentVideos[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onVideoTap(video),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CustomImageWidget(
                                  imageUrl: video['thumbnail'] as String,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['name'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                video['processedDate'] as String,
                                style: AppTheme.lightTheme.textTheme.labelSmall
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
