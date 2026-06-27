import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

class _KurmanjiMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _KurmanjiMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = locale.languageCode;

    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: krmLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(krmDateSymbols),
    );
    return SynchronousFuture<MaterialLocalizations>(
      KurmanjiMaterialLocalizations(
        fullYearFormat: intl.DateFormat('y', localeName),
        shortDateFormat: intl.DateFormat('MM/DD/YY', localeName),
        compactDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        shortMonthDayFormat: intl.DateFormat('MM/DD', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        decimalFormat: intl.NumberFormat('#,##0.###', 'tr'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'tr'),
      ),
    );
  }

  @override
  bool shouldReload(_KurmanjiMaterialLocalizationsDelegate old) => false;
}

class KurmanjiMaterialLocalizations extends GlobalMaterialLocalizations {
  const KurmanjiMaterialLocalizations({
    super.localeName = 'ku',
    required super.fullYearFormat,
    required super.shortDateFormat,
    required super.compactDateFormat,
    required super.shortMonthDayFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });
  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _KurmanjiMaterialLocalizationsDelegate();

  @override
  String get aboutListTileTitleRaw => 'Derbarê \$applicationName';

  @override
  String get alertDialogLabel => 'Hişyarî';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Paşve';

  @override
  String get calendarModeButtonLabel => 'Rojînara biguherîne';

  @override
  String get cancelButtonLabel => 'Betal bike';

  @override
  String get closeButtonLabel => 'Bigire';

  @override
  String get closeButtonTooltip => 'Bigire';

  @override
  String get collapsedIconTapHint => 'Vekire';

  @override
  String get continueButtonLabel => 'Berdewam bike';

  @override
  String get copyButtonLabel => 'Ji ber bigire';

  @override
  String get cutButtonLabel => 'Jê bike';

  @override
  String get dateHelpText => 'mm/dd/yyyy';

  @override
  String get dateInputLabel => 'Têxe tarîxê';

  @override
  String get dateOutOfRangeLabel => 'Derveyê sînoran';

  @override
  String get datePickerHelpText => 'Tarîxê hilbijêre';

  @override
  String get dateRangeEndDateSemanticLabelRaw => 'Tarîxa dawî \$fullDate';

  @override
  String get dateRangeEndLabel => 'Tarîxa dawî';

  @override
  String get dateRangePickerHelpText => 'Sînorê hilbijêre';

  @override
  String get dateRangeStartDateSemanticLabelRaw => 'Tarîxa destpêkê \$fullDate';

  @override
  String get dateRangeStartLabel => 'Tarîxa destpêkê';

  @override
  String get dateSeparator => '/';

  @override
  String get deleteButtonTooltip => 'Jê bibe';

  @override
  String get dialModeButtonLabel => 'Biguherîne moda hilbijêra daxwazê';

  @override
  String get dialogLabel => 'Paceya diazlogê';

  @override
  String get drawerLabel => 'Lîsteya menûyê';

  @override
  String get expandedIconTapHint => 'Kêmkirin';

  @override
  String get hideAccountsLabel => 'Hesaban veşêre';

  @override
  String get inputDateModeButtonLabel => 'Biguherîne moda nivîsandinê';

  @override
  String get inputTimeModeButtonLabel => 'Biguherîne moda têketina nivîsê';

  @override
  String get invalidDateFormatLabel => 'Formata nederbasdar.';

  @override
  String get invalidDateRangeLabel => 'Sînoreke nederbasdar.';

  @override
  String get invalidTimeLabel => 'Dema derbasdar têxe';

  @override
  String get licensesPackageDetailTextOne => '1 lîsans';

  @override
  String get licensesPackageDetailTextOther => '\$licenseCount lîsans';

  @override
  String get licensesPackageDetailTextZero => 'Lîsans tune';

  @override
  String get licensesPageTitle => 'Lîsansan';

  @override
  String get modalBarrierDismissLabel => 'Derkeve';

  @override
  String get moreButtonTooltip => 'Zêdetir';

  @override
  String get nextMonthTooltip => 'Meha pêş';

  @override
  String get nextPageTooltip => 'Rûpela pêş';

  @override
  String get okButtonLabel => 'Temam';

