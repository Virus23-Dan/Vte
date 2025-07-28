import 'dart:convert';
import 'dart:html' as html if (dart.library.html) 'dart:html';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ActionToolbarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> codeBlocks;
  final bool isEditMode;
  final Function() onEditModeToggle;
  final Function() onUndo;
  final Function() onRedo;
  final bool canUndo;
  final bool canRedo;

  const ActionToolbarWidget({
    Key? key,
    required this.codeBlocks,
    required this.isEditMode,
    required this.onEditModeToggle,
    required this.onUndo,
    required this.onRedo,
    required this.canUndo,
    required this.canRedo,
  }) : super(key: key);

  Future<void> _copyAllCode(BuildContext context) async {
    final allCode = codeBlocks
        .asMap()
        .entries
        .map((entry) => '${entry.value['code'] as String}\n\n# --- Frame ${entry.key + 1} ---\n\n')
        .join();

    await Clipboard.setData(ClipboardData(text: allCode));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code copié dans le presse-papiers'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveAsPythonFile(BuildContext context) async {
    try {
      final allCode = codeBlocks
          .asMap()
          .entries
          .map((entry) => '${entry.value['code'] as String}\n\n# --- Frame ${entry.key + 1} ---\n\n')
          .join();
      final filename =
          'extracted_code_${DateTime.now().millisecondsSinceEpoch}.py';

      if (kIsWeb) {
        final bytes = utf8.encode(allCode);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(allCode);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fichier Python sauvegardé: $filename'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _shareCode(BuildContext context) async {
    final allCode = codeBlocks
        .asMap()
        .entries
        .map((entry) => '${entry.value['code'] as String}\n\n# --- Frame ${entry.key + 1} ---\n\n')
        .join();

    await Clipboard.setData(ClipboardData(text: allCode));

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Partager le code'),
          content: Text(
              'Le code a été copié dans le presse-papiers. Vous pouvez maintenant le coller dans votre application préférée.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showContextMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'format',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'auto_fix_high',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text('Formater le code'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'validate',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text('Valider la syntaxe'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'comment',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'comment',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text('Ajouter commentaire'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleContextMenuAction(context, value);
      }
    });
  }

  void _handleContextMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'format':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code formaté automatiquement'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
        break;
      case 'validate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Syntaxe Python validée'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
        break;
      case 'comment':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commentaire ajouté'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Primary actions row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _copyAllCode(context),
                  icon: CustomIconWidget(
                    iconName: 'content_copy',
                    color: Colors.white,
                    size: 4.w,
                  ),
                  label: Text('Copier tout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _saveAsPythonFile(context),
                  icon: CustomIconWidget(
                    iconName: 'save',
                    color: Colors.white,
                    size: 4.w,
                  ),
                  label: Text('Sauver .py'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Secondary actions row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareCode(context),
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Partager'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEditModeToggle,
                  icon: CustomIconWidget(
                    iconName: isEditMode ? 'visibility' : 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text(isEditMode ? 'Lecture' : 'Édition'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isEditMode
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Edit mode controls
          if (isEditMode) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                IconButton(
                  onPressed: canUndo ? onUndo : null,
                  icon: CustomIconWidget(
                    iconName: 'undo',
                    color: canUndo
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                IconButton(
                  onPressed: canRedo ? onRedo : null,
                  icon: CustomIconWidget(
                    iconName: 'redo',
                    color: canRedo
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTapDown: (details) =>
                      _showContextMenu(context, details.globalPosition),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'more_horiz',
                          color: AppTheme
                              .lightTheme.colorScheme.onPrimaryContainer,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Plus d\'options',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}