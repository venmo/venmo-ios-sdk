#import "VDKPaymentViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface VDKPaymentViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *toTextField;
@property (strong, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transactionMethodControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *payRequestControl;

@end

@implementation VDKPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.amountTextField becomeFirstResponder];
    self.amountTextField.delegate = self.toTextField.delegate = self.noteTextField.delegate = self;
}


- (IBAction)sendAction:(id)sender {
    // Payment
    if (self.payRequestControl.selectedSegmentIndex == 0) {
        [[Venmo sharedInstance] sendPaymentTo:self.toTextField.text
                                       amount:self.amountTextField.text.floatValue*100
                                         note:self.noteTextField.text
                            completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                                    message:error.localizedRecoverySuggestion
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                alertView.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
                };
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"Transaction succeeded!"];
            }
        }];
    }
    // Request
    else {

    }
}


- (IBAction)selectedTransactionMethod:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    if (control.selectedSegmentIndex == 0) {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
    }
    else {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.amountTextField) {
        [self.toTextField becomeFirstResponder];
    }
    else if (textField == self.toTextField) {
        [self.noteTextField becomeFirstResponder];
    }
    else if (textField == self.noteTextField) {
        [self sendAction:nil];
    }
    return YES;
}


@end
