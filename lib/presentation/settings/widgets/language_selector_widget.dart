import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {"code": "fr", "name": "Français", "flag": "🇫🇷"},
      {"code": "en", "name": "English", "flag": "🇺🇸"},
      {"code": "es", "name": "Español", "flag": "🇪🇸"},
      {"code": "de", "name": "Deutsch", "flag": "🇩🇪"},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Langue de l'application",
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Redémarrage requis pour appliquer les changements",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          ...languages.map((language) {
            final isSelected = selectedLanguage == language["code"];
            return InkWell(
              onTap: () => onLanguageChanged(language["code"]!),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                margin: EdgeInsets.only(bottom: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Text(
                      language["flag"]!,
                      style: TextStyle(fontSize: 6.w),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        language["name"]!,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : null,
                        ),
                      ),
                    ),
                    if (isSelected)
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 5.w,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
