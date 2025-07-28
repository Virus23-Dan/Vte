import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class VideoSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const VideoSearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Rechercher des vidéos...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(12),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
    );
  }
}
