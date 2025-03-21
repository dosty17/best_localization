import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _KurdishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    return SynchronousFuture<WidgetsLocalizations>(
      KurdishWidgetLocalizations(),
    );
  }

  @override
  bool shouldReload(_KurdishMaterialLocalizationsDelegate old) => false;
}

class KurdishWidgetLocalizations extends WidgetsLocalizations {
  static const LocalizationsDelegate<WidgetsLocalizations> delegate =
      _KurdishMaterialLocalizationsDelegate();

  @override
  TextDirection get textDirection => TextDirection.rtl;

  @override
  String get reorderItemDown => 'بۆ خوارەوە بگوازەوە';

  @override
  String get reorderItemLeft => 'بۆ چەپ بگوازەوە';

  @override
  String get reorderItemRight => 'بۆ ڕاست بگوازەوە';

  @override
  String get reorderItemToEnd => 'بۆ کۆتایی بگوازەوە';

  @override
  String get reorderItemToStart => 'بۆ سەرەتا بگوازەوە';

  @override
  String get reorderItemUp => 'بۆ سەرەوە بگوازەوە';
}
