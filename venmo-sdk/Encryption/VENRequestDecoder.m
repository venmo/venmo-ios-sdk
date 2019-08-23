#import "VENRequestDecoder.h"
#import "VENBase64_Internal.h"
#import "Venmo.h"
#import "VENHMAC_SHA256_Internal.h"
#import "GTMStringEncoding.h"

@implementation VENRequestDecoder

+ (id)decodeSignedRequest:(NSString *)signedRequest withClientSecret:(NSString *)secretKey {

    if (!signedRequest) {
        return nil;
    }

    @try {
        NSArray *encodedSignature_encodedDataString = [signedRequest componentsSeparatedByString:@"."];
        //NSString *encodedSignature = encodedSignature_encodedDataString[0];
        NSString *encodedSignatureString = encodedSignature_encodedDataString[0];
        NSString *encodedDataString = encodedSignature_encodedDataString[1];

        GTMStringEncoding *GTMencodedPayload = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
        //encodedSignature = [encodedSignature stringByAppendingString:@"=="];
        //encodedSignature = [encodedSignature stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
        //encodedSignature = [encodedSignature stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

        //NSData *signature = [encodedSignature base64DecodedData];
        NSData *returnedSignature = [GTMencodedPayload decode:encodedSignatureString];
        NSData *returnedPayloadData = [GTMencodedPayload decode:encodedDataString];
        NSData *expectedSignature = VENHMAC_SHA256(secretKey, encodedDataString);

        //if ([signature isEqualToData:expectedSignature]) {
            //return [NSJSONSerialization JSONObjectWithData:[encodedDataString base64DecodedData] options:0 error:NULL];
        if ([returnedSignature isEqualToData:expectedSignature]) {
            return [NSJSONSerialization JSONObjectWithData:returnedPayloadData options:0 error:NULL];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
