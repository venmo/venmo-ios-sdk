#import "VDKPermission.h"

@implementation VDKPermission

- (instancetype)initWithType:(VDKPermissionType)permissionType {
    self = [super init];
    if (self) {
        self.type = permissionType;
    }
    return self;
}

- (NSString *)name {
    switch (self.type) {
        case VDKPermissionTypeAccessFriends:
            return @"access_friends";
        case VDKPermissionTypeAccessEmail:
            return @"access_email";
        case VDKPermissionTypeAccessPhone:
            return @"access_phone";
        case VDKPermissionTypeAccessProfile:
            return @"access_profile";
        case VDKPermissionTypeAccessBalance:
            return @"access_balance";
        case VDKPermissionTypeMakePayments:
            return @"make_payments";
        default:
            return @"invalid_scope";
    }
}

- (NSString *)displayText {
    switch (self.type) {
        case VDKPermissionTypeAccessFriends:
            return NSLocalizedString(@"access friends", nil);
        case VDKPermissionTypeAccessEmail:
            return NSLocalizedString(@"access email", nil);
        case VDKPermissionTypeAccessPhone:
            return NSLocalizedString(@"access phone", nil);
        case VDKPermissionTypeAccessProfile:
            return NSLocalizedString(@"access profile", nil);
        case VDKPermissionTypeAccessBalance:
            return NSLocalizedString(@"access balance", nil);
        case VDKPermissionTypeMakePayments:
            return NSLocalizedString(@"make payments and charges", nil);
        default:
            return @"";
    }
}

@end
