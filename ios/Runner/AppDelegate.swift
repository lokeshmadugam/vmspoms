import UIKit
import Flutter
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
     GMSServices.provideAPIKey("AIzaSyDl1l_zzjKA49SmsaqqI3UHBoxaagF9Zbo")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
