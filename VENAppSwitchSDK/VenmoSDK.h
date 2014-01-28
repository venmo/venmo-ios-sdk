#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VDKUser.h"
#import "VenmoErrors.h"
#import "VDKTransaction.h"
#import "VDKTransactionViewController.h"
#import "VDKSession.h"

@class VDKTransaction;
@class VDKUser;
@class VDKSession;
@class VDKTransactionViewController;

typedef void (^VDKTransactionCompletionHandler)(VDKTransaction *transaction, NSError *error);
typedef void (^VDKOAuthCompletionHandler)(BOOL success, NSError *error);

#define VDK_CURRENT_SDK_VERSION @"1.0.0"

@interface VenmoSDK : NSObject

@property (copy, nonatomic, readonly) NSString *appId;
@property (copy, nonatomic, readonly) NSString *appSecret;
@property (copy, nonatomic, readonly) NSString *appName; // Defaults to "Bundle name" in Info.plist
@property (copy, nonatomic, readonly) NSString *appLocalId;

@property (strong, nonatomic) VDKUser *currentUser;
@property (strong, nonatomic) VDKSession *currentSession;

@property (copy, nonatomic, readonly) VDKTransactionCompletionHandler currentTransactionCompletionHandler;
@property (copy, nonatomic, readonly) VDKOAuthCompletionHandler currentOAuthCompletionHandler;

/**
 * Starts a Venmo SDK session.
 * @param appId Your app ID
 * @param appSecret Your app secret
 * @param appName Your app name (used in Venmo app to show "via [appName]")
 * @param appLocalId Local id to distinguish between free & paid versions of your app
 * @return YES if a new session started, NO if a session is already running.
 */
+ (BOOL)startWithAppId:(NSString *)appId secret:(NSString *)appSecret
                name:(NSString *)appName localId:(NSString *)appLocalId;

+ (instancetype)sharedClient;

- (BOOL)isConnected;

/**
 * Initiates Venmo OAuth request.
 * @param permissions List of permissions.
 * @param completionHandler Completion handler to call upon returning from OAuth session.
 */
- (void)requestPermissions:(NSArray *)permissions withCompletionHandler:(VDKOAuthCompletionHandler)completionHandler;

/**
 * Sends Venmo transaction.
 * @param transaction The transaction to send.
 * @param completionHandler Completion handler to call after sending transaction.
 */
- (void)sendTransaction:(VDKTransaction *)transaction withCompletionHandler:(VDKTransactionCompletionHandler)completionHandler;

@end
