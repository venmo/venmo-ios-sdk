#import "WelcomeViewController.h"

@interface WelcomeViewController ()
- (void)openVenmoAction;
- (void)openWebAction;
@end

@implementation WelcomeViewController

@synthesize venmoClient;
@synthesize venmoTransaction;

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"VenmoApp", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.type = VenmoTransactionTypePay;
    venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString:@"3.45"];
    venmoTransaction.note = @"hello world";
    venmoTransaction.toUserHandle = @"mattdipasquale";

    // Create two buttons: one for Venmo...
    CGRect buttonRect = CGRectMake(40.0f, 20.0f, 90.0f, 40.0f);
    UIButton *venmoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    venmoButton.frame = buttonRect;
    [venmoButton setTitle:@"Venmo" forState:UIControlStateNormal];
    [venmoButton addTarget:self action:@selector(openVenmoAction)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:venmoButton];

    // ... and one for web.
    buttonRect.origin.x += 150.0f;
    UIButton *webButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    webButton.frame = buttonRect;
    [webButton setTitle:@"Web" forState:UIControlStateNormal];
    [webButton addTarget:self action:@selector(openWebAction)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Actions @private

// Note: Set venmoViewController.completionHandler below if you present venmoViewController
// in a different manner than by presenting it modally or by pushing it on a UINavigationController.

- (void)openVenmoAction {
    VenmoViewController *venmoViewController = [venmoClient viewControllerWithTransaction:
                                                venmoTransaction];
    if (venmoViewController) {
        [self presentModalViewController:venmoViewController animated:YES];
    }
}

- (void)openWebAction {
    VenmoViewController *venmoViewController = [venmoClient viewControllerWithTransaction:
                                                venmoTransaction forceWeb:YES];
    [self presentModalViewController:venmoViewController animated:YES];
}

@end
