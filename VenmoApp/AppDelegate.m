#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "JSONKit.h"

static NSString *const kVenmoAppId      = @"your_app_id";
static NSString *const kVenmoAppSecret  = @"your_app_secret";

@implementation AppDelegate

@synthesize window;
@synthesize welcomeViewController;
@synthesize venmoClient;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    venmoClient = [VenmoClient clientWithAppId:kVenmoAppId secret:kVenmoAppSecret];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
    venmoClient.delegate = self;
#endif

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.welcomeViewController = [[WelcomeViewController alloc] init];
    welcomeViewController.venmoClient = venmoClient;
    window.rootViewController = welcomeViewController;
    [window makeKeyAndVisible];

    if (launchOptions) {
        NSURL *openURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        if ([[UIApplication sharedApplication] canOpenURL:openURL]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", url);
    return [venmoClient openURL:url completionHandler:^(VenmoTransaction *transaction, NSError *error) {
        if (transaction) {
            NSString *success = (transaction.success ? @"Success" : @"Failure");
            NSString *title = [@"Transaction " stringByAppendingString:success];
            NSString *message = [@"payment_id: " stringByAppendingFormat:@"%i. %i %@ %@ (%i) $%@ %@",
                                 transaction.id,
                                 transaction.fromUserId,
                                 transaction.typeStringPast,
                                 transaction.toUserHandle,
                                 transaction.toUserId,
                                 transaction.amountString,
                                 transaction.note];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else { // error
            NSLog(@"transaction error code: %i", error.code);
        }
    }];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#pragma mark - VenmoClientDelegate

- (id)venmoClient:(VenmoClient *)client JSONObjectWithData:(NSData *)data {
    // Instantiating a JSONDecoder ivar with a lazy getter might perform better than the below,
    // especially if the user is completing numerous, consecutive transactions.
    return [data objectFromJSONData];
}
#endif

@end
