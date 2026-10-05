import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_assistant_2608/project/app_pages/currency.dart';
import 'package:money_assistant_2608/project/classes/currency_icon.dart';
import 'package:money_assistant_2608/project/database_management/shared_preferences_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'appCurrency': 'de_DE'});
    await sharedPrefs.sharePrefsInit();
    sharedPrefs.getCurrency();
  });

  testWidgets('currency picker updates an already mounted amount icon', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(428, 926);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const iconKey = ValueKey('amount-currency');
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (_, child) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  const CurrencyIcon(key: iconKey, size: 45, color: Colors.red),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Currency()),
                    ),
                    child: const Text('Choose currency'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final iconElement = tester.element(find.byKey(iconKey));
    Finder symbol(String text) =>
        find.descendant(of: find.byKey(iconKey), matching: find.text(text));
    expect(symbol('\u20ac'), findsOneWidget);

    for (final selection in [
      ('Indian Rupee', 'hi_IN', '\u20b9'),
      ('Japanese Yen', 'ja_JP', '\u00a5'),
      ('South Korean Won', 'ko_KR', '\u20a9'),
      ('Vietnamese Dong', 'vi_VN', '\u20ab'),
      ('Nepali Rupee', 'ne_NP', 'Rs'),
      ('United States Dollar', 'en_US', '\$'),
    ]) {
      await tester.tap(find.text('Choose currency'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(selection.$1),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(selection.$1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(tester.element(find.byKey(iconKey)), same(iconElement));
      expect(symbol(selection.$3), findsOneWidget);
      expect(currency, selection.$3);
      expect(sharedPrefs.appCurrency, selection.$2);
      expect(tester.takeException(), isNull);
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      expect(prefs.getString('appCurrency'), selection.$2);
    }

    // Startup loads the saved currency into the same symbol used by the icon.
    currencySymbol.value = '';
    sharedPrefs.getCurrency();
    await tester.pump();
    expect(symbol('\$'), findsOneWidget);
  });
}
