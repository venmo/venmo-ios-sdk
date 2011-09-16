#import <UIKit/UIKit.h>
#import <Venmo/Venmo.h>

@class WelcomeViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, VenmoClientDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WelcomeViewController *welcomeViewController;
@property (strong, nonatomic) VenmoClient *venmoClient;

@end
