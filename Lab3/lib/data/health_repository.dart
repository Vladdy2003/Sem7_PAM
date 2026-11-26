import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/app_data.dart';

// Sursa de date a aplicatiei. Abstracta, ca sa poata fi inlocuita
// (de ex. cu un API real sau cu un fake in teste).
abstract class HealthRepository {
  Future<AppData> loadAppData();
}

// Citeste asincron fisierul assets/data/lab.json inclus in proiect.
class JsonHealthRepository implements HealthRepository {
  final AssetBundle bundle;
  final String assetPath;
  final Duration simulatedDelay;

  JsonHealthRepository({
    AssetBundle? bundle,
    this.assetPath = 'assets/data/lab.json',
    this.simulatedDelay = const Duration(milliseconds: 1200),
  }) : bundle = bundle ?? rootBundle;

  @override
  Future<AppData> loadAppData() async {
    // intarziere artificiala ca sa se vada starea de Loading
    await Future.delayed(simulatedDelay);

    final raw = await bundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AppData.fromJson(json);
  }
}
