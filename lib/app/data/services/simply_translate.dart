import 'dart:async';

import 'package:simplytranslate/simplytranslate.dart';

final st = SimplyTranslator(EngineType.google);

Future<String> translate(String text) {
  st.setSimplyInstance = "simplytranslate.pussthecat.org";
  return st.trSimply(text, 'auto', 'id');
}
