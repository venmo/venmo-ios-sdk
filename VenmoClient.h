#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VenmoTransaction;
@class VenmoViewController;

typedef void (^VenmoTransactionCompletionHandler)(VenmoTransaction *transaction, NSError *error);

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
@protocol VenmoClientDelegate;
#endif

@interface VenmoClient : NSObject

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
@property (assign, nonatomic) id<VenmoClientDelegate> delegate;
#endif
@property (copy, nonatomic, readonly) NSString *appId;
@property (copy, nonatomic, readonly) NSString *appSecret;
@property (copy, nonatomic) NSString *appName;
@property (copy, nonatomic) NSString *appLocalId;

/**
 * appName defaults to the value of "Bundle name" in the third-party app's Info.plist file.
 * The Venmo iPhone app displays "via [appName]" as a subtitle of the pay/charge view.
 * Use appLocalId to distinguish between free & paid versions of your app.
 */
+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret;
+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
                 name:(NSString *)theAppName;
+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
              localId:(NSString *)theAppLocalId;
+ (id)clientWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
                 name:(NSString *)theAppName localId:(NSString *)theAppLocalId;

#pragma mark - Sending a Transaction

/**
 * If the device has the Venmo app installed, this method opens the Venmo app and returns nil.
 * Else, it returns a VenmoViewController, which has a UIWebView as it's view property.
 * On load, this UIWebView loads the Venmo web page according to the transaction argument.
 */
- (VenmoViewController *)viewControllerWithTransaction:(VenmoTransaction *)transaction;

/**
 * If forceWeb:NO, this method is equivalent to -viewControllerWithTransaction:.
 * Else, it acts like -viewControllerWithTransaction: as if the Venmo app is not installed.
 */
- (VenmoViewController *)viewControllerWithTransaction:(VenmoTransaction *)transaction
                                              forceWeb:(BOOL)forceWeb;

#pragma mark - Receiving a Transaction

/**
 * To confirm a transaction, call this method in application:openURL:sourceApplication:annotation:.
 * It attempts to convert the url argument into a VenmoTransaction object.
 * If successful, it returns YES, else NO.
 * Use the completion block to handle the resulting transaction.
 * The transaction will be nil on error, and the error will be NULL on success.
 */
- (BOOL)openURL:(NSURL *)url completionHandler:(VenmoTransactionCompletionHandler)completion;

@end


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
@protocol VenmoClientDelegate <NSObject>

@required

/**
 * Implement this method if your application supports iOS < 5 (iOS Deployment Target < iOS 5).
 * Your implementation should parse the data argument into a JSON object (NSArray or NSDictionary)
 * and return the result.
 */
- (id)venmoClient:(VenmoClient *)client JSONObjectWithData:(NSData *)data;

@end
#endif
