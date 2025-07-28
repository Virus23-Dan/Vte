import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InitializationStatusWidget extends StatelessWidget {
  final List<Map<String, dynamic>> statusItems;

  const InitializationStatusWidget({
    Key? key,
    required this.statusItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: statusItems.map((item) => _buildStatusItem(item)).toList(),
      ),
    );
  }

  Widget _buildStatusItem(Map<String, dynamic> item) {
    final String title = item['title'] as String;
    final String status = item['status'] as String;
    final bool isCompleted = status == 'completed';
    final bool isLoading = status == 'loading';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
            height: 5.w,
            child: isCompleted
                ? CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successLight,
                    size: 5.w,
                  )
                : isLoading
                    ? SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'radio_button_unchecked',
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 5.w,
                      ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: isCompleted ? 1.0 : 0.7),
                fontSize: 3.5.w,
                fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