  @override
  String get openAppDrawerTooltip => 'Lîsteya menûyê veke';

  @override
  String get pageRowsInfoTitleRaw => '\$firstRow–\$lastRow ji \$rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      '\$firstRow–\$lastRow heta \$rowCount';

  @override
  String get pasteButtonLabel => 'Pê ve bike';

  @override
  String get popupMenuLabel => 'Lîsteya menu';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Meha borî';

  @override
  String get previousPageTooltip => 'Rûpela borî';

  @override
  String get refreshIndicatorSemanticLabel => 'Nûkirin';

  @override
  String? get remainingTextFieldCharacterCountFew => null;

  @override
  List<String> get narrowWeekdays => ['D', 'S', 'Ç', 'P', 'Ê', 'În', 'Ş'];

  @override
  String? get remainingTextFieldCharacterCountMany => null;

  @override
  String get remainingTextFieldCharacterCountOne => '1 tîp maye';

  @override
  String get remainingTextFieldCharacterCountOther =>
      '\$remainingCount tîpên man';

  @override
  String? get remainingTextFieldCharacterCountTwo => null;

  @override
  String get remainingTextFieldCharacterCountZero => 'Tîpên man tune';

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
  String get rowsPerPageTitle => 'Rîzan ji her rûpelê:';

  @override
  String get saveButtonLabel => 'Tomar bike';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => 'Lêgerîn';

  @override
  String get selectAllButtonLabel => 'Hemî hilbijêre';

  @override
  String get selectYearSemanticsLabel => 'Salê hilbijêre';

  @override
  String? get selectedRowCountTitleFew => null;

  @override
  String? get selectedRowCountTitleMany => null;

  @override
  String get selectedRowCountTitleOne => '1 hat hilbijartin';

  @override
  String get selectedRowCountTitleOther =>
      '\$selectedRowCount hatin hilbijartin';

  @override
  String? get selectedRowCountTitleTwo => null;

  @override
  String get selectedRowCountTitleZero => 'Tiştek nehat hilbijartin';

  @override
  String get showAccountsLabel => 'Hesaban nîşan bide';

  @override
  String get showMenuTooltip => 'Menûyê nîşan bide';

  @override
  String get signedInLabel => 'Têketin';

  @override
  String get tabLabelRaw => 'Tab \$tabIndex ji \$tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerDialHelpText => 'Demê hilbijêre';

  @override
  String get timePickerHourLabel => 'Seet';

  @override
  String get timePickerHourModeAnnouncement => 'Seetê hilbijêre';

  @override
  String get timePickerInputHelpText => 'Demê têxe';

  @override
  String get timePickerMinuteLabel => 'Xulek';

  @override
  String get timePickerMinuteModeAnnouncement => 'Xulekê hilbijêre';

  @override
  String get unspecifiedDate => 'Tarîx';

  @override
  String get unspecifiedDateRange => 'Sînoreke tarîxê';

  @override
  String get viewLicensesButtonLabel => 'Lînsanan nîşan bide';

  @override
  String get firstPageTooltip => 'Rûpela destpêkê';

  @override
  String get lastPageTooltip => 'Rûpela dawî';

  @override
  String get keyboardKeyAlt => "Alt";

  @override
  String get keyboardKeyAltGraph => "Alt Graph";

  @override
  String get keyboardKeyBackspace => "Backspace";

  @override
  String get keyboardKeyCapsLock => "Caps Lock";

  @override
  String get keyboardKeyControl => "Control";

  @override
  String get keyboardKeyDelete => "Delete";

  @override
  String get keyboardKeyEject => "Eject";

  @override
  String get keyboardKeyEnd => "End";

  @override
  String get keyboardKeyEscape => "Escape";

  @override
  String get keyboardKeyFn => "Fn";

  @override
  String get keyboardKeyHome => "Home";

  @override
  String get keyboardKeyInsert => "Insert";

  @override
  String get keyboardKeyMeta => "Meta";

  @override
  String get keyboardKeyMetaMacOs => "Meta (Mac OS)";

  @override
  String get keyboardKeyMetaWindows => "Meta (Windows)";

