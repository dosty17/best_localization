import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

const kurmanjiLocaleDatePatterns = {
  'd': 'd',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'MM',
  'LLLL': 'MM',
  'M': 'M',
  'Md': 'd/M',
  'MEd': 'EEE d/M',
  'MMM': 'MM',
  'MMMd': 'd/MM',
  'MMMEd': 'EEE d/MM',
  'MMMM': 'MM',
  'MMMMd': 'd/MMMM',
  'MMMMEEEEd': 'EEEE d/MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'M/y',
  'yMd': 'd/M/y',
  'yMEd': 'EEE d/MM/y',
  'yMMM': 'MMM y',
  'yMMMd': 'd/MMM y',
  'yMMMEd': 'EEE d/MMM y',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd/MMMM y',
  'yMMMMEEEEd': 'EEEE d/MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

const krmDateSymbolsCupertino = {
  'NAME': 'ku',
  'ERAS': ['BZ', 'PZ'],
  'ERANAMES': ['Berî Zayînê', 'Piştî Zayînê'],
  'NARROWMONTHS': [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'STANDALONENARROWMONTHS': [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'MONTHS': [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'STANDALONEMONTHS': [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'SHORTMONTHS': [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ],
  'STANDALONESHORTMONTHS': [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
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

class KurmanjiCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const KurmanjiCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: kurmanjiLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(krmDateSymbolsCupertino),
    );

    return SynchronousFuture<CupertinoLocalizations>(
      KurmanjiCupertinoLocalizations(
        weekdayFormat: intl.DateFormat.EEEE(localeName),
        localeName: localeName,
        decimalFormat: intl.NumberFormat('#,##0.###', 'tr'),
        fullYearFormat: intl.DateFormat('y', localeName),
        dayFormat: intl.DateFormat('d', localeName),
        doubleDigitMinuteFormat: intl.DateFormat('mm', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        singleDigitHourFormat: intl.DateFormat('h', localeName),
        singleDigitMinuteFormat: intl.DateFormat('m', localeName),
        singleDigitSecondFormat: intl.DateFormat('s', localeName),
      ),
    );
  }

  @override
  bool shouldReload(KurmanjiCupertinoLocalizationsDelegate old) => false;
}

class KurmanjiCupertinoLocalizations extends GlobalCupertinoLocalizations {
  const KurmanjiCupertinoLocalizations({
    super.localeName = 'ku',
    required super.fullYearFormat,
    required super.mediumDateFormat,
    required super.decimalFormat,
    required super.dayFormat,
    required super.doubleDigitMinuteFormat,
    required super.singleDigitHourFormat,
    required super.singleDigitMinuteFormat,
    required super.singleDigitSecondFormat,
    required super.weekdayFormat,
  });

  @override
  String get alertDialogLabel => r'Hişyarî';

  @override
  String get anteMeridiemAbbreviation => r'AM';

  @override
  String get copyButtonLabel => r'Ji ber bigire';

  @override
  String get cutButtonLabel => r'Jê bike';

  @override
  String get modalBarrierDismissLabel => r'Bigire';

  @override
  String get pasteButtonLabel => r'Pê ve bike';

  @override
  String get postMeridiemAbbreviation => r'PM';

  @override
  String get selectAllButtonLabel => r'Hemî hilbijêre';

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      KurmanjiCupertinoLocalizationsDelegate();

  @override
  String get datePickerDateOrderString => "dmy";

  @override
  String get datePickerDateTimeOrderString => "date_time_dayPeriod";

  @override
  String? get datePickerHourSemanticsLabelOther => "Seetê hilbijêra dîrokê";

  @override
  String? get datePickerMinuteSemanticsLabelOther => "Xuleka hilbijêra dîrokê";

  @override
  String get searchTextFieldPlaceholderLabel => "Lêgerîn";

  @override
  String get tabSemanticsLabelRaw => "Tabeya \$tabIndex ji \$tabCount";

  @override
  String? get timerPickerHourLabelOther => "Hilbijêra seetê";

  @override
  String? get timerPickerMinuteLabelOther => "Hilbijêra xulekê";

  @override
  String? get timerPickerSecondLabelOther => "Hilbijêra çirkanê";

  @override
  String get todayLabel => "Îro";

  @override
  String get noSpellCheckReplacementsLabel =>
      "Tu veguhêştina kontrola rastnivîsê tune";

  @override
  String get lookUpButtonLabel => 'Lêgerîn';

  @override
  String get menuDismissLabel => 'Menûyê bigire';

  @override
  String get searchWebButtonLabel => 'Li torê lêgerîn bike';

  @override
  String get shareButtonLabel => 'Parve bike';

  @override
  String get clearButtonLabel => 'Paqij bike';

  @override
  String get backButtonLabel => 'Paşve';

  @override
  String get cancelButtonLabel => 'Betal bike';

  @override
  String get collapsedHint => 'Kêmkirî';

  @override
  String get expandedHint => 'Vekirî';

  @override
  String get expansionTileCollapsedHint => 'Zêdetir nîşan bide';

  @override
  String get expansionTileCollapsedTapHint => 'Veke';

  @override
  String get expansionTileExpandedHint => 'Kêmtir nîşan bide';

  @override
  String get expansionTileExpandedTapHint => 'Bigire';
}
