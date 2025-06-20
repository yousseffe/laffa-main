import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String>? _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
  final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return L10n.all.contains(locale);
  }

  
  @override
Future<AppLocalizations> load(Locale locale) async {
  AppLocalizations localizations = AppLocalizations(locale);
  await localizations.load();
  return localizations;
}

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('ar');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale) || _locale == locale) return;
    _locale = locale;
    AppLocalizations.delegate.load(locale);
    Get.updateLocale(locale);
    notifyListeners();
  }
}

class L10n {
  static final all = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];
}
