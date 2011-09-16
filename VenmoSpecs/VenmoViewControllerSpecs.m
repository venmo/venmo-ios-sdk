#import <Kiwi/Kiwi.h>

#import "VenmoViewController.h"
#import "VenmoViewController_Internal.h"

SPEC_BEGIN(VenmoViewControllerSpecs)

describe(@"VenmoViewController", ^{
    __block VenmoViewController *viewController;
    __block NSURL *transactionURL;

    beforeEach(^{
        viewController = [[VenmoViewController alloc] init];
        transactionURL = [NSURL URLWithString:@"https://venmo.com/"];
        viewController.transactionURL = transactionURL;
    });

    specify(^{ [[viewController.transactionURL should] beIdenticalTo:transactionURL]; });

    describe(@"its view", ^{
        it(@"is a UIWebView", ^{
            [[viewController.view should] beMemberOfClass:[UIWebView class]];
        });        

        it(@"has the applicationFrame", ^{
            [[theValue(viewController.view.frame) should] equal:
             theValue([[UIScreen mainScreen] applicationFrame])];
        });        

        it(@"loads the transactionURL", ^{
            NSURLRequest *transactionURLRequest = [NSURLRequest requestWithURL:transactionURL];
            UIWebView *webView = (UIWebView *)viewController.view;
            [[webView should] receive:@selector(loadRequest:) withArguments:transactionURLRequest];
            [viewController viewDidLoad];
        });        
    });
});

SPEC_END
