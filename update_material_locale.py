import re

# Read the material file
with open('d:/0Flutter/my_library/best_localization/lib/src/kurdish/kurdish_material_localization_delegate.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Map of Latin (Kurmanji) translations
latin_translations = {
    'aboutListTileTitleRaw': r"isLatin ? 'Derbarê \$applicationName' : 'دەربارەی \$applicationName'",
    'alertDialogLabel': r"isLatin ? 'Hişyarî' : 'ئاگادارکردنەوە'",
    'anteMeridiemAbbreviation': r"isLatin ? 'BN' : 'پ.ن'",
    'backButtonTooltip': r"isLatin ? 'Paş' : 'دواوە'",
    'calendarModeButtonLabel': r"isLatin ? 'Veguherin bo rojmêr' : 'گۆڕین بۆ ڕۆژژمێر'",
    'cancelButtonLabel': r"isLatin ? 'Betal bike' : 'هەڵوەشاندنەوه'",
    'closeButtonLabel': r"isLatin ? 'Bigire' : 'داخستن'",
    'closeButtonTooltip': r"isLatin ? 'Bigire' : 'داخستن'",
    'collapsedIconTapHint': r"isLatin ? 'Fireh bike' : 'فراوانکردن'",
    'continueButtonLabel': r"isLatin ? 'Berdêm be' : 'بەردەوام بە'",
    'copyButtonLabel': r"isLatin ? 'Kopî bike' : 'کۆپی'",
    'cutButtonLabel': r"isLatin ? 'Jê bibe' : 'بڕین'",
    'dateHelpText': r"'mm/dd/yyyy'",
    'dateInputLabel': r"isLatin ? 'Dîrok binivîse' : 'بەروار بنووسە'",
    'dateOutOfRangeLabel': r"isLatin ? 'Derveyî sînor' : 'دەرەوەی مەودایە'",
    'datePickerHelpText': r"isLatin ? 'Dîrok hilbijêre' : 'بەروار دیاری بکە'",
    'dateRangeEndDateSemanticLabelRaw': r"isLatin ? 'Dîroka dawî \$fullDate' : 'بەرواری کۆتایی \$fullDate'",
    'dateRangeEndLabel': r"isLatin ? 'Dîroka dawî' : 'بەرواری کۆتایی'",
    'dateRangePickerHelpText': r"isLatin ? 'Sînor destnîşan bike' : 'دەست نیشانکردنی مەودا'",
    'dateRangeStartDateSemanticLabelRaw': r"isLatin ? 'Dîroka destpêkê \$fullDate' : 'بەرواری دەستپێکردن \$fullDate'",
    'dateRangeStartLabel': r"isLatin ? 'Dîroka destpêkê' : 'بەرواری دەستپێکردن'",
    'dateSeparator': r"'/'",
    'deleteButtonTooltip': r"isLatin ? 'Jê bibe' : 'سڕینەوە'",
    'dialModeButtonLabel': r"isLatin ? 'Veguherin bo awayê hilbijêrê dawaxiyanê' : 'گۆڕین بۆ دۆخی هەڵبژێری داواکردن'",
    'dialogLabel': r"isLatin ? 'Dîyalog' : 'دیالۆگ'",
    'drawerLabel': r"isLatin ? 'Lîsteya rêpêşanderê' : 'لیستی ڕێنیشاندەر'",
    'expandedIconTapHint': r"isLatin ? 'Binivîse' : 'نوشتانەوە'",
    'hideAccountsLabel': r"isLatin ? 'Ajmêran veşêre' : 'شاردنەوەی ئەژمێرەکان'",
    'inputDateModeButtonLabel': r"isLatin ? 'Veguherin bo nivîsandinê' : 'گۆڕین بۆ نووسین'",
    'inputTimeModeButtonLabel': r"isLatin ? 'Veguherin bo awayê têketina nivîsê' : 'گۆڕین بۆ دۆخی تێکردنی دەق'",
    'invalidDateFormatLabel': r"isLatin ? 'Format ne rast e.' : 'فۆرماتی نادروست.'",
    'invalidDateRangeLabel': r"isLatin ? 'Sînorek ne rast e.' : 'مەودایەکی نادروست.'",
    'invalidTimeLabel': r"isLatin ? 'Demek rast binivîse' : 'کاتێکی دروست بنووسە'",
    'licensesPackageDetailTextOne': r"isLatin ? '1 lîsans' : '١ مۆڵەت'",
    'licensesPackageDetailTextOther': r"isLatin ? '\$licenseCount lîsans' : '\$licenseCount مۆڵەت'",
    'licensesPackageDetailTextZero': r"isLatin ? 'Lîsans tune' : 'مۆڵەت نیە'",
    'licensesPageTitle': r"isLatin ? 'Lîsans' : 'مۆڵەتەکان'",
    'modalBarrierDismissLabel': r"isLatin ? 'Derxe' : 'دەرکردن'",
    'moreButtonTooltip': r"isLatin ? 'Zêdetir' : 'زیاتر'",
    'nextMonthTooltip': r"isLatin ? 'Meha pêş' : 'مانگی داهاتوو'",
    'nextPageTooltip': r"isLatin ? 'Rûpela pêş' : 'لاپەڕەی داهاتوو'",
    'okButtonLabel': r"isLatin ? 'Baş e' : 'باشه'",
    'openAppDrawerTooltip': r"isLatin ? 'Lîsteya rêpêşanderê veke' : 'کردنەوەی لیستی ڕێنیشاندەر'",
    'pageRowsInfoTitleRaw': r"isLatin ? '\$firstRow–\$lastRow ji \$rowCount' : '\$firstRow–\$lastRow لە \$rowCount'",
    'pageRowsInfoTitleApproximateRaw': r"isLatin ? '\$firstRow–\$lastRow heta \$rowCount' : '\$firstRow–\$lastRow تا \$rowCount'",
    'pasteButtonLabel': r"isLatin ? 'Pêve bike' : 'پەیست'",
    'popupMenuLabel': r"isLatin ? 'Lîsteya derkewte' : 'لیستی دەرکەوتە'",
    'postMeridiemAbbreviation': r"isLatin ? 'PN' : 'د.ن'",
    'previousMonthTooltip': r"isLatin ? 'Meha berê' : 'مانگی پێشوو'",
    'previousPageTooltip': r"isLatin ? 'Rûpela berê' : 'لاپەڕەی پێشوو'",
    'refreshIndicatorSemanticLabel': r"isLatin ? 'Nûkirin' : 'نوێکردنەوە'",
    'remainingTextFieldCharacterCountOne': r"isLatin ? '1 tîp maye' : '١ پیت ماوە'",
    'remainingTextFieldCharacterCountOther': r"isLatin ? '\$remainingCount tîp mane' : '\$remainingCount پیتەکان ماون'",
    'remainingTextFieldCharacterCountZero': r"isLatin ? 'Tîp nemaye' : 'پیت نەماوە'",
    'reorderItemDown': r"isLatin ? 'Bo jêr veguhezîne' : 'بۆ خوارەوە بگوازەوە'",
    'reorderItemLeft': r"isLatin ? 'Bo çepê veguhezîne' : 'بۆ چەپ بگوازەوە'",
    'reorderItemRight': r"isLatin ? 'Bo rastê veguhezîne' : 'بۆ ڕاست بگوازەوە'",
    'reorderItemToEnd': r"isLatin ? 'Bo dawîyê veguhezîne' : 'بۆ کۆتایی بگوازەوە'",
    'reorderItemToStart': r"isLatin ? 'Bo destpêkê veguhezîne' : 'بۆ سەرەتا بگوازەوە'",
    'reorderItemUp': r"isLatin ? 'Bo jorê veguhezîne' : 'بۆ سەرەوە بگوازەوە'",
    'rowsPerPageTitle': r"isLatin ? 'Rêzik li ser her rûpelê:' : 'ڕیز لە هەر لاپەڕەیەک:'",
    'saveButtonLabel': r"isLatin ? 'Tomar bike' : 'پاشەکەوتکردن'",
    'scrimLabel': r"isLatin ? 'Perde' : 'پەردە'",
    'scrimOnTapHintRaw': r"isLatin ? 'Bigire \$modalRouteContentName' : 'بگرە \$modalRouteContentName'",
    'searchFieldLabel': r"isLatin ? 'Lêgerîn' : 'گەڕان'",
    'selectAllButtonLabel': r"isLatin ? 'Hemû hilbijêre' : 'دیاریکردنی هەموو'",
    'selectYearSemanticsLabel': r"isLatin ? 'Sal hilbijêre' : 'ساڵ هەڵبژێرە'",
    'selectedRowCountTitleOne': r"isLatin ? '1 tişt hilbijartî' : '١ دەق هەڵبژێردرا'",
    'selectedRowCountTitleOther': r"isLatin ? '\$selectedRowCount tişt hilbijartî' : '\$selectedRowCount دەق هەڵبژێردرا'",
    'selectedRowCountTitleZero': r"isLatin ? 'Ti tişt nehilbijartî' : 'هیچ دەقێک هەڵنەبژێردراوە'",
    'showAccountsLabel': r"isLatin ? 'Ajmêran nîşan bide' : 'پیشاندانی ئەژمێرەکان'",
    'showMenuTooltip': r"isLatin ? 'Menû nîşan bide' : 'پیشاندانی لیستە'",
    'signedInLabel': r"isLatin ? 'Têketin' : 'چوونەژوورەوە'",
    'tabLabelRaw': r"isLatin ? 'Tab \$tabIndex ji \$tabCount' : 'تابی \$tabIndex لە \$tabCount'",
    'timeOfDayFormatRaw': r"'HH:mm'",
    'timePickerDialHelpText': r"isLatin ? 'DEM HILBIJÊRE' : 'کات هەڵبژێرە'",
    'timePickerHourLabel': r"isLatin ? 'Saet' : 'کاتژمێر'",
    'timePickerHourModeAnnouncement': r"isLatin ? 'Saetan hilbijêre' : 'کاتژمێر هەڵبژێرە'",
    'timePickerInputHelpText': r"isLatin ? 'DEM TÊXE' : 'کات داخڵ بکە'",
    'timePickerMinuteLabel': r"isLatin ? 'Deqîqe' : 'خولەک'",
    'timePickerMinuteModeAnnouncement': r"isLatin ? 'Deqîqeyan hilbijêre' : 'خولەک هەڵبژێرە'",
    'unspecifiedDate': r"isLatin ? 'Dîrok' : 'بەروار'",
    'unspecifiedDateRange': r"isLatin ? 'Sînorê dîrokê' : 'مەودای بەروار'",
    'viewLicensesButtonLabel': r"isLatin ? 'Lîsansan bibîne' : 'بینینی مۆڵەتەکان'",
}

# Process each property
for prop_name, new_value in latin_translations.items():
    # Find the property pattern
    pattern = rf"(@override\s+String get {prop_name} =>.*?)(?=@override|String get selectedDateLabel|$)"
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        # Extract the full property declaration
        old_text = match.group(1).strip()
        # Replace with new ternary expression
        new_text = f"@override\n  String get {prop_name} => {new_value};"
        content = content.replace(old_text, new_text)

# Additional properties that return null
for prop in ['remainingTextFieldCharacterCountFew', 'remainingTextFieldCharacterCountMany',
             'selectedRowCountTitleFew', 'selectedRowCountTitleMany', 'selectedRowCountTitleTwo']:
    pattern = rf"(@override\s+String\? get {prop} =>.*?)(?=@override|String get selectedDateLabel|List|$)"
    content = re.sub(pattern, f"@override\n  String? get {prop} => null;", content, flags=re.DOTALL)

# narrowWeekdays
pattern = r"@override\s+List<String> get narrowWeekdays =>.*?(?=@override|String\? get|$)"
new_narrowWeekdays = """@override
  List<String> get narrowWeekdays => isLatin
      ? ['Y', 'D', 'S', 'Ç', 'P', 'Î', 'Ş']
      : ['ی', 'د', 'س', 'چ', 'پ', 'ه', 'ش'];"""
content = re.sub(pattern, new_narrowWeekdays, content, flags=re.DOTALL)

# selectedDateLabel (empty string)
pattern = r"@override\s+String get selectedDateLabel =>.*?(?=}|$)"
content = re.sub(pattern, '@override\n  String get selectedDateLabel => "";', content, flags=re.DOTALL)

# Write back
with open('d:/0Flutter/my_library/best_localization/lib/src/kurdish/kurdish_material_localization_delegate.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Material localization file updated successfully!")
