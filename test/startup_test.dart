import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:money_assistant_2608/project/classes/category_item.dart';
import 'package:money_assistant_2608/project/classes/constants.dart';
import 'package:money_assistant_2608/project/database_management/shared_preferences_services.dart';
import 'package:money_assistant_2608/project/real_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('first launch seeds categories after preferences initialize', () async {
    SharedPreferences.setMockInitialValues({});

    await initializeAppData();

    expect(incomeItems, isNotEmpty);
    expect(sharedPrefs.parentExpenseItemNames, contains('Food & Beverages'));
    expect(sharedPrefs.getItems('income items'), isNotEmpty);
    final seededCategories = [
      ...incomeItems,
      ...sharedPrefs.getAllExpenseItemsLists().expand((items) => items),
    ];
    for (final category in seededCategories) {
      expect(iconData(category), isNot(Icons.category), reason: category.text);
    }
  });

  test('saved icons from removed font packages still display', () {
    final oldFood = CategoryItem(
      0xf141f,
      'material_design_icons_flutter',
      'Material Design Icons',
      'Food',
      '',
    );
    expect(iconData(oldFood), Icons.fastfood);
  });

  test('saved category icons resolve to registered constants', () {
    final customCategory = CategoryItem(
      IcoFontIcons.gift.codePoint,
      IcoFontIcons.gift.fontPackage,
      IcoFontIcons.gift.fontFamily,
      'Custom gifts',
      '',
    );
    expect(iconData(customCategory), IcoFontIcons.gift);
  });
}