  @override
  String get keyboardKeyNumLock => "Num Lock";

  @override
  String get keyboardKeyNumpad0 => "Numpad 0";

  @override
  String get keyboardKeyNumpad1 => "Numpad 1";

  @override
  String get keyboardKeyNumpad2 => "Numpad 2";

  @override
  String get keyboardKeyNumpad3 => "Numpad 3";

  @override
  String get keyboardKeyNumpad4 => "Numpad 4";

  @override
  String get keyboardKeyNumpad5 => "Numpad 5";

  @override
  String get keyboardKeyNumpad6 => "Numpad 6";

  @override
  String get keyboardKeyNumpad7 => "Numpad 7";

  @override
  String get keyboardKeyNumpad8 => "Numpad 8";

  @override
  String get keyboardKeyNumpad9 => "Numpad 9";

  @override
  String get keyboardKeyNumpadAdd => "Numpad Add";

  @override
  String get keyboardKeyNumpadComma => "Numpad Comma";

  @override
  String get keyboardKeyNumpadDecimal => "Numpad Decimal";

  @override
  String get keyboardKeyNumpadDivide => "Numpad Divide";

  @override
  String get keyboardKeyNumpadEnter => "Numpad Enter";

  @override
  String get keyboardKeyNumpadEqual => "Numpad Equal";

  @override
  String get keyboardKeyNumpadMultiply => "Numpad Multiply";

  @override
  String get keyboardKeyNumpadParenLeft => "Numpad Paren Left";

  @override
  String get keyboardKeyNumpadParenRight => "Numpad Paren Right";

  @override
  String get keyboardKeyNumpadSubtract => "Numpad Subtract";

  @override
  String get keyboardKeyPageDown => "Page Down";

  @override
  String get keyboardKeyPageUp => "Page Up";

  @override
  String get keyboardKeyPower => "Power";

  @override
  String get keyboardKeyPowerOff => "Power Off";

  @override
  String get keyboardKeyPrintScreen => "Print Screen";

  @override
  String get keyboardKeyScrollLock => "Scroll Lock";

  @override
  String get keyboardKeySelect => "Select";

  @override
  String get keyboardKeyShift => "Shift";

  @override
  String get keyboardKeySpace => "Space";

  @override
  String get menuBarMenuLabel => "Menû";

  @override
  String get bottomSheetLabel => 'Rûpela jêrîn';

  @override
  String get currentDateLabel => "Îro";

  @override
  String get scrimLabel => 'Dapîr';

  @override
  String get scrimOnTapHintRaw => 'Ji bo derketinê bitikîne';

  @override
  String get collapsedHint => 'Kêmkirî';

  @override
  String get expandedHint => 'Vekirî';

  @override
  String get expansionTileCollapsedHint => 'Kêmkirî';

  @override
  String get expansionTileCollapsedTapHint => 'Ji bo vekirinê bitikîne';

  @override
  String get expansionTileExpandedHint => 'Vekirî';

  @override
  String get expansionTileExpandedTapHint => 'Ji bo girtinê bitikîne';

  @override
  String get scanTextButtonLabel => 'Nivîsa skan bike';

  @override
  String get lookUpButtonLabel => 'Lêgerîn';

  @override
  String get menuDismissLabel => 'Menûyê bigire';

  @override
  String get searchWebButtonLabel => 'Li torê lêgerîn bike';

  @override
  String get shareButtonLabel => 'Parve bike';

  String get clearButtonLabel => 'Paqij bike';

  @override
  String get clearButtonTooltip => 'Paqij bike';

  @override
  String get selectedDateLabel => "Hatiye hilbijartin";

  @override
  String get keyboardKeyChannelDown => "Channel Down";

  @override
  String get keyboardKeyChannelUp => "Channel Up";
}

