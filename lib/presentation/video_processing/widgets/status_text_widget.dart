import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusTextWidget extends StatefulWidget {
  final String currentStatus;
  final List<String> statusHistory;

  const StatusTextWidget({
    super.key,
    required this.currentStatus,
    required this.statusHistory,
  });

  @override
  State<StatusTextWidget> createState() => _StatusTextWidgetState();
}

class _StatusTextWidgetState extends State<StatusTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void didUpdateWidget(StatusTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStatus != widget.currentStatus) {
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'analyse des images...':
        return Icons.video_library;
      case 'détection des blocs de code...':
        return Icons.code;
      case 'extraction de la syntaxe python...':
        return Icons.integration_instructions;
      case 'finalisation...':
        return Icons.check_circle_outline;
      default:
        return Icons.settings;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'analyse des images...':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'détection des blocs de code...':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'extraction de la syntaxe python...':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'finalisation...':
        return AppTheme.getStatusColor('success', isLight: true);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          // Current status
          FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.currentStatus)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getStatusIcon(widget.currentStatus)
                        .codePoint
                        .toString(),
                    color: _getStatusColor(widget.currentStatus),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statut actuel',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        widget.currentStatus,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Status history (if available)
          if (widget.statusHistory.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              height: 1,
            ),
            SizedBox(height: 2.h),

            // History header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Étapes terminées',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // History list
            ...widget.statusHistory.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppTheme.getStatusColor('success', isLight: true)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color:
                              AppTheme.getStatusColor('success', isLight: true),
                          size: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        status,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
