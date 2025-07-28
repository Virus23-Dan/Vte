import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CodeEditorWidget extends StatefulWidget {
  final List<Map<String, dynamic>> codeBlocks;
  final int currentBlockIndex;
  final bool isEditMode;
  final Function(String) onCodeChanged;
  final Function(int) onBlockChanged;

  const CodeEditorWidget({
    Key? key,
    required this.codeBlocks,
    required this.currentBlockIndex,
    required this.isEditMode,
    required this.onCodeChanged,
    required this.onBlockChanged,
  }) : super(key: key);

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _textController;
  late ScrollController _scrollController;
  String _searchQuery = '';
  bool _showSearch = false;
  int _currentSearchIndex = 0;
  List<int> _searchMatches = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _updateCodeContent();
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentBlockIndex != widget.currentBlockIndex) {
      _updateCodeContent();
    }
  }

  void _updateCodeContent() {
    if (widget.codeBlocks.isNotEmpty && widget.currentBlockIndex < widget.codeBlocks.length) {
      _textController.text = widget.codeBlocks[widget.currentBlockIndex]['code'] as String;
    }
  }

  void _performSearch() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _searchMatches.clear();
        _currentSearchIndex = 0;
      });
      return;
    }

    final text = _textController.text.toLowerCase();
    final query = _searchQuery.toLowerCase();
    final matches = <int>[];
    
    int index = 0;
    while (index < text.length) {
      final foundIndex = text.indexOf(query, index);
      if (foundIndex == -1) break;
      matches.add(foundIndex);
      index = foundIndex + 1;
    }

    setState(() {
      _searchMatches = matches;
      _currentSearchIndex = matches.isNotEmpty ? 0 : -1;
    });
  }

  void _navigateSearch(bool forward) {
    if (_searchMatches.isEmpty) return;
    
    setState(() {
      if (forward) {
        _currentSearchIndex = (_currentSearchIndex + 1) % _searchMatches.length;
      } else {
        _currentSearchIndex = (_currentSearchIndex - 1 + _searchMatches.length) % _searchMatches.length;
      }
    });
  }

  Widget _buildLineNumbers() {
    final lines = _textController.text.split('\n');
    return Container(
      width: 12.w,
      padding: EdgeInsets.only(right: 2.w, top: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        border: Border(
          right: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: lines.asMap().entries.map((entry) {
          final lineNumber = entry.key + 1;
          final hasError = _hasLineError(lineNumber);
          
          return Container(
            height: 2.5.h,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasError)
                  CustomIconWidget(
                    iconName: 'error',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 3.w,
                  ),
                SizedBox(width: 1.w),
                Text(
                  '$lineNumber',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _hasLineError(int lineNumber) {
    // Mock syntax error detection
    final currentBlock = widget.codeBlocks[widget.currentBlockIndex];
    final errors = currentBlock['syntaxErrors'] as List<int>? ?? [];
    return errors.contains(lineNumber);
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _performSearch();
              },
              decoration: InputDecoration(
                hintText: 'Rechercher dans le code...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(width: 2.w),
          if (_searchMatches.isNotEmpty) ...[
            Text(
              '${_currentSearchIndex + 1}/${_searchMatches.length}',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: () => _navigateSearch(false),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_up',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            IconButton(
              onPressed: () => _navigateSearch(true),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ],
          IconButton(
            onPressed: () {
              setState(() {
                _showSearch = false;
                _searchQuery = '';
                _searchMatches.clear();
              });
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentBlock = widget.codeBlocks.isNotEmpty && widget.currentBlockIndex < widget.codeBlocks.length
        ? widget.codeBlocks[widget.currentBlockIndex]
        : null;

    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Code block header
          if (currentBlock != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'code',
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Frame ${currentBlock['timestamp']}',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(currentBlock['confidence'] as double),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${((currentBlock['confidence'] as double) * 100).toInt()}% confiance',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showSearch = !_showSearch;
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      size: 5.w,
                    ),
                  ),
                ],
              ),
            ),
          
          // Search bar
          if (_showSearch) _buildSearchBar(),
          
          // Code editor
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers
                _buildLineNumbers(),
                
                // Code content
                Expanded(
                  child: TextField(
                    controller: _textController,
                    scrollController: _scrollController,
                    maxLines: null,
                    expands: true,
                    readOnly: !widget.isEditMode,
                    onChanged: widget.onCodeChanged,
                    style: AppTheme.codeTextStyle(isLight: true, fontSize: 12.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(3.w),
                      hintText: widget.isEditMode ? 'Modifiez votre code ici...' : null,
                    ),
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Block navigation
          if (widget.codeBlocks.length > 1)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: widget.currentBlockIndex > 0
                        ? () => widget.onBlockChanged(widget.currentBlockIndex - 1)
                        : null,
                    icon: CustomIconWidget(
                      iconName: 'chevron_left',
                      color: widget.currentBlockIndex > 0
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                  Text(
                    '${widget.currentBlockIndex + 1} / ${widget.codeBlocks.length}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  IconButton(
                    onPressed: widget.currentBlockIndex < widget.codeBlocks.length - 1
                        ? () => widget.onBlockChanged(widget.currentBlockIndex + 1)
                        : null,
                    icon: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: widget.currentBlockIndex < widget.codeBlocks.length - 1
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}