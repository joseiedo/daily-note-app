import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:blocodetarefas/HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: myColors[PRIMARY],),
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
