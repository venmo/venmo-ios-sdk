//
//  VenmoSession.m
//  Venmo
//
//  Created by Cody De La Vara on 1/13/14.
//
//

#import "VenmoSession.h"

@implementation VenmoSession

- (id)initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSInteger)expiresIn {
    self.accessToken = accessToken;
    self.refreshToken = refreshToken;
    self.expiresIn = expiresIn;
    return self;
}
@end
