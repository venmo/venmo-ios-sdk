//
//  VenmoSession.h
//  Venmo
//
//  Created by Cody De La Vara on 1/13/14.
//
//

#import <Foundation/Foundation.h>

@interface VenmoSession : NSObject
//TODO: make readonly if necessary
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic) NSInteger expiresIn;

- (id) initWithAccessToken:(NSString *)accessToken
             refreshToken:(NSString *)refreshToken
                expiresIn:(NSInteger)expiresIn;

@end
