#import <VenmoAppSwitch/VenmoViewController.h>

@class VenmoActivityView;
@class VenmoClient;

@interface VenmoViewController ()

@property (strong, nonatomic) VenmoActivityView *activityView;
@property (strong, nonatomic) NSURL *transactionURL;
@property (strong, nonatomic) VenmoClient *venmoClient;

@end
