#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VENCore/VENCore.h>
#import "VENTransaction+VenmoSDK.h"
#import "VENErrors.h"
#import "VENSession.h"
#import "VENPermissionConstants.h"

@class VENUserSDK;
@class VENSession;

typedef void (^VENTransactionCompletionHandler)(VENTransaction *transaction, BOOL success, NSError *error);
typedef void (^VENOAuthCompletionHandler)(BOOL success, NSError *error);

#define VEN_CURRENT_SDK_VERSION @"1.0.0"

@interface Venmo : NSObject

@property (copy, nonatomic, readonly) NSString *appId;
@property (copy, nonatomic, readonly) NSString *appSecret;
@property (copy, nonatomic, readonly) NSString *appName;

/**
 * The user who is currently authenticated.
 */
@property (strong, nonatomic) VENUser *currentUser;

/**
 * The current session. It contains access token, refresh token, and expiration information.
 */
@property (strong, nonatomic) VENSession *currentSession;

@property (copy, nonatomic, readonly) VENTransactionCompletionHandler currentTransactionCompletionHandler;
@property (copy, nonatomic, readonly) VENOAuthCompletionHandler currentOAuthCompletionHandler;

/**
 * Returns the current shared Venmo instance.
 * @return The current Venmo instance
 */
+ (instancetype)sharedInstance;

- (BOOL)isConnected;
- (BOOL)handleOpenURL:(NSURL *)url;

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
 * Starts a Venmo SDK session.
 * @param appId Your app ID
 * @param appSecret Your app secret
 * @param appName Your app name (used in Venmo app to show "via [appName]"). Defaults to "Bundle name" in your Info.plist
 * @return YES if a new session started, NO if a session is already running.
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
