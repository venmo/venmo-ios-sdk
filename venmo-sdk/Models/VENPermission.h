typedef NS_ENUM(NSUInteger, VENPermissionType) {
    VENPermissionTypeUnknown,
    VENPermissionTypeAccessFriends,
    VENPermissionTypeAccessEmail,
    VENPermissionTypeAccessPhone,
    VENPermissionTypeAccessProfile,
    VENPermissionTypeAccessBalance,
    VENPermissionTypeMakePayments
};

@interface VENPermission : NSObject

@property (assign, nonatomic) VENPermissionType type;

/**
 * Creates a new permission instance.
 * @param permission type The type of permission
 * @return The initialized permission
 */
- (instancetype)initWithType:(VENPermissionType)permissionType;

/**
 * Returns The permission name that is used across apps.
 * @return The permission name
 */
- (NSString *)name;

/**
 * Returns a user frienly representation of the permission name.
 * @return User friendly permission name
 */
- (NSString *)displayText;

/**
 * Returns the type of permission based on name.
 * @param name The name
 * @return The type
 */
+ (VENPermissionType)typeForName:(NSString *)name;

@end
