import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

Widget photoFromString(String str, double width) {
  Uint8List? photoBytes;
  photoBytes = Uint8List.fromList(base64.decode(str));
  return Image.memory(
    photoBytes,
    width: width,
  );
}
