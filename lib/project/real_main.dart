import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'database_management/shared_preferences_services.dart';
import 'database_management/sqflite_services.dart';
import 'localization/app_localization.dart';
import 'home.dart';

Future<void> initializeAppData() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.sharePrefsInit();
  sharedPrefs.setItems(setCategoriesToDefault: false);
  incomeItems = sharedPrefs.getItems('income items');
  sharedPrefs.getCurrency();
  sharedPrefs.getAllExpenseItemsLists();
}

Future<void> realMain() async {
  await initializeAppData();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    Locale appLocale = sharedPrefs.getLocale();
    setState(() {
      this._locale = appLocale;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
          ),
        ),
      );
    } else {
      return ScreenUtilInit(
        designSize: Size(428.0, 926.0),
        builder: (_, child) => MaterialApp(
          title: 'MMAS',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 45.0,
                color: Colors.deepOrangeAccent,
              ),
              labelLarge: TextStyle(fontFamily: 'OpenSans'),
              titleMedium: TextStyle(fontFamily: 'NotoSans'),
              bodyMedium: TextStyle(fontFamily: 'NotoSans'),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
            ).copyWith(secondary: Colors.orange),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.amberAccent,
            ),
          ),
          builder: (context, widget) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: widget!,
          ),
          home: Home(),
          locale: _locale,
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          supportedLocales: [
            Locale("en", "US"),
            Locale("de", "DE"),
            Locale("es", "ES"),
            Locale("fr", "FR"),
            Locale("hi", "IN"),
            Locale("ja", "JP"),
            Locale("ko", "KR"),
            Locale("pt", "PT"),
            Locale("ru", "RU"),
            Locale("tr", "TR"),
            Locale("vi", "VN"),
            Locale("zh", "CN"),
            Locale("ne", "NP"),
          ],
        ),
      );
    }
  }
}
