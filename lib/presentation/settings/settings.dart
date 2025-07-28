import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_selector_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/storage_info_widget.dart';
import './widgets/switch_setting_widget.dart';
import './widgets/user_profile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late TabController _tabController;

  // Settings state variables
  bool _autoSaveCode = true;
  bool _darkTheme = false;
  bool _biometricAuth = false;
  bool _autoDeleteVideos = true;
  bool _processingNotifications = true;
  bool _batchJobNotifications = false;
  String _ocrAccuracy = "Équilibré";
  String _exportFormat = "Python (.py)";
  String _recordingQuality = "1080p";
  String _frameRate = "30 FPS";
  String _syntaxTheme = "VS Code Dark";
  String _selectedLanguage = "fr";
  double _fontSize = 14.0;
  double _autoFocusSensitivity = 0.7;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Marie Dubois",
    "email": "marie.dubois@email.fr",
    "syncStatus": "Synchronisé",
    "storageUsed": "2.4 GB / 5 GB",
    "storagePercent": 48.0,
  };

  // Mock storage data
  final Map<String, dynamic> storageData = {
    "cacheSize": "847 MB",
    "autoCleanup": "Après 7 jours",
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showOcrAccuracyDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Niveau de précision OCR"),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  _buildRadioOption(
                      "Rapide", "Traitement rapide, précision standard"),
                  _buildRadioOption(
                      "Équilibré", "Bon compromis vitesse/précision"),
                  _buildRadioOption(
                      "Précis", "Traitement lent, précision maximale"),
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Confirmer")),
                ]));
  }

  Widget _buildRadioOption(String value, String description) {
    return RadioListTile<String>(
        title: Text(value),
        subtitle: Text(description),
        value: value,
        groupValue: _ocrAccuracy,
        onChanged: (newValue) {
          setState(() {
            _ocrAccuracy = newValue!;
          });
        });
  }

  void _showExportFormatDialog() {
    final formats = [
      "Python (.py)",
      "Texte brut (.txt)",
      "Markdown (.md)",
      "JSON (.json)",
    ];

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Format d'export par défaut"),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: formats
                        .map((format) => RadioListTile<String>(
                            title: Text(format),
                            value: format,
                            groupValue: _exportFormat,
                            onChanged: (newValue) {
                              setState(() {
                                _exportFormat = newValue!;
                              });
                            }))
                        .toList()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Confirmer")),
                ]));
  }

  void _showRecordingQualityDialog() {
    final qualities = ["720p", "1080p", "4K"];

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Qualité d'enregistrement"),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: qualities
                        .map((quality) => RadioListTile<String>(
                            title: Text(quality),
                            value: quality,
                            groupValue: _recordingQuality,
                            onChanged: (newValue) {
                              setState(() {
                                _recordingQuality = newValue!;
                              });
                            }))
                        .toList()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Confirmer")),
                ]));
  }

  void _showSyntaxThemeDialog() {
    final themes = [
      "VS Code Dark",
      "VS Code Light",
      "Monokai",
      "GitHub",
      "Dracula",
    ];

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Thème de coloration syntaxique"),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: themes
                        .map((theme) => RadioListTile<String>(
                            title: Text(theme),
                            value: theme,
                            groupValue: _syntaxTheme,
                            onChanged: (newValue) {
                              setState(() {
                                _syntaxTheme = newValue!;
                              });
                            }))
                        .toList()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Confirmer")),
                ]));
  }

  void _clearCache() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Vider le cache"),
                content: Text(
                    "Êtes-vous sûr de vouloir supprimer tous les fichiers temporaires ? Cette action ne peut pas être annulée."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Annuler")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Cache vidé avec succès")));
                      },
                      style: TextButton.styleFrom(
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.error),
                      child: Text("Vider")),
                ]));
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Paramètres exportés avec succès")));
  }

  void _showHelp() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Aide et support"),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• FAQ et tutoriels disponibles"),
                      SizedBox(height: 1.h),
                      Text("• Vidéos de démonstration"),
                      SizedBox(height: 1.h),
                      Text("• Support technique 24/7"),
                      SizedBox(height: 2.h),
                      Text("Version de l'app: 2.1.4"),
                      Text("Modèle: ${userData["name"]}"),
                      Text("Système: iOS 17.2"),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Fermer")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Demande de support envoyée")));
                      },
                      child: Text("Contacter le support")),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: Text("Paramètres"),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w)),
            bottom: TabBar(controller: _tabController, tabs: [
              Tab(text: "Général"),
              Tab(text: "Traitement"),
              Tab(text: "Avancé"),
            ])),
        body: TabBarView(controller: _tabController, children: [
          _buildGeneralTab(),
          _buildProcessingTab(),
          _buildAdvancedTab(),
        ]),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 4,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/splash-screen');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/home-dashboard');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/video-upload');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/video-processing');
                  break;
                case 4:
                  // Current screen
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: CustomIconWidget(
                      iconName: 'home',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  activeIcon: CustomIconWidget(
                      iconName: 'home',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w),
                  label: "Accueil"),
              BottomNavigationBarItem(
                  icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  activeIcon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w),
                  label: "Tableau de bord"),
              BottomNavigationBarItem(
                  icon: CustomIconWidget(
                      iconName: 'upload',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  activeIcon: CustomIconWidget(
                      iconName: 'upload',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w),
                  label: "Importer"),
              BottomNavigationBarItem(
                  icon: CustomIconWidget(
                      iconName: 'video_library',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  activeIcon: CustomIconWidget(
                      iconName: 'video_library',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w),
                  label: "Traitement"),
              BottomNavigationBarItem(
                  icon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w),
                  activeIcon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w),
                  label: "Paramètres"),
            ]));
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
        child: Column(children: [
      SizedBox(height: 2.h),
      UserProfileWidget(userData: userData),
      SettingsSectionWidget(title: "Préférences d'affichage", children: [
        SwitchSettingWidget(
            title: "Thème sombre",
            subtitle: "Interface adaptée aux environnements peu éclairés",
            value: _darkTheme,
            onChanged: (value) => setState(() => _darkTheme = value),
            leading: CustomIconWidget(
                iconName: 'dark_mode',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w)),
        SettingsItemWidget(
            title: "Thème de coloration syntaxique",
            subtitle: _syntaxTheme,
            leading: CustomIconWidget(
                iconName: 'palette',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: _showSyntaxThemeDialog),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CustomIconWidget(
                    iconName: 'text_fields',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 6.w),
                SizedBox(width: 3.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("Taille de police du code",
                          style: AppTheme.lightTheme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      Text("${_fontSize.toInt()} pt",
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                    ])),
              ]),
              SizedBox(height: 2.h),
              Slider(
                  value: _fontSize,
                  min: 10.0,
                  max: 20.0,
                  divisions: 10,
                  onChanged: (value) => setState(() => _fontSize = value)),
            ])),
      ]),
      LanguageSelectorWidget(
          selectedLanguage: _selectedLanguage,
          onLanguageChanged: (language) =>
              setState(() => _selectedLanguage = language)),
      SizedBox(height: 2.h),
    ]));
  }

  Widget _buildProcessingTab() {
    return SingleChildScrollView(
        child: Column(children: [
      SizedBox(height: 2.h),
      SettingsSectionWidget(title: "Préférences de traitement", children: [
        SettingsItemWidget(
            title: "Niveau de précision OCR",
            subtitle: _ocrAccuracy,
            leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: _showOcrAccuracyDialog),
        SwitchSettingWidget(
            title: "Sauvegarde automatique du code",
            subtitle: "Enregistrer automatiquement le code extrait",
            value: _autoSaveCode,
            onChanged: (value) => setState(() => _autoSaveCode = value),
            leading: CustomIconWidget(
                iconName: 'save',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w)),
        SettingsItemWidget(
            title: "Format d'export par défaut",
            subtitle: _exportFormat,
            leading: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: _showExportFormatDialog,
            isLast: true),
      ]),
      SettingsSectionWidget(title: "Paramètres vidéo", children: [
        SettingsItemWidget(
            title: "Qualité d'enregistrement",
            subtitle: _recordingQuality,
            leading: CustomIconWidget(
                iconName: 'videocam',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: _showRecordingQualityDialog),
        SettingsItemWidget(
            title: "Fréquence d'images",
            subtitle: _frameRate,
            leading: CustomIconWidget(
                iconName: 'speed',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: () {
              final frameRates = ["24 FPS", "30 FPS", "60 FPS"];
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: Text("Fréquence d'images"),
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: frameRates
                                  .map((rate) => RadioListTile<String>(
                                      title: Text(rate),
                                      value: rate,
                                      groupValue: _frameRate,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _frameRate = newValue!;
                                        });
                                      }))
                                  .toList()),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Annuler")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text("Confirmer")),
                          ]));
            }),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CustomIconWidget(
                    iconName: 'center_focus_strong',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 6.w),
                SizedBox(width: 3.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("Sensibilité de l'autofocus",
                          style: AppTheme.lightTheme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      Text("${(_autoFocusSensitivity * 100).toInt()}%",
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                    ])),
              ]),
              SizedBox(height: 2.h),
              Slider(
                  value: _autoFocusSensitivity,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  onChanged: (value) =>
                      setState(() => _autoFocusSensitivity = value)),
            ])),
      ]),
      SettingsSectionWidget(title: "Notifications", children: [
        SwitchSettingWidget(
            title: "Fin de traitement",
            subtitle: "Notifier quand l'extraction de code est terminée",
            value: _processingNotifications,
            onChanged: (value) =>
                setState(() => _processingNotifications = value),
            leading: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w)),
        SwitchSettingWidget(
            title: "Traitement par lots",
            subtitle: "Notifier la progression des tâches multiples",
            value: _batchJobNotifications,
            onChanged: (value) =>
                setState(() => _batchJobNotifications = value),
            leading: CustomIconWidget(
                iconName: 'batch_prediction',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            isLast: true),
      ]),
      SizedBox(height: 2.h),
    ]));
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
        child: Column(children: [
      SizedBox(height: 2.h),
      SettingsSectionWidget(title: "Sécurité et confidentialité", children: [
        SwitchSettingWidget(
            title: "Authentification biométrique",
            subtitle: "Utiliser Touch ID/Face ID pour sécuriser l'app",
            value: _biometricAuth,
            onChanged: (value) => setState(() => _biometricAuth = value),
            leading: CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w)),
        SwitchSettingWidget(
            title: "Suppression automatique des vidéos",
            subtitle: "Supprimer les vidéos après extraction du code",
            value: _autoDeleteVideos,
            onChanged: (value) => setState(() => _autoDeleteVideos = value),
            leading: CustomIconWidget(
                iconName: 'auto_delete',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w)),
        SettingsItemWidget(
            title: "Préférences de partage de données",
            subtitle: "Gérer les données partagées avec les services tiers",
            leading: CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Ouverture des paramètres de confidentialité")));
            },
            isLast: true),
      ]),
      SettingsSectionWidget(title: "Gestion du stockage", children: [
        StorageInfoWidget(storageData: storageData, onClearCache: _clearCache),
      ]),
      SettingsSectionWidget(title: "Sauvegarde et restauration", children: [
        SettingsItemWidget(
            title: "Exporter les paramètres",
            subtitle: "Sauvegarder vos préférences",
            leading: CustomIconWidget(
                iconName: 'backup',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: _exportSettings),
        SettingsItemWidget(
            title: "Importer les paramètres",
            subtitle: "Restaurer vos préférences sauvegardées",
            leading: CustomIconWidget(
                iconName: 'restore',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Fonction d'import disponible prochainement")));
            },
            isLast: true),
      ]),
      SettingsSectionWidget(title: "Aide et support", children: [
        SettingsItemWidget(
            title: "FAQ et tutoriels",
            subtitle: "Guides d'utilisation et questions fréquentes",
            leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: _showHelp),
        SettingsItemWidget(
            title: "Contacter le support",
            subtitle: "Assistance technique 24/7",
            leading: CustomIconWidget(
                iconName: 'support_agent',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Redirection vers le support technique")));
            }),
        SettingsItemWidget(
            title: "À propos de VideoCodeExtractor",
            subtitle: "Version 2.1.4 - Informations sur l'application",
            leading: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w),
            trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationName: "VideoCodeExtractor",
                  applicationVersion: "2.1.4",
                  applicationIcon: CustomIconWidget(
                      iconName: 'video_library',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 12.w),
                  children: [
                    Text(
                        "Application d'extraction de code Python à partir de vidéos."),
                    SizedBox(height: 2.h),
                    Text("Développé avec Flutter pour iOS et Android."),
                  ]);
            },
            isLast: true),
      ]),
      SizedBox(height: 4.h),
    ]));
  }
}
