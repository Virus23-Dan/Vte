import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingAnimationWidget extends StatefulWidget {
  final String? videoThumbnail;
  final double progress;
  final String statusText;

  const ProcessingAnimationWidget({
    super.key,
    this.videoThumbnail,
    required this.progress,
    required this.statusText,
  });

  @override
  State<ProcessingAnimationWidget> createState() =>
      _ProcessingAnimationWidgetState();
}

class _ProcessingAnimationWidgetState extends State<ProcessingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video thumbnail or placeholder
          Container(
            width: 80.w,
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
            ),
            child: widget.videoThumbnail != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: widget.videoThumbnail!,
                      width: 80.w,
                      height: 45.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'video_library',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48,
                      ),
                    ),
                  ),
          ),

          // Scanning overlay effect
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Positioned(
                top: 45.h * _scanAnimation.value - 2,
                left: 2.5.w,
                right: 2.5.w,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.8),
                        AppTheme.lightTheme.colorScheme.tertiary,
                        AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),

          // Pulse effect for processing indication
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 85.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Processing indicator
          Positioned(
            bottom: 2.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Analyse en cours...',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
