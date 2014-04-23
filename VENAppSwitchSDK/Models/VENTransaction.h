#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VENTransactionType) {
    VENTransactionTypePay,
    VENTransactionTypeCharge
};

@interface VENTransaction : NSObject

@property (assign, nonatomic) VENTransactionType type;
@property (assign, nonatomic) NSUInteger amount;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *toUserHandle; // cell number, email, Venmo username
@property (copy, nonatomic) NSString *toUserID;

@property (copy, nonatomic) NSString *transactionID;
@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *fromUserID;

/**
 Creates a new transaction.
 @param type The type of transaction (pay or charge)
 @param amount The amount in pennies
 @param note The payment note
 @param recipient Recepient UUID (cell number, email, Venmo username)
 @return The initialized transaction
 */
+ (instancetype)transactionWithType:(VENTransactionType)type
                             amount:(NSUInteger)amount
                               note:(NSString *)note
                          recipient:(NSString *)recipient;

+ (instancetype)transactionWithURL:(NSURL *)url;

- (NSString *)typeString;
- (NSString *)typeStringPast;
- (NSString *)amountString;

@end
