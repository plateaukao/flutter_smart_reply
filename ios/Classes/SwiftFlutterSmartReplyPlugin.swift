import Flutter
import UIKit
import MLKit

public class SwiftFlutterSmartReplyPlugin: NSObject, FlutterPlugin {
  lazy var smartReply = SmartReply.smartReply()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_smart_reply", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSmartReplyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    var conversation: [TextMessage] = []

    // Then, for each message sent and received:
    let message = TextMessage(
        text: "How are you?",
        timestamp: Date().timeIntervalSince1970,
        userID: "userId",
        isLocalUser: false)
    conversation.append(message)
    
    SmartReply.smartReply().suggestReplies(for: conversation) { result, error in
        guard error == nil, let result = result else {
            return
        }
        if (result.status == .notSupportedLanguage) {
            // The conversation's language isn't supported, so
            // the result doesn't contain any suggestions.
        } else if (result.status == .success) {
            // Successfully suggested smart replies.
            // ...
        }
    }
  }
}
