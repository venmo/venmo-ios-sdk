//
//  VDKAppDelegate.m
//  VENAppSwitchSample
//
//  Created by Ayaka Nonaka on 1/28/14.
//  Copyright (c) 2014 Venmo. All rights reserved.
//

#import "VDKAppDelegate.h"
#import <VENAppSwitchSDK/VenmoSDK.h>
#import <VENAppSwitchSDK/VDKURLProtocol.h>

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
