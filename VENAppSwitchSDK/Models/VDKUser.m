#import "VDKUser.h"

@interface VDKUser ()
@property (copy, nonatomic, readwrite) NSString *username;
@property (copy, nonatomic, readwrite) NSString *firstName;
@property (copy, nonatomic, readwrite) NSString *lastName;
@property (copy, nonatomic, readwrite) NSString *about;
@property (copy, nonatomic, readwrite) NSString *displayName;
@property (strong, nonatomic, readwrite) NSDate *dateJoined;
@property (strong, nonatomic, readwrite) UIImage *profilePicture;
@property (copy, nonatomic, readwrite) NSString *phone;
@property (copy, nonatomic, readwrite) NSString *email;
@property (assign, nonatomic, readwrite) NSInteger friendsCount;
@end

@implementation VDKUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.username = dictionary[@"username"];
        self.firstName = dictionary[@"first_name"];
        self.lastName = dictionary[@"last_name"];
        self.about = dictionary[@"about"];
        self.displayName = dictionary[@"display_name"];
        self.dateJoined = dictionary[@"date_joined"];
        self.profilePicture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dictionary[@"profile_picture_url"]]]];
        self.phone = dictionary[@"phone"];
        self.email = dictionary[@"email"];
        self.friendsCount = [dictionary[@"friends_count"] integerValue];
    }
    return self;
}

@end
