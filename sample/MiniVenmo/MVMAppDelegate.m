#import "MVMAppDelegate.h"
#import <Venmo-iOS-SDK/Venmo.h>

@implementation MVMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Venmo startWithAppId:@"1713" secret:@"fvY3AJTbvk7emZa3UGnMM7jAGqKyL2vR" name:@"Venmo iOS SDK Sample"];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

@end