const krmDateSymbols = {
  'NAME': 'ku',
  'ERAS': ['BZ', 'PZ'],
  'ERANAMES': ['Berî Zayînê', 'Piştî Zayînê'],
  'NARROWMONTHS': [
    'R',
    'Ş',
    '3',
    'N',
    'G',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'STANDALONENARROWMONTHS': [
    'R',
    'Ş',
    '3',
    'N',
    'G',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'MONTHS': [
    'Rêbendan',
    'Reşemeh',
    'Adar',
    'Nîsan',
    'Gulan',
    'Pûşper',
    'Tîrmeh',
    'Tebax',
    'Îlon',
    'Cotmeh',
    'Mijdar',
    'Berfanbar',
  ],
  'STANDALONEMONTHS': [
    'Rêbendan',
    'Reşemeh',
    'Adar',
    'Nîsan',
    'Gulan',
    'Pûşper',
    'Tîrmeh',
    'Tebax',
    'Îlon',
    'Cotmeh',
    'Mijdar',
    'Berfanbar',
  ],
  'SHORTMONTHS': [
    'Rêb',
    'Reş',
    'Ada',
    'Nîs',
    'Gul',
    'Pûş',
    'Tîr',
    'Teb',
    'Îlo',
    'Cot',
    'Mij',
    'Ber',
  ],
  'STANDALONESHORTMONTHS': [
    'Rêb',
    'Reş',
    'Ada',
    'Nîs',
    'Gul',
    'Pûş',
    'Tîr',
    'Teb',
    'Îlo',
    'Cot',
    'Mij',
    'Ber',
  ],
  'WEEKDAYS': ['Dşem', 'Dşemş', 'Sşem', 'Cşemş', 'Pêncşem', 'În', 'Şemî'],
  'STANDALONEWEEKDAYS': [
    'Dşem',
    'Dşemş',
    'Sşem',
    'Cşemş',
    'Pêncşem',
    'În',
    'Şemî'
  ],
  'SHORTWEEKDAYS': ['Dş', 'Dşş', 'Sş', 'Cşş', 'Pêş', 'În', 'Şem'],
  'STANDALONESHORTWEEKDAYS': ['Dş', 'Dşş', 'Sş', 'Cşş', 'Pêş', 'În', 'Şem'],
  'NARROWWEEKDAYS': ['D', 'S', 'Ç', 'P', 'Ê', 'În', 'Ş'],
  'STANDALONENARROWWEEKDAYS': ['D', 'S', 'Ç', 'P', 'Ê', 'În', 'Ş'],
  'SHORTQUARTERS': ['Ç1', 'Ç2', 'Ç3', 'Ç4'],
  'QUARTERS': [
    'Çariniya yekem',
    'Çariniya duyem',
    'Çariniya sêyem',
    'Çariniya çarem'
  ],
  'AMPMS': ['AM', 'PM'],
  'DATEFORMATS': [
    'EEEE, d MMMM y',
    'd MMMM y',
    'dd/MM/y',
    'd/M/y',
  ],
  'TIMEFORMATS': [
    'h:mm:ss a zzzz',
    'h:mm:ss a z',
    'h:mm:ss a',
    'h:mm a',
  ],
  'AVAILABLEFORMATS': null,
  'DATETIMEFORMATS': [
    '{1} {0}',
    '{1} {0}',
    '{1} {0}',
    '{1} {0}',
  ],
  'ZERODIGIT': '0',
  'FIRSTDAYOFWEEK': 0,
  'WEEKENDRANGE': [5, 6],
  'FIRSTWEEKCUTOFFDAY': 3
};

const krmLocaleDatePatterns = {
  'd': 'd',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  'LLLL': 'LLLL',
  'M': 'L',
  'Md': 'd/M',
  'MEd': 'EEE d/M',
  'MMM': 'LLL',
  'MMMd': 'd MMM',
  'MMMEd': 'EEE d MMM',
  'MMMM': 'LLLL',
  'MMMMd': 'd MMMM',
  'MMMMEEEEd': 'EEEE d MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'M/y',
  'yMd': 'd/M/y',
  'yMEd': 'EEE d/M/y',
  'yMMM': 'MMM y',
  'yMMMd': 'd MMM y',
  'yMMMEd': 'EEE d MMM y',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd MMMM y',
  'yMMMMEEEEd': 'EEEE d MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'h a',
  'jm': 'h:mm a',
  'jms': 'h:mm:ss a',
  'jmv': 'h:mm a v',
  'jmz': 'h:mm a z',
  'jz': 'h a z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ'
};
