import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StorageInfoWidget extends StatelessWidget {
  final Map<String, dynamic> storageData;
  final VoidCallback onClearCache;

  const StorageInfoWidget({
    super.key,
    required this.storageData,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cache des vidéos",
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                storageData["cacheSize"] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nettoyage automatique",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                storageData["autoCleanup"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onClearCache,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              child: Text("Vider le cache"),
            ),
          ),
        ],
      ),
    );
  }
}
