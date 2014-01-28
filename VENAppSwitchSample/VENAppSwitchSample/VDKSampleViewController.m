#import "VDKSampleViewController.h"
#import <VENAppSwitchSDK/VenmoSDK.h>

@implementation VDKSampleViewController

- (void)viewDidLoad {
    [VenmoSDK startWithAppId:@"1234" secret:@"foobar" name:@"Sample app" localId:@"blah"];
}

- (IBAction)userDidTapOAuth:(id)sender {
    [[VenmoSDK sharedClient] requestPermissions:@[@"login"] withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"oauth yay");
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (IBAction)userDidTapTransaction:(id)sender {
    NSString *note = [NSString stringWithFormat:@"hello world (%@)", [NSDate date]];
    VDKTransaction *transaction = [VDKTransaction transactionWithType:VDKTransactionTypePay amount:100 note:note recipient:@"kortina"];
    [[VenmoSDK sharedClient] sendTransaction:transaction withCompletionHandler:^(VDKTransaction *transaction, NSError *error) {
        if (error) {
            NSLog(@"errrrr: %@", [error localizedDescription]);
        } else {
            NSLog(@"transaction yay");
        }
    }];
}
@end
