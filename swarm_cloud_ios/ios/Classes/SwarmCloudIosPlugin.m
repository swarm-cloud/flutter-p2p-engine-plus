#import "SwarmCloudIosPlugin.h"
#if __has_include(<swarm_cloud_ios/swarm_cloud_ios-Swift.h>)
#import <swarm_cloud_ios/swarm_cloud_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "swarm_cloud_ios-Swift.h"
#endif

@implementation SwarmCloudIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSwarmCloudIosPlugin registerWithRegistrar:registrar];
}
@end
