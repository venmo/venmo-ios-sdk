#import "VENPermission.h"

@implementation VENPermission

- (instancetype)initWithType:(VENPermissionType)permissionType {
    self = [super init];
    if (self) {
        self.type = permissionType;
    }
    return self;
}

- (NSString *)name {
    switch (self.type) {
        case VENPermissionTypeAccessFriends:
            return @"access_friends";
        case VENPermissionTypeAccessEmail:
            return @"access_email";
        case VENPermissionTypeAccessPhone:
            return @"access_phone";
        case VENPermissionTypeAccessProfile:
            return @"access_profile";
        case VENPermissionTypeAccessBalance:
            return @"access_balance";
        case VENPermissionTypeMakePayments:
            return @"make_payments";
        default:
            return @"invalid_scope";
    }
}

- (NSString *)displayText {
    switch (self.type) {
        case VENPermissionTypeAccessFriends:
            return NSLocalizedString(@"access friends", nil);
        case VENPermissionTypeAccessEmail:
            return NSLocalizedString(@"access email", nil);
        case VENPermissionTypeAccessPhone:
            return NSLocalizedString(@"access phone", nil);
        case VENPermissionTypeAccessProfile:
            return NSLocalizedString(@"access profile", nil);
        case VENPermissionTypeAccessBalance:
            return NSLocalizedString(@"access balance", nil);
        case VENPermissionTypeMakePayments:
            return NSLocalizedString(@"make payments and charges", nil);
        default:
            return @"";
    }
}

+ (VENPermissionType)typeForName:(NSString *)name {
    if ([name isEqualToString:@"access_friends"]) {
        return VENPermissionTypeAccessFriends;
    }
    else if ([name isEqualToString:@"access_email"]) {
        return VENPermissionTypeAccessEmail;
    }
    else if ([name isEqualToString:@"access_phone"]) {
        return VENPermissionTypeAccessPhone;
    }
    else if ([name isEqualToString:@"access_profile"]) {
        return VENPermissionTypeAccessProfile;
    }
    else if ([name isEqualToString:@"access_balance"]) {
        return VENPermissionTypeAccessBalance;
    }
    else if ([name isEqualToString:@"make_payments"]) {
        return VENPermissionTypeMakePayments;
    }
    else {
        return VENPermissionTypeUnknown;
    }
}

@end
