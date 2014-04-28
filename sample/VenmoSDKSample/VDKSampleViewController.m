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
    [Venmo startWithAppId:@"1405" secret:@"H537ZNzLZufvwApCbgQEpqhBYjBjbmtD" name:@"VenmoATM"];
}

- (IBAction)userDidTapTransaction:(id)sender {
    NSString *recipient = self.toTextField.text;
    NSUInteger amount = [self.amountTextField.text floatValue] * 100;
    NSString *note = self.noteTextField.text;
    [[Venmo sharedInstance] sendAppSwitchTransactionWithType:VENTransactionTypePay
                                                      amount:amount
                                                        note:note
                                                   recipient:recipient
                                           completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                                                [SVProgressHUD showSuccessWithStatus:@"hi!"];
                                                    }];
}

- (IBAction)userDidTapAuthorize:(id)sender {
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionAccessProfile] withCompletionHandler:^(BOOL success, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"oauth succeeded!"];
    }];
}

@end
