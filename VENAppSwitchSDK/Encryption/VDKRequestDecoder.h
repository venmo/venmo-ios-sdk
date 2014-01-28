//
//  VDKRequestDecoder.h
//  VENAppSwitchSDK
//
//  Created by Ayaka Nonaka on 1/27/14.
//  Copyright (c) 2014 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDKRequestDecoder : NSURLProtocol

+ (id)decodeSignedRequest:(NSString *)signedRequest withClientSecret:(NSString *)secretKey;

@end
