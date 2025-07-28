import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final int extractionCount;
  final String processingStatus;

  const GreetingHeaderWidget({
    super.key,
    required this.extractionCount,
    required this.processingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour !',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vous avez extrait $extractionCount codes Python',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.getStatusColor(processingStatus, isLight: true)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.getStatusColor(processingStatus, isLight: true)
                            .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.getStatusColor(processingStatus,
                            isLight: true),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      processingStatus == 'processing' ? 'En cours' : 'Prêt',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.getStatusColor(processingStatus,
                            isLight: true),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
