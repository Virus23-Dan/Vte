import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserProfileWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfileWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
            ),
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 8.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  userData["email"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            (userData["syncStatus"] as String) == "Synchronisé"
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      userData["syncStatus"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            (userData["syncStatus"] as String) == "Synchronisé"
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Stockage",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                userData["storageUsed"] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: 20.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (userData["storagePercent"] as double) / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
