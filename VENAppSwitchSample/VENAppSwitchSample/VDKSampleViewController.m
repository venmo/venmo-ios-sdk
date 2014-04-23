#import "VDKSampleViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <VENAppSwitchSDK/VenmoSDK.h>
#import <VENAppSwitchSDK/VenmoSDK_Private.h>

@interface VDKSampleViewController ()
@property (strong, nonatomic) IBOutlet UITextField *toTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *noteTextField;
@end

@implementation VDKSampleViewController

- (void)viewDidLoad {
    // TODO: Fill these with your app info! Make sure to set your URL Types in Target Info as well.
    [VenmoSDK startWithAppId:@"1405" secret:@"H537ZNzLZufvwApCbgQEpqhBYjBjbmtD" name:@"VenmoATM"];
}

- (IBAction)userDidTapTransaction:(id)sender {
    NSString *recipient = self.toTextField.text;
    NSUInteger amount = [self.amountTextField.text floatValue] * 100;
    NSString *note = self.noteTextField.text;
    VDKTransaction *transaction = [VDKTransaction transactionWithType:VDKTransactionTypePay amount:amount note:note recipient:recipient];

    [[VenmoSDK sharedClient] sendTransaction:transaction withCompletionHandler:^(VDKTransaction *transaction, BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Transaction succeeded!");
            [SVProgressHUD showSuccessWithStatus:@"Transaction succeeded!"];
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"Transaction failed with error: %@", [error localizedDescription]];
            NSLog(@"%@", errorMessage);
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }
    }];
}

- (IBAction)userDidTapAuthorize:(id)sender {
    [[VenmoSDK sharedClient] requestPermissions:@[VDKPermissionAccessProfile] withCompletionHandler:^(BOOL success, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"oauth succeeded!"];
    }];
}

@end
