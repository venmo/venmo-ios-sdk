#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VDKInternalPermissionType) {
    VDKInternalPermissionTypeUnknown,
    VDKInternalPermissionTypeAccessFriends,
    VDKInternalPermissionTypeAccessEmail,
    VDKInternalPermissionTypeAccessPhone,
    VDKInternalPermissionTypeAccessProfile,
    VDKInternalPermissionTypeAccessBalance,
    VDKInternalPermissionTypeMakePayments
};

@interface VDKPermission : NSObject

@property (assign, nonatomic) VDKInternalPermissionType type;

- (instancetype)initWithType:(VDKInternalPermissionType)permissionType;

- (NSString *)name;
- (NSString *)displayText;

+ (VDKInternalPermissionType)typeForName:(NSString *)name;

@end
