import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Screenshot {
  static const MethodChannel _channel = MethodChannel('ScreenshotChannel');

  static Future<Uint8List> capture() async {
    final Uint8List path = await _channel.invokeMethod('captureScreenshot');
    return path;
  }

  static Future<bool> isAvailable() async {
    final isAllowed = await _channel.invokeMethod("captureRequest");

    debugPrint('Screenshot capture is allowed: $isAllowed');

    return isAllowed ?? false;
  }
}
