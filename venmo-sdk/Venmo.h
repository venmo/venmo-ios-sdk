@import Foundation;
@import UIKit;

#import <VENCore/VENCore.h>

#import "VENErrors.h"
#import "VENPermissionConstants.h"
#import "VENSession.h"
#import "VENTransaction+VenmoSDK.h"

@class VENUserSDK;
@class VENSession;

typedef void (^VENTransactionCompletionHandler)(VENTransaction *transaction, BOOL success, NSError *error);
typedef void (^VENOAuthCompletionHandler)(BOOL success, NSError *error);

#define VEN_CURRENT_SDK_VERSION @"1.0.0"

@interface Venmo : NSObject

@property (copy, nonatomic, readonly) NSString *appId;
@property (copy, nonatomic, readonly) NSString *appSecret;
@property (copy, nonatomic, readonly) NSString *appName;

- (BOOL)handleOpenURL:(NSURL *)url;

/**
 * The current session.
 */
@property (strong, nonatomic) VENSession *session;

@property (copy, nonatomic, readonly) VENTransactionCompletionHandler currentTransactionCompletionHandler;
@property (copy, nonatomic, readonly) VENOAuthCompletionHandler currentOAuthCompletionHandler;

/**
 * Returns the shared Venmo instance.
 * @return The shared Venmo instance
 */
+ (instancetype)sharedInstance;

/**
 * Returns YES if the current device has the Venmo app installed
 */
- (BOOL)venmoAppInstalled;

/**
 * Initiates Venmo OAuth request.
 * @param permissions List of permissions.
 * @param completionHandler Completion handler to call upon returning from OAuth session.
 */
- (void)requestPermissions:(NSArray *)permissions withCompletionHandler:(VENOAuthCompletionHandler)completionHandler;

/**
 * Invalidates the current user session.
 *
 * Not that this method doesn't unauthorize the app.
 * To unauthorize an app, go to "Password & Authorizations" at https://venmo.com/account/settings/account
 */
- (void)logout;

/**
 * Starts the Venmo SDK.
 * @param appId Your app ID
 * @param appSecret Your app secret
 * @param appName Your app name (used in Venmo app to show "via [appName]"). Defaults to "Bundle name" in your Info.plist
 * @return A boolean value indicating whether a cached session was found for the given app details.
 * If this method returns NO, you will need to create a session by calling requestPermissions:withCompletionHandler.
 */
+ (BOOL)startWithAppId:(NSString *)appId
                secret:(NSString *)appSecret
                  name:(NSString *)appName;

/**
 * Sends a transaction by switching to the Venmo app.
 */
- (void)sendAppSwitchTransactionWithType:(VENTransactionType)type
                                  amount:(NSUInteger)amount
                                    note:(NSString *)note
                               recipient:(NSString *)recipientHandle
                       completionHandler:(VENTransactionCompletionHandler)completionHandler;

@end
