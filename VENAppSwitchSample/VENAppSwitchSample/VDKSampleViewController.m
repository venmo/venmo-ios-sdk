#import "VDKSampleViewController.h"
#import <VENAppSwitchSDK/VenmoSDK.h>

@implementation VDKSampleViewController

- (void)viewDidLoad {
    [VenmoSDK startWithAppId:@"1336" secret:@"r8YH6sz3ySSNLtkPQG4kV9u9nvnvksPY" name:@"API Test" localId:@""];
}

- (IBAction)userDidTapOAuth:(id)sender {
    [[VenmoSDK sharedClient] requestPermissions:@[@"make_payments"] withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"oauth yay");
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (IBAction)userDidTapTransaction:(id)sender {
    NSString *note = [NSString stringWithFormat:@"hello world (%@)", [NSDate date]];
    VDKTransaction *transaction = [VDKTransaction transactionWithType:VDKTransactionTypePay amount:1 note:note recipient:@"ayaka"];
    [[VenmoSDK sharedClient] sendTransaction:transaction withCompletionHandler:^(VDKTransaction *transaction, NSError *error) {
        if (error) {
            NSLog(@"errrrr: %@", [error localizedDescription]);
        } else {
            NSLog(@"transaction yay");
        }
    }];
}

@end
