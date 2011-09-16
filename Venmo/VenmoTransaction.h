#import <UIKit/UIKit.h>

typedef enum {
    VenmoTransactionTypePay,
    VenmoTransactionTypeCharge
} VenmoTransactionType;

@interface VenmoTransaction : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic) VenmoTransactionType type;
@property (nonatomic) NSUInteger fromUserId;        // set on completion
@property (nonatomic) NSUInteger toUserId;          // set on completion
@property (nonatomic) CGFloat amount;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *toUserHandle; // cell number, email, @twitter, Venmo username
@property (nonatomic) BOOL success;

+ (VenmoTransactionType)typeWithString:(NSString *)string;
- (NSString *)typeString;
- (NSString *)typeStringPast;
- (NSString *)amountString;

@end
