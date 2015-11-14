@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VENKeychain : NSObject

@property (nonatomic, copy, readonly) NSString *service;

- (instancetype)initWithService:(NSString *)service;

- (NSString *)stringForAccount:(NSString *)account error:(NSError **)error;
- (BOOL)setString:(NSString *)string forAccount:(NSString *)account error:(NSError **)error;
- (BOOL)removeStringForAccount:(NSString *)account error:(NSError **)error;

- (id<NSCoding>)objectForAccount:(NSString *)account error:(NSError **)error;
- (BOOL)setObject:(id<NSCoding>)object forAccount:(NSString *)account error:(NSError **)error;
- (BOOL)removeObjectForAccount:(NSString *)account error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
