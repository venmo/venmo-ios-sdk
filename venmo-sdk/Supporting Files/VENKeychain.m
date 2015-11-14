#import "VENKeychain.h"
@import Security;

static NSString *const VENKeychainService = @"venmo-ios-sdk";
static NSString *const VENKeychainAccountPrefix = @"venmo";


@interface VENKeychain ()

@property (nonatomic, copy) NSString *service;

- (NSData *)dataForAccount:(NSString *)account error:(NSError **)error;
- (BOOL)setData:(NSData *)string forAccount:(NSString *)account error:(NSError **)error;
- (BOOL)removeDataForAccount:(NSString *)account error:(NSError **)error;

@end


@implementation VENKeychain

#pragma mark - Initialization

- (instancetype)initWithService:(NSString *)service
{
    self = [super init];
    if (!self) return nil;

    self.service = service;

    return self;
}


#pragma mark - API

- (NSString *)stringForAccount:(NSString *)account error:(NSError * _Nullable __autoreleasing *)error
{
    NSParameterAssert(account);

    NSData *data = [self dataForAccount:account error:error];

    if (!data) {
        return nil;
    }

    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (!string && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:errSecDecode userInfo:nil];
        return nil;
    }

    return string;
}

- (BOOL)setString:(NSString *)string forAccount:(NSString *)account error:(NSError * _Nullable __autoreleasing *)error
{
    NSParameterAssert(string && account);

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    if (!data && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:errSecParam userInfo:nil];
        return NO;
    }

    return [self setData:data forAccount:account error:error];
}

- (BOOL)removeStringForAccount:(NSString *)account error:(NSError * _Nullable __autoreleasing *)error
{
    return [self removeDataForAccount:account error:error];
}

- (id<NSCoding>)objectForAccount:(NSString *)account error:(NSError **)error
{
    NSParameterAssert(account);

    NSData *data = [self dataForAccount:account error:error];

    if (!data) {
        return nil;
    }

    NSString *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (!object && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:errSecDecode userInfo:nil];
    }

    return object;
}

- (BOOL)setObject:(id<NSCoding>)object forAccount:(NSString *)account error:(NSError **)error
{
    NSParameterAssert(object && account);

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];

    if (!data && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:errSecParam userInfo:nil];
        return NO;
    }

    return [self setData:data forAccount:account error:nil];
}

- (BOOL)removeObjectForAccount:(NSString *)account error:(NSError **)error
{
    return [self removeDataForAccount:account error:error];
}


#pragma mark - Private

- (NSData *)dataForAccount:(NSString *)account error:(NSError **)error
{
    NSParameterAssert(account);

    NSMutableDictionary *query = [self queryForAccount:account];
    query[(__bridge id)kSecReturnData] = @YES;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;

    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);

    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:status userInfo:nil];
        return nil;
    }

    NSData *data = (__bridge_transfer NSData *)result;

    if (!data && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:errSecDecode userInfo:nil];
        return nil;
    }

    return data;
}

- (BOOL)setData:(NSData *)data forAccount:(NSString *)account error:(NSError **)error
{
    NSParameterAssert(data && account);

    OSStatus status;

    if ([self dataForAccount:account error:nil]) {
        NSMutableDictionary *query = [self queryForAccount:account];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[data copy] forKey:(__bridge id)kSecValueData];

        status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
    } else {
        NSMutableDictionary *query = [self queryForAccount:account];
        query[(__bridge id)kSecValueData] = [data copy];

        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }

    if (status != errSecSuccess && error) {
        *error = [[NSError alloc] initWithDomain:@"VENKeychainErrorDomain" code:status userInfo:nil];
        return NO;
    }

    return YES;
}

- (BOOL)removeDataForAccount:(NSString *)account error:(NSError **)error
{
    NSParameterAssert(account);

    NSMutableDictionary *query = [self queryForAccount:account];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);

    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:@"VENKeychainErrorDomain" code:status userInfo:nil];
        return NO;
    }

    return YES;
}

- (NSMutableDictionary *)queryForAccount:(NSString *)account
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge id)kSecAttrService] = self.service;
    query[(__bridge id)kSecAttrAccount] = account;

    return query;
}

@end
