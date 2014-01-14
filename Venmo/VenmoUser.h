//
//  VenmoUser.h
//  Venmo
//
//  Created by Cody De La Vara on 1/13/14.
//
//

#import <Foundation/Foundation.h>

@interface VenmoUser : NSObject
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *about;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSDate *dateJoined;
@property (nonatomic, readonly) NSURL *profilePictureURL;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSInteger friendsCount;

- (id)initWithJSON:(NSData *)json;
@end