import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    let controller: FlutterViewController = mainFlutterWindow!.contentViewController as! FlutterViewController
    
    ScreenshotChannel(messenger: controller.engine.binaryMessenger)
    CameraChannel(messenger: controller.engine.binaryMessenger)


    super.applicationDidFinishLaunching(aNotification)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
