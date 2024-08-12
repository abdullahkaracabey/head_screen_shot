import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CameraPermission {
  static const MethodChannel _channel = MethodChannel('CameraChannel');

  static Future<Uint8List> capture() async {
    final Uint8List path = await _channel.invokeMethod('captureScreenshot');
    return path;
  }

  static Future<bool> requestPermission() async {
    final isAllowed = await _channel.invokeMethod("cameraRequest");

    debugPrint('Camera permission: $isAllowed');

    return isAllowed ?? false;
  }
}
