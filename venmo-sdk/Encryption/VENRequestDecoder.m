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
        NSString *encodedSignatureString = encodedSignature_encodedDataString[0];
        NSString *encodedDataString = encodedSignature_encodedDataString[1];
        
        GTMStringEncoding *GTMencodedPayload = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];

        NSData *returnedSignature = [GTMencodedPayload decode:encodedSignatureString];
        NSData *returnedPayloadData = [GTMencodedPayload decode:encodedDataString];
        
        NSData *expectedSignature = VENHMAC_SHA256(secretKey, encodedDataString);

        if ([returnedSignature isEqualToData:expectedSignature]) {
            return [NSJSONSerialization JSONObjectWithData:returnedPayloadData options:0 error:NULL];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
