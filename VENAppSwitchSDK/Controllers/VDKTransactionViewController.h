#import <UIKit/UIKit.h>

@class VDKTransactionViewController;
@class VenmoActivityView;
@class VenmoSDK;

typedef void (^VenmoViewControllerCompletionHandler)(VDKTransactionViewController *viewController, BOOL cancelled);

@interface VDKTransactionViewController : UIViewController <UIWebViewDelegate>

/**
 * Set completionHandler to override the default behavior: On completion, whether the transaction
 * was cancelled or completed, the VenmoViewController object dismisses itself by assuming it was
 * either presented modally or pushed by a UINavigationController.
 */
@property (strong, nonatomic) VenmoViewControllerCompletionHandler completionHandler;

@property (strong, nonatomic) VenmoActivityView *activityView;
@property (strong, nonatomic) NSURL *transactionURL;

@end
