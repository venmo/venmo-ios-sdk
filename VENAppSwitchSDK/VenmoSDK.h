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

@interface VenmoSDK : NSObject

@property (copy, nonatomic, readonly) NSString *appId;
@property (copy, nonatomic, readonly) NSString *appSecret;
@property (copy, nonatomic, readonly) NSString *appName;
@property (copy, nonatomic, readonly) NSString *appLocalId;

@property (strong, nonatomic) VDKUser *currentUser;
@property (strong, nonatomic) VDKSession *currentSession;
@property (copy, nonatomic) VDKTransactionCompletionHandler currentCompletionHandler;

/**
 * appName defaults to the value of "Bundle name" in the third-party app's Info.plist file.
 * The Venmo iPhone app displays "via [appName]" as a subtitle of the pay/charge view.
 * Use appLocalId to distinguish between free & paid versions of your app.
 */
+ (instancetype)sharedClient;
+ (BOOL)startWithAppId:(NSString *)appId secret:(NSString *)appSecret
                 name:(NSString *)appName localId:(NSString *)appLocalId;

#pragma mark - Connecting with OAuth

- (void)requestPermissions:(NSArray *)permissions withCompletionHandler:(VDKTransactionCompletionHandler)completionHandler;

/**
 *  Returns true if the user has signed in
 **/
- (BOOL)isConnected;

#pragma mark - Sending a Transaction

/**
 * If the device has the Venmo app installed, this method opens the Venmo app and returns nil.
 * Else, it returns a VenmoViewController, which has a UIWebView as it's view property.
 * On load, this UIWebView loads the Venmo web page according to the transaction argument.
 */
- (VDKTransactionViewController *)viewControllerWithTransaction:(VDKTransaction *)transaction;

/**
 * If forceWeb:NO, this method is equivalent to -viewControllerWithTransaction:.
 * Else, it acts like -viewControllerWithTransaction: as if the Venmo app is not installed.
 */
- (VDKTransactionViewController *)viewControllerWithTransaction:(VDKTransaction *)transaction
                                                       forceWeb:(BOOL)forceWeb;

@end

