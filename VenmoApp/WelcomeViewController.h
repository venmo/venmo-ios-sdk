#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

@class VenmoClient;

@interface WelcomeViewController : UIViewController

@property (strong, nonatomic) VenmoClient *venmoClient;
@property (strong, nonatomic) VenmoTransaction *venmoTransaction;

@end
