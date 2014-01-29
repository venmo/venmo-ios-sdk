#import "VDKAppDelegate.h"
#import <VENAppSwitchSDK/VenmoSDK.h>

@implementation VDKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([[VenmoSDK sharedClient] handleOpenURL:url]) {
        return YES;
    }

    return NO;
}

@end
