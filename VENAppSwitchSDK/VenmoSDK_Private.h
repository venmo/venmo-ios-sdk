#import <Foundation/Foundation.h>

@interface VenmoSDK (Private)

@property (assign, nonatomic) BOOL internalDevelopment;

- (NSString *)baseURLPath;
- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName;

@end