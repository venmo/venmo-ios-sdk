#import "VDKPermission.h"

@implementation VDKPermission

- (instancetype)initWithType:(VDKInternalPermissionType)permissionType {
    self = [super init];
    if (self) {
        self.type = permissionType;
    }
    return self;
}

- (NSString *)name {
    switch (self.type) {
        case VDKInternalPermissionTypeAccessFriends:
            return @"access_friends";
        case VDKInternalPermissionTypeAccessEmail:
            return @"access_email";
        case VDKInternalPermissionTypeAccessPhone:
            return @"access_phone";
        case VDKInternalPermissionTypeAccessProfile:
            return @"access_profile";
        case VDKInternalPermissionTypeAccessBalance:
            return @"access_balance";
        case VDKInternalPermissionTypeMakePayments:
            return @"make_payments";
        default:
            return @"invalid_scope";
    }
}

- (NSString *)displayText {
    switch (self.type) {
        case VDKInternalPermissionTypeAccessFriends:
            return NSLocalizedString(@"access friends", nil);
        case VDKInternalPermissionTypeAccessEmail:
            return NSLocalizedString(@"access email", nil);
        case VDKInternalPermissionTypeAccessPhone:
            return NSLocalizedString(@"access phone", nil);
        case VDKInternalPermissionTypeAccessProfile:
            return NSLocalizedString(@"access profile", nil);
        case VDKInternalPermissionTypeAccessBalance:
            return NSLocalizedString(@"access balance", nil);
        case VDKInternalPermissionTypeMakePayments:
            return NSLocalizedString(@"make payments and charges", nil);
        default:
            return @"";
    }
}

+ (VDKInternalPermissionType)typeForName:(NSString *)name {
    if ([name isEqualToString:@"access_friends"]) {
        return VDKInternalPermissionTypeAccessFriends;
    }
    else if ([name isEqualToString:@"access_email"]) {
        return VDKInternalPermissionTypeAccessEmail;
    }
    else if ([name isEqualToString:@"access_phone"]) {
        return VDKInternalPermissionTypeAccessPhone;
    }
    else if ([name isEqualToString:@"access_profile"]) {
        return VDKInternalPermissionTypeAccessProfile;
    }
    else if ([name isEqualToString:@"access_balance"]) {
        return VDKInternalPermissionTypeAccessBalance;
    }
    else if ([name isEqualToString:@"make_payments"]) {
        return VDKInternalPermissionTypeMakePayments;
    }
    else {
        return VDKInternalPermissionTypeUnknown;
    }
}

@end
