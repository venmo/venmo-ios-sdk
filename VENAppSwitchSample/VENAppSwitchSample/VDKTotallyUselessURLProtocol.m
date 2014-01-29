//
//  VDKTotallyUselessURLProtocol.m
//  VENAppSwitchSample
//
//  Created by Ayaka Nonaka on 1/28/14.
//  Copyright (c) 2014 Venmo. All rights reserved.
//

#import "VDKTotallyUselessURLProtocol.h"

@implementation VDKTotallyUselessURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}


- (void)startLoading {
    int i = 1;
    if (i) {

    }
}


- (void)stopLoading {

}

@end
