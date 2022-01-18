import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
     GMSServices.provideAPIKey("AIzaSyAUgbE2O2Tmg8RTFh-nD2GqFl_24RbxG9s")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
