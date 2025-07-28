import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedDetailsWidget extends StatefulWidget {
  final double frameRate;
  final int detectedTextRegions;
  final double confidenceScore;
  final String processingMode;
  final Map<String, dynamic> deviceInfo;

  const AdvancedDetailsWidget({
    super.key,
    required this.frameRate,
    required this.detectedTextRegions,
    required this.confidenceScore,
    required this.processingMode,
    required this.deviceInfo,
  });

  @override
  State<AdvancedDetailsWidget> createState() => _AdvancedDetailsWidgetState();
}

class _AdvancedDetailsWidgetState extends State<AdvancedDetailsWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return AppTheme.getStatusColor('success', isLight: true);
    } else if (confidence >= 0.6) {
      return AppTheme.getStatusColor('warning', isLight: true);
    } else {
      return AppTheme.getStatusColor('error', isLight: true);
    }
  }

  String _getConfidenceText(double confidence) {
    if (confidence >= 0.8) {
      return 'Excellente';
    } else if (confidence >= 0.6) {
      return 'Bonne';
    } else {
      return 'Faible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Header with expand/collapse button
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'analytics',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Détails avancés',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                children: [
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    height: 1,
                  ),

                  SizedBox(height: 3.h),

                  // Processing metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Fréquence d\'images',
                          '${widget.frameRate.toStringAsFixed(1)} fps',
                          Icons.speed,
                          AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildMetricCard(
                          'Régions détectées',
                          '${widget.detectedTextRegions}',
                          Icons.crop_free,
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Confidence score
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(widget.confidenceScore)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getConfidenceColor(widget.confidenceScore)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'psychology',
                              color:
                                  _getConfidenceColor(widget.confidenceScore),
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Score de confiance',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Text(
                              '${(widget.confidenceScore * 100).toInt()}%',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    _getConfidenceColor(widget.confidenceScore),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '(${_getConfidenceText(widget.confidenceScore)})',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        LinearProgressIndicator(
                          value: widget.confidenceScore,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getConfidenceColor(widget.confidenceScore),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Processing mode and device info
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Mode de traitement',
                          widget.processingMode,
                          Icons.settings_applications,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildInfoCard(
                          'Accélération GPU',
                          widget.deviceInfo['gpuAcceleration'] == true
                              ? 'Activée'
                              : 'Désactivée',
                          Icons.memory,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Device performance info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'phone_android',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Informations de l\'appareil',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'RAM: ${widget.deviceInfo['ram'] ?? 'N/A'} • CPU: ${widget.deviceInfo['cpu'] ?? 'N/A'} • Batterie: ${widget.deviceInfo['battery'] ?? 'N/A'}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: color,
            size: 16,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
