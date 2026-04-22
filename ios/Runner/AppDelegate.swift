import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    protectScreen()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func protectScreen() {
    guard let window = UIApplication.shared.windows.first else { return }
    let secureField = UITextField()
    secureField.isSecureTextEntry = true
    secureField.isUserInteractionEnabled = false
    window.addSubview(secureField)
    window.layer.superlayer?.addSublayer(secureField.layer)
    secureField.layer.sublayers?.forEach { $0.addSublayer(window.layer) }
  }
}
