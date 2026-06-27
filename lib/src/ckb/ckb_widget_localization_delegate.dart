import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _CkbMaterialLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _CkbMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ckb';

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    return SynchronousFuture<WidgetsLocalizations>(
      CkbWidgetLocalizations(),
    );
  }

  @override
  bool shouldReload(_CkbMaterialLocalizationsDelegate old) => false;
}

class CkbWidgetLocalizations extends WidgetsLocalizations {
  static const LocalizationsDelegate<WidgetsLocalizations> delegate =
      _CkbMaterialLocalizationsDelegate();

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

  @override
  // TODO: implement radioButtonUnselectedLabel
  String get radioButtonUnselectedLabel => 'یەکێک هەڵبژێرە';
}
