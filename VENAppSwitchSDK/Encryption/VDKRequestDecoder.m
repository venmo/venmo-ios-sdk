#import "VDKRequestDecoder.h"
#import "VenmoBase64_Internal.h"
#import "VenmoSDK.h"
#import "VenmoHMAC_SHA256_Internal.h"

@implementation VDKRequestDecoder

+ (id)decodeSignedRequest:(NSString *)signedRequest withClientSecret:(NSString *)secretKey {

    if (!signedRequest) {
        return nil;
    }

    @try {
        NSArray *encodedSignature_encodedDataString = [signedRequest componentsSeparatedByString:@"."];
        NSString *encodedSignature = encodedSignature_encodedDataString[0];
        NSString *encodedDataString = encodedSignature_encodedDataString[1];

        encodedSignature = [encodedSignature stringByAppendingString:@"=="];
        encodedSignature = [encodedSignature stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
        encodedSignature = [encodedSignature stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

        NSData *signature = [encodedSignature base64DecodedData];
        NSData *expectedSignature = VenmoHMAC_SHA256(secretKey, encodedDataString);

        if ([signature isEqualToData:expectedSignature]) {
            return [NSJSONSerialization JSONObjectWithData:[encodedDataString base64DecodedData] options:0 error:NULL];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
