import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_assistant_2608/project/classes/alert_dialog.dart';
import 'package:money_assistant_2608/project/classes/constants.dart';
import 'package:money_assistant_2608/project/database_management/shared_preferences_services.dart';
import 'package:money_assistant_2608/project/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _LoadedLocalizationDelegate
    extends LocalizationsDelegate<AppLocalization> {
  final AppLocalization localization;
  const _LoadedLocalizationDelegate(this.localization);

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<AppLocalization> load(Locale locale) =>
      SynchronousFuture(localization);

  @override
  bool shouldReload(_LoadedLocalizationDelegate old) => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final localization = AppLocalization(const Locale('en', 'US'));

  setUpAll(() async {
    await localization.load();
  });

  for (final ios in [false, true]) {
    for (final action in ['Delete', 'Reset']) {
      for (final cancel in [true, false]) {
        testWidgets(
          '${ios ? "iOS" : "Android"} $action: '
          '${cancel ? "Cancel preserves data" : "confirmation runs action once"}',
          (tester) async {
            var calls = 0;
            await tester.pumpWidget(
              ScreenUtilInit(
                designSize: const Size(428, 926),
                builder: (_, child) => MaterialApp(
                  locale: const Locale('en', 'US'),
                  localizationsDelegates: [
                    _LoadedLocalizationDelegate(localization),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  home: Scaffold(
                    body: Builder(
                      builder: (context) => TextButton(
                        onPressed: () {
                          (ios ? iosDialog : androidDialog)(
                            context,
                            'Please confirm this action.',
                            action,
                            () {
                              calls++;
                            },
                          );
                        },
                        child: const Text('Open'),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            await tester.tap(find.text('Open'));
            await tester.pumpAndSettle();
            await tester.tap(find.text(cancel ? 'Cancel' : action));
            await tester.pumpAndSettle();

            expect(calls, cancel ? 0 : 1);
            expect(find.text('Please confirm this action.'), findsNothing);
          },
        );
      }
    }
  }

  test(
    'reset restores saved and active categories without changing settings',
    () async {
      SharedPreferences.setMockInitialValues({});
      await sharedPrefs.sharePrefsInit();
      sharedPrefs.setItems(setCategoriesToDefault: false);
      final defaultIncome = sharedPrefs
          .getItems('income items')
          .map((item) => item.toJson())
          .toList();
      final defaultParents = sharedPrefs.parentExpenseItemNames;
      final defaultExpenses = sharedPrefs
          .getAllExpenseItemsLists()
          .map((items) => items.map((item) => item.toJson()).toList())
          .toList();

      incomeItems = [categoryItem(Icons.work, 'Custom income')];
      sharedPrefs.saveItems('income items', incomeItems);
      sharedPrefs.parentExpenseItemNames = ['Custom expense'];
      sharedPrefs.saveItems('Custom expense', [
        categoryItem(Icons.shopping_bag, 'Custom expense'),
      ]);
      sharedPrefs.saveItems('Food & Beverages', [
        categoryItem(Icons.restaurant, 'Edited food category'),
      ]);
      sharedPrefs.dateFormat = 'yyyy-MM-dd';
      sharedPrefs.appCurrency = 'en_IN';
      sharedPrefs.setLocale('hi');

      sharedPrefs.setItems(setCategoriesToDefault: true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      expect(
        sharedPrefs.getItems('income items').map((item) => item.toJson()),
        defaultIncome,
      );
      expect(sharedPrefs.parentExpenseItemNames, defaultParents);
      expect(
        sharedPrefs.getAllExpenseItemsLists().map(
          (items) => items.map((item) => item.toJson()).toList(),
        ),
        defaultExpenses,
      );
      expect(sharedPrefs.dateFormat, 'yyyy-MM-dd');
      expect(sharedPrefs.appCurrency, 'en_IN');
      expect(sharedPrefs.getLocale().languageCode, 'hi');
      expect(incomeItems.map((item) => item.toJson()), defaultIncome);

      // Adding an income category uses this active list; reset categories must
      // stay reset when the next category is saved.
      incomeItems.add(categoryItem(Icons.work, 'New income'));
      sharedPrefs.saveItems('income items', incomeItems);
      await prefs.reload();
      final savedNames = sharedPrefs
          .getItems('income items')
          .map((item) => item.text);
      expect(savedNames, contains('Salary'));
      expect(savedNames, contains('New income'));
      expect(savedNames, isNot(contains('Custom income')));
    },
  );
}
