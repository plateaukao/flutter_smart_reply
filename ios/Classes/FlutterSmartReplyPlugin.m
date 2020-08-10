#import "FlutterSmartReplyPlugin.h"
#if __has_include(<flutter_smart_reply/flutter_smart_reply-Swift.h>)
#import <flutter_smart_reply/flutter_smart_reply-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_smart_reply-Swift.h"
#endif

@implementation FlutterSmartReplyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSmartReplyPlugin registerWithRegistrar:registrar];
}
@end
