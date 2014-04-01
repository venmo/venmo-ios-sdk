#import <Foundation/Foundation.h>

// Adapted from SSToolkit
@interface NSData (VDKBase64)

- (NSString *)base64EncodedString;

@end

@interface NSString (VenmoBase64)

- (NSData *)base64DecodedData;
- (NSString *)base64DecodedString;

@end
