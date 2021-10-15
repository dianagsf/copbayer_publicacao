import 'package:copbayer_app/pages/controle/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(
    GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      // Linguagem calendário data
      supportedLocales: [Locale("pt")],
      debugShowCheckedModeBanner: false,
      title: "Copbayer",
      home: InitialPage(), //LoginPage(),
    ),
  );
}

/*void didChangeAppLifecycleState(AppLifecycleState state) {
  print("STATE = $state");
}*/