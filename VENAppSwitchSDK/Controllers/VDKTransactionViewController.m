#import "VenmoDefines_Internal.h"
#import "VDKTransactionViewController.h"
#import "VenmoActivityView.h"
#import "VenmoSDK.h"

@interface VDKTransactionViewController ()
- (UIWebView *)webView;
- (void)loadInitialRequest;
- (void)hideActivityViews;
- (void)cancel;
- (void)complete;
- (void)completeCancelled:(BOOL)cancelled;
- (void)dismiss;
@end

@implementation VDKTransactionViewController

#pragma mark - UIViewController

- (void)loadView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    webView.delegate = self;
    self.view = webView;
}

- (void)viewDidUnload {
    self.activityView = nil;
    // Keep venmoClient because it's set before viewDidLoad.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInitialRequest];
    self.activityView = [VenmoActivityView activityView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.webView isLoading]) {
        [self.activityView show];
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    DLog(@"should load: %@", request.URL);
    if ([request.URL.scheme isEqualToString:@"cancel"]) {
        [self cancel];
        return NO;
    }
    else if ([request.URL.scheme isEqualToString:[NSString stringWithFormat:@"venmo%@", [VenmoSDK sharedClient].appId]]) {
        [self complete];
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideActivityViews];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivityViews];

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Connection Error", nil)
                          message:NSLocalizedString(@"Venmo failed to load.", nil)
                          delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          otherButtonTitles:NSLocalizedString(@"Retry", nil), nil];
    [alert show];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self cancel];
    } else { // if (buttonIndex == 1)
        if (self.webView.request.URL) {
            [self.webView reload];
        } else {
            [self loadInitialRequest];
        }
    }
}


#pragma mark - Accessor @private

- (UIWebView *)webView {
    return (UIWebView *)self.view;
}


#pragma mark - Setup @private

- (void)loadInitialRequest {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.transactionURL]];
}

- (void)hideActivityViews {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityView hide];
}


#pragma mark - Teardown @private

- (void)cancel {
    [self completeCancelled:YES];
}

- (void)complete {
    [self completeCancelled:NO];
}

- (void)completeCancelled:(BOOL)cancelled {
    if (self.completionHandler) {
        self.completionHandler(self, cancelled);
    } else {
        [self dismiss];
    }
}

- (void)dismiss {
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
