#import <Foundation/Foundation.h>
#import <VenmoAppSwitch/VenmoClient.h>

@interface VenmoClient ()

- (id)initWithAppId:(NSString *)theAppId secret:(NSString *)theAppSecret
               name:(NSString *)theAppName localId:(NSString *)theAppLocalId;

- (NSString *)URLPathWithTransaction:(VenmoTransaction *)transaction;
- (NSURL *)venmoURLWithPath:(NSString *)path;
- (NSURL *)webURLWithPath:(NSString *)path;

- (VenmoTransaction *)transactionWithURL:(NSURL *)url;
- (id)decodeSignedRequest:(NSString *)signedRequest;
- (id)JSONObjectWithData:(NSData *)data;

@end
