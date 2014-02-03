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

- (id)initWithJSON:(id)json {
    self = [super init];
    if (self) {
        self.username = json[@"username"];
        self.firstName = json[@"first_name"];
        self.lastName = json[@"last_name"];
        self.about = json[@"about"];
        self.displayName = json[@"display_name"];
        self.dateJoined = json[@"date_joined"];
        self.profilePicture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:json[@"profile_picture_url"]]]];
        self.phone = json[@"phone"];
        self.email = json[@"email"];
        self.friendsCount = [json[@"friends_count"] integerValue];
    }
    return self;
}
@end
