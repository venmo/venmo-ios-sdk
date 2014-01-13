#import <Kiwi/Kiwi.h>
#import "VenmoClient.h"
#import "VenmoTransaction.h"
#import "VenmoViewController.h"

SPEC_BEGIN(VenmoClientSpecs)

describe(@"VenmoClient", ^{
    __block VenmoClient *client;
    __block NSString *URLPath;
    __block VenmoTransaction *transaction;

    beforeEach(^{
        client = [VenmoClient clientWithAppId:@"your_app_id" secret:@"your_app_secret"
                                            localId:@"your_app_local_id"];
        URLPath = [NSString stringWithFormat:@"/?client=ios&app_name=VenmoApp&"
                   "app_id=your_app_id&app_local_id=your_app_local_id&txn=pay&amount=3.45&"
                   "note=hello world&recipients=shreyanstest&device_id=%@",
                   [[UIDevice currentDevice] uniqueIdentifier]];
        transaction = [[VenmoTransaction alloc] init];
        transaction.type = VenmoTransactionTypePay;
        transaction.amount = [NSDecimalNumber decimalNumberWithString:@"3.45"];
        transaction.note = @"hello world";
        transaction.toUserHandle = @"shreyanstest";
    });

    describe(@"-clientWithAppId:secret:", ^{
        it(@"returns a client", ^{ [client shouldNotBeNil]; });
        it(@"sets appId", ^{ [[client.appId should] equal:@"your_app_id"]; });
        it(@"sets appSecret", ^{ [[client.appSecret should] equal:@"your_app_secret"]; });
    });

//    describe(@"-viewControllerWithTransaction:", ^{
//        it(@"calls -viewControllerWithTransaction:forceWeb:NO", ^{
//            [[client should] receive:@selector(viewControllerWithTransaction:forceWeb:)
//                       withArguments:transaction, theValue(NO)];
//            [client viewControllerWithTransaction:transaction];
//        });
//    });

    describe(@"-viewControllerWithTransaction:forceWeb:", ^{
        __block UIApplication *app;

        beforeEach(^{
            app = [UIApplication sharedApplication];
        });

        context(@"forceWeb:NO", ^{
            it(@"checks if app canOpenURL:transactionURL", ^{
                NSURL *venmoURL = [NSURL URLWithString:@"https://venmo.com/"];
                [[client should] receive:@selector(venmoURLWithPath:) andReturn:venmoURL];
                [[app should] receive:@selector(canOpenURL:) withArguments:venmoURL];
                [client viewControllerWithTransaction:transaction forceWeb:NO];
            });

            it(@"returns nil if canOpenURL:transactionURL", ^{
                [[app should] receive:@selector(canOpenURL:) andReturn:theValue(YES)];
                [[app should] receive:@selector(openURL:)];
                [[client viewControllerWithTransaction:transaction forceWeb:NO] shouldBeNil];
            });

            it(@"returns a new VenmoViewController if not canOpenURL:transactionURL", ^{
                [[app should] receive:@selector(canOpenURL:) andReturn:theValue(NO)];
                [[[client viewControllerWithTransaction:transaction forceWeb:NO] should]
                 beKindOfClass:[VenmoViewController class]];
            });
        });

        context(@"forceWeb:YES", ^{
            it(@"bypasses canOpenURL:transactionURL check", ^{
                [[app shouldNot] receive:@selector(canOpenURL:)];
                [client viewControllerWithTransaction:transaction forceWeb:YES];
            });

            it(@"always returns a new VenmoViewController", ^{
                [[[client viewControllerWithTransaction:transaction forceWeb:YES] should]
                 beKindOfClass:[VenmoViewController class]];
            });
        });

        it(@"sets the returned VenmoViewController's transactionURL", ^{
            NSURL *webURL = [NSURL URLWithString:@"https://venmo.com/"];
            [[client should] receive:@selector(webURLWithPath:) andReturn:webURL];
            VenmoViewController *venmoController = [client viewControllerWithTransaction:transaction
                                                                                forceWeb:YES];
            [[venmoController.transactionURL should] beIdenticalTo:webURL];
        });
    });

    describe(@"-transactionsWithOptions:", ^{

    });

    describe(@"-transactionWithURL:sourceApplication:", ^{

    });

//    - (id)transactionWithOptions:(NSDictionary *)launchOptions {
//        return nil;
//    }
//
//    - (id)transactionWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
//        return nil;
//    }

    describe(@"-URLPathWithTransaction:", ^{
        it(@"returns the correct URL path", ^{
            [[[client URLPathWithTransaction:transaction] should] equal:URLPath];
        });
    });

    describe(@"-venmoURLWithPath:", ^{
        it(@"returns venmo URL", ^{
            NSURL *venmoURL = [[NSURL alloc] initWithScheme:@"venmosdk" host:@"venmo.com"
                                                       path:URLPath];
            [[[client venmoURLWithPath:URLPath] should] equal:venmoURL];
        });
    });

    describe(@"-webURLWithPath:", ^{
        it(@"returns web URL", ^{
            NSString *path = [@"/touch/signup_to_pay" stringByAppendingString:URLPath];
            NSURL *webURL = [[NSURL alloc] initWithScheme:@"https" host:@"venmo.com" path:path];
            [[[client webURLWithPath:URLPath] should] equal:webURL];
        });
    });
});

SPEC_END
