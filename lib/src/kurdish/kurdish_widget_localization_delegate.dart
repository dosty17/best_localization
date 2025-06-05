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

  @override
  // TODO: implement copyButtonLabel
  String get copyButtonLabel => 'کۆپی بکە';

  @override
  // TODO: implement cutButtonLabel
  String get cutButtonLabel => 'بڕین';

  @override
  // TODO: implement lookUpButtonLabel
  String get lookUpButtonLabel => 'گەڕان بکە';

  @override
  // TODO: implement pasteButtonLabel
  String get pasteButtonLabel => 'پەیست بکە';

  @override
  // TODO: implement searchWebButtonLabel
  String get searchWebButtonLabel => 'گەڕان لە وێب بکە';

  @override
  // TODO: implement selectAllButtonLabel
  String get selectAllButtonLabel => 'هەموو دیاری بکە';

  @override
  // TODO: implement shareButtonLabel
  String get shareButtonLabel => 'هاوبەشکردن';
}
