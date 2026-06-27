import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _KurmanjiWidgetLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _KurmanjiWidgetLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    return SynchronousFuture<WidgetsLocalizations>(
      KurmanjiWidgetLocalizations(),
    );
  }

  @override
  bool shouldReload(_KurmanjiWidgetLocalizationsDelegate old) => false;
}

class KurmanjiWidgetLocalizations extends WidgetsLocalizations {
  static const LocalizationsDelegate<WidgetsLocalizations> delegate =
      _KurmanjiWidgetLocalizationsDelegate();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get reorderItemDown => 'Yeqaş bike';

  @override
  String get reorderItemLeft => 'Bi çepê re bike';

  @override
  String get reorderItemRight => 'Bi rastê re bike';

  @override
  String get reorderItemToEnd => 'Bi dawişîn re bike';

  @override
  String get reorderItemToStart => 'Bi destpêkê re bike';

  @override
  String get reorderItemUp => 'Ber jor bike';

  @override
  String get copyButtonLabel => 'Ji ber bigire';

  @override
  String get cutButtonLabel => 'Jê bike';

  @override
  String get lookUpButtonLabel => 'Lêgerîn';

  @override
  String get pasteButtonLabel => 'Pê ve bike';

  @override
  String get searchWebButtonLabel => 'Li torê lêgerîn bike';

  @override
  String get selectAllButtonLabel => 'Hemî hilbijêre';

  @override
  String get shareButtonLabel => 'Parve bike';

  @override
  String get radioButtonUnselectedLabel => 'Radyoyê biguherîne';
}
