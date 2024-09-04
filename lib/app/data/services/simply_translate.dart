import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:simplytranslate/simplytranslate.dart';

// final st = SimplyTranslator(EngineType.google);
final st = SimplyTranslator(EngineType.google);

Future<String> translate(String text) async {
  st.setLingvaInstance = "lingva.ml";
  // print(await st.fetchInstances());
  // print(await st.getLingvaInstances());
  // st.setSimplyInstance = "translate.birdcat.cafe";
  // st.setSimplyInstance = "simplytranslate.pussthecat.org";
  return await st.trLingva(text, 'auto', GetStorage().read("language"), true);
}
