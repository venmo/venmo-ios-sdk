#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "VENUserSDK.h"

SpecBegin(VENUser)

describe(@"Initialization", ^{

    it (@"should initialize itself from JSON.", ^{
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *username = @"octocat";
        NSString *firstName = @"Octo";
        NSString *lastName = @"Cat";
        NSString *about = @"Not an octopus.";
        NSString *displayName = @"Octo Octocat Cat";
        NSDate *dateJoined = [NSDate date];
        NSString *profilePictureURL = @"http://www.venmo.com/foo.jpg";
        NSString *phone = @"1234567890";
        NSString *email = @"octo@cat.com";
        NSString *friendsCount = @"100";

        dict[@"username"] = username;
        dict[@"first_name"] = firstName;
        dict[@"last_name"] = lastName;
        dict[@"about"] = about;
        dict[@"display_name"] = displayName;
        dict[@"date_joined"] = dateJoined;
        dict[@"profile_picture_url"] = profilePictureURL;
        dict[@"phone"] = phone;
        dict[@"email"] = email;
        dict[@"friends_count"] = friendsCount;

        VENUserSDK *user = [[VENUserSDK alloc] initWithDictionary:dict];

        expect(user.username).to.equal(username);
        expect(user.firstName).to.equal(firstName);
        expect(user.lastName).to.equal(lastName);
        expect(user.about).to.equal(about);
        expect(user.displayName).to.equal(displayName);
        expect(user.dateJoined).to.equal(dateJoined);
        expect(user.phone).to.equal(phone);
        expect(user.email).to.equal(email);
        expect(user.friendsCount).to.equal([friendsCount integerValue]);
    });

});
SpecEnd