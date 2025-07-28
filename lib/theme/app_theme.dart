import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
class AppTheme {
  AppTheme._();

  // Developer Clarity Color Palette - High-contrast optimized for code readability
  static const Color primaryLight =
      Color(0xFF2D3748); // Deep slate for professional developer aesthetic
  static const Color primaryVariantLight =
      Color(0xFF1A202C); // Darker variant for depth
  static const Color secondaryLight =
      Color(0xFF4A5568); // Supporting gray for secondary actions
  static const Color accentLight =
      Color(0xFF3182CE); // Clear blue for interactive elements
  static const Color successLight =
      Color(0xFF38A169); // Confident green for successful operations
  static const Color warningLight =
      Color(0xFFD69E2E); // Amber for OCR confidence warnings
  static const Color errorLight =
      Color(0xFFE53E3E); // Clear red for failed extractions
  static const Color backgroundLight =
      Color(0xFFFFFFFF); // Pure white for optimal code readability
  static const Color surfaceLight =
      Color(0xFFF7FAFC); // Subtle gray for card backgrounds
  static const Color textPrimaryLight =
      Color(0xFF1A202C); // High contrast dark for code content
  static const Color textSecondaryLight =
      Color(0xFF718096); // Medium gray for metadata
  static const Color borderLight =
      Color(0xFFE2E8F0); // Minimal borders for content separation

  // Dark theme colors - maintaining developer focus in low light
  static const Color primaryDark =
      Color(0xFF4A5568); // Adjusted for dark mode visibility
  static const Color primaryVariantDark = Color(0xFF2D3748); // Darker variant
  static const Color secondaryDark =
      Color(0xFF718096); // Supporting gray for dark mode
  static const Color accentDark =
      Color(0xFF63B3ED); // Lighter blue for dark mode contrast
  static const Color successDark =
      Color(0xFF68D391); // Lighter green for dark mode
  static const Color warningDark =
      Color(0xFFF6E05E); // Lighter amber for dark mode
  static const Color errorDark = Color(0xFFF56565); // Lighter red for dark mode
  static const Color backgroundDark = Color(0xFF1A202C); // Dark background
  static const Color surfaceDark = Color(0xFF2D3748); // Dark surface
  static const Color textPrimaryDark =
      Color(0xFFF7FAFC); // Light text for dark mode
  static const Color textSecondaryDark =
      Color(0xFFA0AEC0); // Medium light gray for metadata
  static const Color borderDark = Color(0xFF4A5568); // Dark mode borders

