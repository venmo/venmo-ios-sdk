#import "VDKLoggedOutViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface VDKLoggedOutViewController ()

@end

@implementation VDKLoggedOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonAction:(id)sender {
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                [self performSegueWithIdentifier:@"presentLoggedInVC" sender:self];
                             }
                             else {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                                                                     message:error.localizedDescription
                                                                                    delegate:self
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                 alertView.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
                                     [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
                                 };
                             }
    }];
}

#pragma mark - Segues

- (IBAction)unwindFromLoggedInVC:(UIStoryboardSegue *)segue {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
