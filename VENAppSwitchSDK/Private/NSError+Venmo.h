#import <Foundation/Foundation.h>

@interface NSError (Venmo)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code
          description:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion;

@end
