import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentExtractionCardWidget extends StatelessWidget {
  final Map<String, dynamic> extraction;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const RecentExtractionCardWidget({
    super.key,
    required this.extraction,
    this.onTap,
    this.onView,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: double.infinity,
                height: 12.h,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: extraction['thumbnail'] != null
                      ? CustomImageWidget(
                          imageUrl: extraction['thumbnail'] as String,
                          width: double.infinity,
                          height: 12.h,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'code',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 8.w,
                            ),
                          ),
                        ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Text(
                        extraction['date'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      // Code preview
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            extraction['codePreview'] as String,
                            style: AppTheme.codeTextStyle(
                                isLight: true, fontSize: 10.sp),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            iconName: 'visibility',
                            onTap: onView,
                          ),
                          _buildActionButton(
                            iconName: 'share',
                            onTap: onShare,
                          ),
                          _buildActionButton(
                            iconName: 'delete_outline',
                            onTap: onDelete,
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String iconName,
    VoidCallback? onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: (color ?? AppTheme.lightTheme.colorScheme.onSurfaceVariant)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: color ?? AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
      ),
    );
  }
}
