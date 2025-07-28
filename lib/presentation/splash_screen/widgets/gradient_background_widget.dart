import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GradientBackgroundWidget extends StatelessWidget {
  final Widget child;

  const GradientBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }
}
