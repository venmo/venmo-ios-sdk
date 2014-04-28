#import "VDKAppDelegate.h"
#import <VenmoSDK/Venmo.h>

@implementation VDKAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }

    return NO;
}

@end
