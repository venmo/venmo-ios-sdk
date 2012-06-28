#import <UIKit/UIKit.h>

typedef enum {
    VenmoTransactionTypePay,
    VenmoTransactionTypeCharge
} VenmoTransactionType;

@interface VenmoTransaction : NSObject

@property (copy, nonatomic) NSString *transactionID;
@property (nonatomic) VenmoTransactionType type;
@property (copy, nonatomic) NSString *fromUserID;        // set on completion
@property (copy, nonatomic) NSString *toUserID;          // set on completion
@property (nonatomic) CGFloat amount;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *toUserHandle; // cell number, email, @twitter, Venmo username
@property (nonatomic) BOOL success;

+ (VenmoTransactionType)typeWithString:(NSString *)string;
- (NSString *)typeString;
- (NSString *)typeStringPast;
- (NSString *)amountString;

@end
