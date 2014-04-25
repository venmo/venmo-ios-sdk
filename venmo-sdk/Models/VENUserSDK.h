#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VENUserSDK : NSObject

@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSString *firstName;
@property (copy, nonatomic, readonly) NSString *lastName;
@property (copy, nonatomic, readonly) NSString *about;
@property (copy, nonatomic, readonly) NSString *displayName;
@property (strong, nonatomic, readonly) NSDate *dateJoined;
@property (strong, nonatomic, readonly) UIImage *profilePicture;
@property (copy, nonatomic, readonly) NSString *phone;
@property (copy, nonatomic, readonly) NSString *email;
@property (assign, nonatomic, readonly) NSInteger friendsCount;

/**
 * Creates a new user from a dictionary.
 * @param dictionary The dictionary representation of the user
 * @return The initialized user
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end