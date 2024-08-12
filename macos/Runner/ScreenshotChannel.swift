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

class ScreenshotChannel {
  let CHANNEL: String = "ScreenshotChannel"
  let METHOD_CAPTURE = "captureScreenshot"
  let METHOD_CAPTURE_REQUEST = "captureRequest"

  init(messenger: FlutterBinaryMessenger) {
    let flavorChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: messenger)

    flavorChannel.setMethodCallHandler(self.handle)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case METHOD_CAPTURE:
      self.captureScreenshot(result: result)
    case METHOD_CAPTURE_REQUEST:
      self.captureRequest(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func captureRequest(result: FlutterResult) {
      if #available(macOS 10.15, *) {
          let access = CGRequestScreenCaptureAccess()
          print("access: \(access)")
          
          result(access)
      } else {
          result(true)
      }
  }

  private func captureScreenshot(result: FlutterResult) {
    let displayID = CGMainDisplayID()

    guard let image = CGDisplayCreateImage(displayID) else {
      result(
        FlutterError(code:"CaptureError", message: "Error on capturing screenshot",  details: nil))
      return
    }

    let bitmapRep = NSBitmapImageRep(cgImage: image)
    guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
      result(
        FlutterError(code: "ConvertError", message: "Error on convert screenshot to PNG",  details: nil))
      return
    }

    result(pngData)
  }
}
