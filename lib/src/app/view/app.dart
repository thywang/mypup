import 'package:flutter/material.dart';
import 'package:my_pup_simple/home/view/home_page.dart';
import 'package:my_pup_simple/l10n/l10n.dart';

class App extends StatelessWidget {
  // const App({super.key});
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: theme,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        dividerColor: Colors.black,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