  // Card and dialog colors
  static const Color cardLight = Color(0xFFF7FAFC);
  static const Color cardDark = Color(0xFF2D3748);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF2D3748);

  // Shadow colors - subtle elevation for professional feel
  static const Color shadowLight =
      Color(0x0F000000); // Minimal shadow for clean look
  static const Color shadowDark =
      Color(0x1F000000); // Slightly more visible in dark mode

  // Divider colors
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF4A5568);

  /// Light theme - Precision Minimalism for developer focus
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: backgroundLight,
      primaryContainer: primaryVariantLight,
      onPrimaryContainer: backgroundLight,
      secondary: secondaryLight,
      onSecondary: backgroundLight,
      secondaryContainer: secondaryLight.withValues(alpha: 0.1),
      onSecondaryContainer: textPrimaryLight,
      tertiary: accentLight,
      onTertiary: backgroundLight,
      tertiaryContainer: accentLight.withValues(alpha: 0.1),
      onTertiaryContainer: textPrimaryLight,
      error: errorLight,
      onError: backgroundLight,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: borderLight.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: backgroundDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,

    // AppBar theme - Clean developer tool aesthetic
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: textPrimaryLight,
      elevation: 0, // Flat design for modern developer tools
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight),
    ),

    // Card theme - Adaptive content cards with subtle elevation
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2.0, // Minimal elevation for content organization
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Rounded corners for modern feel
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation - Clean and functional
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundLight,
      selectedItemColor: accentLight,
      unselectedItemColor: textSecondaryLight,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Floating Action Button - Hierarchical design
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentLight,
      foregroundColor: backgroundLight,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes - Professional and accessible
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundLight,
        backgroundColor: primaryLight,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: borderLight, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography - Inter for interface, JetBrains Mono for code
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration - Clean forms with clear focus states
    inputDecorationTheme: InputDecorationTheme(
      fillColor: backgroundLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: accentLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryLight.withValues(alpha: 0.7),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Interactive elements
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return textSecondaryLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight.withValues(alpha: 0.3);
        }
        return borderLight;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundLight),
      side: BorderSide(color: borderLight, width: 1),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return textSecondaryLight;
      }),
    ),

    // Progress indicators - For OCR processing feedback
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentLight,
      linearTrackColor: borderLight,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: accentLight,
      thumbColor: accentLight,
      overlayColor: accentLight.withValues(alpha: 0.2),
      inactiveTrackColor: borderLight,
    ),

    tabBarTheme: TabBarTheme(
      labelColor: textPrimaryLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: accentLight,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryLight,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),

    // Bottom sheet theme - Adaptive bottom sheets for video import
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      elevation: 8,
    ), dialogTheme: DialogThemeData(backgroundColor: dialogLight),
  );

  /// Dark theme - Maintaining developer focus in low light conditions
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: backgroundDark,
      primaryContainer: primaryVariantDark,
      onPrimaryContainer: textPrimaryDark,
      secondary: secondaryDark,
      onSecondary: backgroundDark,
      secondaryContainer: secondaryDark.withValues(alpha: 0.2),
      onSecondaryContainer: textPrimaryDark,
      tertiary: accentDark,
      onTertiary: backgroundDark,
      tertiaryContainer: accentDark.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimaryDark,
      error: errorDark,
      onError: backgroundDark,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: borderDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: backgroundLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundDark,
      selectedItemColor: accentDark,
      unselectedItemColor: textSecondaryDark,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentDark,
      foregroundColor: backgroundDark,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundDark,
        backgroundColor: primaryDark,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: borderDark, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderDark, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: accentDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryDark.withValues(alpha: 0.7),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark;
        }
        return textSecondaryDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark.withValues(alpha: 0.3);
        }
        return borderDark;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundDark),
      side: BorderSide(color: borderDark, width: 1),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark;
        }
        return textSecondaryDark;
      }),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentDark,
      linearTrackColor: borderDark,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: accentDark,
      thumbColor: accentDark,
      overlayColor: accentDark.withValues(alpha: 0.2),
      inactiveTrackColor: borderDark,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: textPrimaryDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: accentDark,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      elevation: 8,
    ), dialogTheme: DialogThemeData(backgroundColor: dialogDark),
  );

  /// Helper method to build text theme with Inter and JetBrains Mono fonts
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHigh = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textMedium = isLight ? textSecondaryLight : textSecondaryDark;
    final Color textDisabled = isLight
        ? textSecondaryLight.withValues(alpha: 0.6)
        : textSecondaryDark.withValues(alpha: 0.6);

    return TextTheme(
      // Display styles - Inter Bold for major headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textHigh,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textHigh,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),

      // Headline styles - Inter SemiBold for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHigh,
      ),

      // Title styles - Inter Medium for component titles
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textHigh,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHigh,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHigh,
        letterSpacing: 0.1,
      ),

      // Body styles - Inter Regular for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHigh,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHigh,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMedium,
        letterSpacing: 0.4,
      ),

      // Label styles - Inter for UI labels and captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHigh,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMedium,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Code text style using JetBrains Mono for extracted code display
  static TextStyle codeTextStyle(
      {required bool isLight, double fontSize = 14}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: isLight ? textPrimaryLight : textPrimaryDark,
      letterSpacing: 0,
      height: 1.4, // Better line spacing for code readability
    );
  }

  /// Code text style bold variant for syntax highlighting
  static TextStyle codeTextStyleBold(
      {required bool isLight, double fontSize = 14}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: isLight ? textPrimaryLight : textPrimaryDark,
      letterSpacing: 0,
      height: 1.4,
    );
  }

  /// Status colors for OCR processing feedback
  static Color getStatusColor(String status, {required bool isLight}) {
    switch (status.toLowerCase()) {
      case 'success':
        return isLight ? successLight : successDark;
      case 'warning':
        return isLight ? warningLight : warningDark;
      case 'error':
        return isLight ? errorLight : errorDark;
      case 'processing':
        return isLight ? accentLight : accentDark;
      default:
        return isLight ? textSecondaryLight : textSecondaryDark;
    }
  }
}
