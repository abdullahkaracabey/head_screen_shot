//
//  ScreenshotCannel.swift
//  Runner
//
//  Created by Abdullah Karacabey on 11.08.2024.
//

import Cocoa
import FlutterMacOS
import AVFoundation
//import Foundation

class CameraChannel {
  let CHANNEL: String = "CameraChannel"
  let METHOD_CAPTURE = "capturePhoto"
  let METHOD_CAMERA_REQUEST = "cameraRequest"

  init(messenger: FlutterBinaryMessenger) {
    let flavorChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: messenger)

    flavorChannel.setMethodCallHandler(self.handle)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case METHOD_CAMERA_REQUEST:
      self.hasCameraPermission(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func hasCameraPermission(result: @escaping FlutterResult) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      result(true)
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
          result(granted)
        }
      }
    case .denied, .restricted:
      result(false)
    @unknown default:
      result(false)
    }
  }

}
