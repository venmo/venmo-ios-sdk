#import <Kiwi/Kiwi.h>

#import "VenmoClient_Private.h"
#import "VenmoClient.h"
#import "VenmoBase64_Internal.h"
#import "VenmoHMAC_SHA256_Internal.h"

SPEC_BEGIN(VenmoBase64Specs)

describe(@"VenmoBase64", ^{
    describe(@"-decodeSignedRequest:", ^{
        __block VenmoClient *client;
        __block NSString *signedRequest1;
        __block NSString *signedRequest2;

        beforeEach(^{
            signedRequest1 = @"FG1uGHoaGeNH2lxcfJG8AU1MBosRPTf_Wf6R5HQo-2Y.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyOTQ1MTY4MDAsImlzc3VlZF9hdCI6MTI5NDUxMjQ3Miwib2F1dGhfdG9rZW4iOiIxMjAwMjc3NDU0MzB8Mi5FS1NJd2FOZ21GN1c3aF9pTV9BM2Z3X18uMzYwMC4xMjk0NTE2ODAwLTUxNDQxN3xHV3dUT3FzWnI1S1pSUTBwVWFEMVB3MjhZSDgiLCJ1c2VyIjp7ImxvY2FsZSI6ImVuX1VTIiwiY291bnRyeSI6InVzIn0sInVzZXJfaWQiOiI1MTQ0MTcifQ";
            signedRequest2 = @"lufX_tvpTJ1dBUx0CRkOg_o6BZHVFuNZrcdYi3XwEds.W3sicGF5bWVudF9pZCI6IDE4MjA3NywgIm5vdGUiOiAiZm9yICN0ZXN0IiwgImFtb3VudCI6ICIwLjAxIiwgInN1Y2Nlc3MiOiAxfV0";
        });

        it(@"verifies", ^{
            client = [VenmoClient clientWithAppId:@"your_app_id" secret:@"bad_secret"];
            [[client decodeSignedRequest:signedRequest1] shouldBeNil];
        });

        it(@"decodes", ^{
            NSDictionary *request;
            client = [VenmoClient clientWithAppId:@"your_app_id"
                                           secret:@"4517b736d57a742c90bb42f26742f7b7"];
            NSString *userId = @"514417";
            request = [client decodeSignedRequest:signedRequest1];
            [[[request objectForKey:@"user_id"] should] equal:userId];

            client = [VenmoClient clientWithAppId:@"your_app_id"
                                           secret:@"h8dsDvAGJh6DrtdFVsBFKZR6PTGr8jcc"];
//            NSString *userId = @"514417";
            request = [client decodeSignedRequest:signedRequest2];
            [request shouldNotBeNil];
//            [[[request objectForKey:@"user_id"] should] equal:userId];
        });
    });

    it(@"-base64EncodedString & -base64DecodedData", ^{
        NSString *unencodedString = @"sam";
        NSString *encodedString = @"c2Ft";
        NSData *unencodedData = [unencodedString dataUsingEncoding:NSUTF8StringEncoding];
        [[[unencodedData base64EncodedString] should] equal:encodedString];
        [[[encodedString base64DecodedData] should] equal:unencodedData];

        unencodedString = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
        encodedString = @"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2ljaW5nIGVsaXQsIHNlZCBkbyBlaXVzbW9kIHRlbXBvciBpbmNpZGlkdW50IHV0IGxhYm9yZSBldCBkb2xvcmUgbWFnbmEgYWxpcXVhLiBVdCBlbmltIGFkIG1pbmltIHZlbmlhbSwgcXVpcyBub3N0cnVkIGV4ZXJjaXRhdGlvbiB1bGxhbWNvIGxhYm9yaXMgbmlzaSB1dCBhbGlxdWlwIGV4IGVhIGNvbW1vZG8gY29uc2VxdWF0LiBEdWlzIGF1dGUgaXJ1cmUgZG9sb3IgaW4gcmVwcmVoZW5kZXJpdCBpbiB2b2x1cHRhdGUgdmVsaXQgZXNzZSBjaWxsdW0gZG9sb3JlIGV1IGZ1Z2lhdCBudWxsYSBwYXJpYXR1ci4gRXhjZXB0ZXVyIHNpbnQgb2NjYWVjYXQgY3VwaWRhdGF0IG5vbiBwcm9pZGVudCwgc3VudCBpbiBjdWxwYSBxdWkgb2ZmaWNpYSBkZXNlcnVudCBtb2xsaXQgYW5pbSBpZCBlc3QgbGFib3J1bS4=";
        unencodedData = [unencodedString dataUsingEncoding:NSUTF8StringEncoding];
        [[[unencodedData base64EncodedString] should] equal:encodedString];
        [[[encodedString base64DecodedData] should] equal:unencodedData];

        unencodedString = @"http://www.cocoadev.com/index.pl?BaseSixtyFour";
        encodedString = @"aHR0cDovL3d3dy5jb2NvYWRldi5jb20vaW5kZXgucGw/QmFzZVNpeHR5Rm91cg==";
        unencodedData = [unencodedString dataUsingEncoding:NSUTF8StringEncoding];
        [[[unencodedData base64EncodedString] should] equal:encodedString];
        [[[encodedString base64DecodedData] should] equal:unencodedData];
    });

//    // warning: Unable to restore previously selected frame.
//    it(@"base64DecodedString", ^{
//        NSString *string = @"hello world";
//        NSData *data = [@"hello world" dataUsingEncoding:NSASCIIStringEncoding];
//        [[string should] receive:@selector(base64DecodedData) andReturn:data];
//        [[[string base64DecodedString] should] equal:@"hello world"];
//    });

    it(@"HMAC_SHA256", ^{
        NSString *actualDataString = [VenmoHMAC_SHA256(@"key", @"data") base64EncodedString];
        NSString *expectedDataString = @"UDH+PZicbRU3oBP6bnOdojRj/a7DtwE32Cjjas4iG9A=";
        [[actualDataString should] equal:expectedDataString];
    });
});

SPEC_END
