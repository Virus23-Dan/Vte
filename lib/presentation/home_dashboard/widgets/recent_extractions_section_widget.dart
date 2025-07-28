import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './recent_extraction_card_widget.dart';

class RecentExtractionsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentExtractions;
  final VoidCallback? onRefresh;

  const RecentExtractionsSectionWidget({
    super.key,
    required this.recentExtractions,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extractions récentes',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (recentExtractions.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Navigate to history tab
                  },
                  child: Text(
                    'Voir tout',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        recentExtractions.isEmpty
            ? _buildEmptyState(context)
            : SizedBox(
                height: 25.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: recentExtractions.length,
                  itemBuilder: (context, index) {
                    final extraction = recentExtractions[index];
                    return RecentExtractionCardWidget(
                      extraction: extraction,
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/code-extraction-results');
                      },
                      onView: () {
                        Navigator.pushNamed(
                            context, '/code-extraction-results');
                      },
                      onShare: () {
                        // Implement share functionality
                      },
                      onDelete: () {
                        // Implement delete functionality
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'code',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 10.w,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Extrayez votre premier code',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Commencez par enregistrer ou importer une vidéo contenant du code Python',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          TextButton(
            onPressed: () {
              // Navigate to tutorial or help
            },
            child: Text(
              'Voir le tutoriel',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
