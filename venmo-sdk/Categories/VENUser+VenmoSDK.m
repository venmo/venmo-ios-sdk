#import "VENUser+VenmoSDK.h"

@interface VENUser (VENUser_VenmoSDK)

@property (copy, nonatomic, readwrite) NSString *internalId;
@property (copy, nonatomic, readwrite) NSString *externalId;

@end

@implementation VENUser (VenmoSDK)

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.username = [decoder decodeObjectForKey:@"username"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.displayName = [decoder decodeObjectForKey:@"displayName"];
        self.about = [decoder decodeObjectForKey:@"about"];
        self.profileImageUrl = [decoder decodeObjectForKey:@"profileImageUrl"];
        self.primaryPhone = [decoder decodeObjectForKey:@"primaryPhone"];
        self.primaryEmail = [decoder decodeObjectForKey:@"primaryEmail"];
        self.internalId = [decoder decodeObjectForKey:@"internalId"];
        self.externalId = [decoder decodeObjectForKey:@"externalId"];
        self.dateJoined = [decoder decodeObjectForKey:@"dateJoined"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.firstName forKey:@"firstName"];
    [coder encodeObject:self.lastName forKey:@"lastName"];
    [coder encodeObject:self.displayName forKey:@"displayName"];
    [coder encodeObject:self.about forKey:@"about"];
    [coder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
    [coder encodeObject:self.primaryPhone forKey:@"primaryPhone"];
    [coder encodeObject:self.primaryEmail forKey:@"primaryEmail"];
    [coder encodeObject:self.internalId forKey:@"internalId"];
    [coder encodeObject:self.externalId forKey:@"externalId"];
    [coder encodeObject:self.dateJoined forKey:@"dateJoined"];
}

@end
