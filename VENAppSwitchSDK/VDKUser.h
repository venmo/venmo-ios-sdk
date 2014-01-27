#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VDKUser : NSObject
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *about;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSDate *dateJoined;
@property (nonatomic, readonly) UIImage *profilePicture;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSInteger friendsCount;

- (id)initWithJSON:(NSData *)json;
@end