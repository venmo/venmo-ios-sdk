#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VDKPermissionType) {
    VDKPermissionTypeUnknown,
    VDKPermissionTypeAccessFriends,
    VDKPermissionTypeAccessEmail,
    VDKPermissionTypeAccessPhone,
    VDKPermissionTypeAccessProfile,
    VDKPermissionTypeAccessBalance,
    VDKPermissionTypeMakePayments
};

@interface VDKPermission : NSObject

@property (assign, nonatomic) VDKPermissionType type;

- (instancetype)initWithType:(VDKPermissionType)permissionType;

- (NSString *)name;
- (NSString *)displayText;

@end
