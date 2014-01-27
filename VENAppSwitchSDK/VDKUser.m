#import "VDKUser.h"

@implementation VDKUser

- (id)initWithJSON:(id)json {
    /** init a user from a venmo user resource **/
    self = [super init];
    if (self) {
        _firstName = json[@"first_name"];
        _lastName = json[@"last_name"];
        _username = json[@"username"];
        _displayName = json[@"display_name"];
        _profilePicture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:json[@"profile_picture_url"]]]];
        _email = json[@"email"];
        _phone = json[@"phone"];
        _friendsCount = [json[@"friends_count"] integerValue];
        _about = json[@"about"];
        _dateJoined = json[@"date_joined"];
    }
    return self;
}
@end
