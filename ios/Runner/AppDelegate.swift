import Flutter
import PocketbaseMobile
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var channel: FlutterMethodChannel? = nil
  var messageConnector: FlutterBasicMessageChannel? = nil
  var isRunning = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    channel = FlutterMethodChannel(name: "com.pocketbase.mobile.channel", binaryMessenger: controller.binaryMessenger)
    messageConnector = FlutterBasicMessageChannel(name: "com.pocketbase.mobile.message_connector", binaryMessenger: controller.binaryMessenger)
    prepareMethodHandler()
    GeneratedPluginRegistrant.register(with: self)
    let handler = PocketMobileCallbackHandler(appDelegate: self)
    PocketbaseMobileRegisterNativeBridgeCallback(handler)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func prepareMethodHandler() {
    channel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "start" {
        self.startPocketbase(args: call.arguments, result: result)
      } else if call.method == "stop" {
        self.stopPocketbase()
        result(nil)
      } else if call.method == "isRunning" {
        result(self.isRunning)
      } else if call.method == "version" {
        result(PocketbaseMobileGetVersion())
      } else if call.method == "getLocalIpAddress" {
        result(self.getLocalIpAddress())
      } else {
        result(FlutterMethodNotImplemented)
        return
      }
    }
  }

  func startPocketbase(args: Any?, result: @escaping FlutterResult) {
    let argument = args as? [String: Any]
    let hostName: String = (argument?["hostName"] as? String) ?? "127.0.0.1"
    let port: String = (argument?["port"] as? String) ?? "8090"
    let dataPath = (argument?["dataPath"] as? String) ?? getDefaultDirectory()
    let enablePocketbaseApiLogs: Bool = (argument?["enablePocketbaseApiLogs"] as? Bool) ?? true
    if dataPath == nil {
      result(FlutterError(code: "dataPathError", message: "Please pass valid datapath", details: nil))
      return
    }
    DispatchQueue.global(qos: .userInitiated).async {
      PocketbaseMobileStartPocketbase(dataPath!, hostName, port, enablePocketbaseApiLogs)
      self.isRunning = true
    }
    result(nil)
  }

  func stopPocketbase() {
    DispatchQueue.global(qos: .userInitiated).async {
      self.isRunning = false
      PocketbaseMobileStopPocketbase()
    }
  }

  func getDefaultDirectory() -> String? {
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    return paths.first
  }

  func getLocalIpAddress() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
      var ptr = ifaddr
      while ptr != nil {
        defer { ptr = ptr?.pointee.ifa_next }
        guard let interface = ptr?.pointee else { return "" }
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
          let name = String(cString: interface.ifa_name)
          if name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
            address = String(cString: hostname)
          }
        }
      }
      freeifaddrs(ifaddr)
    }
    return address
  }
}

class PocketMobileCallbackHandler: NSObject, PocketbaseMobileNativeBridgeProtocol {
  var appDelegate: AppDelegate
  init(appDelegate: AppDelegate) {
    self.appDelegate = appDelegate
  }

  func handleCallback(_ p0: String?, p1: String?) -> String {
    if p0 == "error" {
      appDelegate.isRunning = false
    }
    appDelegate.messageConnector?.sendMessage(["type": p0 ?? "", "data": p1 ?? ""])
    return "reply from ios native"
  }
}
