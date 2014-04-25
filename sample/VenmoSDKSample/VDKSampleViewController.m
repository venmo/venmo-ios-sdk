#import "VDKSampleViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <VenmoSDK/Venmo.h>

@interface VDKSampleViewController ()
@property (strong, nonatomic) IBOutlet UITextField *toTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *noteTextField;
@end

@implementation VDKSampleViewController

- (void)viewDidLoad {
    // TODO: Fill these with your app info! Make sure to set your URL Types in Target Info as well.
    [Venmo startWithAppId:@"VENMO_APP_ID" secret:@"VENMO_APP_SECRET" name:@"My App Name"];
}

- (IBAction)userDidTapTransaction:(id)sender {
    NSString *recipient = self.toTextField.text;
    NSUInteger amount = [self.amountTextField.text floatValue] * 100;
    NSString *note = self.noteTextField.text;
//    VENTransaction *transaction = [VENTransaction transactionWithType:VENTransactionTypePay amount:amount note:note recipient:recipient];
//    [[Venmo sharedClient] sendTransaction:transaction withCompletionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
//        if (success) {
//            NSLog(@"Transaction succeeded!");
//            [SVProgressHUD showSuccessWithStatus:@"Transaction succeeded!"];
//        } else {
//            NSString *errorMessage = [NSString stringWithFormat:@"Transaction failed with error: %@", [error localizedDescription]];
//            NSLog(@"%@", errorMessage);
//            [SVProgressHUD showErrorWithStatus:errorMessage];
//        }
//    }];
}

- (IBAction)userDidTapAuthorize:(id)sender {
    [[Venmo sharedClient] requestPermissions:@[VENPermissionAccessProfile] withCompletionHandler:^(BOOL success, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"oauth succeeded!"];
    }];
}

@end
