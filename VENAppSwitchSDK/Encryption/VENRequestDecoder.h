#import <Foundation/Foundation.h>

@interface VENRequestDecoder : NSURLProtocol

+ (id)decodeSignedRequest:(NSString *)signedRequest withClientSecret:(NSString *)secretKey;

@end
