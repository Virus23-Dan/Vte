import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LargeFileWarningWidget extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback onCompress;
  final VoidCallback onProceedAnyway;
  final VoidCallback onCancel;

  const LargeFileWarningWidget({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.onCompress,
    required this.onProceedAnyway,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'warning',
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fichier volumineux détecté',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Le fichier "$fileName" ($fileSize) est volumineux',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Les fichiers de plus de 100 MB peuvent prendre plus de temps à traiter. Nous recommandons de compresser la vidéo pour de meilleures performances.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: Text('Annuler'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onProceedAnyway,
                  child: Text('Continuer'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCompress,
                  child: Text('Compresser'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
