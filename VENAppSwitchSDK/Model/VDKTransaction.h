#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VenmoTransactionType) {
    VenmoTransactionTypePay,
    VenmoTransactionTypeCharge
};

@interface VDKTransaction : NSObject

@property (copy, nonatomic) NSString *transactionID;
@property (assign, nonatomic) VenmoTransactionType type;
@property (copy, nonatomic) NSString *fromUserID;
@property (copy, nonatomic) NSString *toUserID;
@property (strong, nonatomic) NSDecimalNumber *amount;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *toUserHandle; // cell number, email, @twitter, Venmo username
@property (assign, nonatomic) BOOL success;

+ (VenmoTransactionType)typeWithString:(NSString *)string;
+ (instancetype)transactionWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)transactionWithURL:(NSURL *)url;

- (NSString *)typeString;
- (NSString *)typeStringPast;
- (NSString *)amountString;


@end
