#import <Foundation/Foundation.h>

// Adapted from SSToolkit
@interface NSData (VENBase64)

- (NSString *)base64EncodedString;

@end

@interface NSString (VENBase64)

- (NSData *)base64DecodedData;
- (NSString *)base64DecodedString;

@end
