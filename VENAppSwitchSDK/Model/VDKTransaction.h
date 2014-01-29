#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VDKTransactionType) {
    VDKTransactionTypePay,
    VDKTransactionTypeCharge
};

@interface VDKTransaction : NSObject

@property (assign, nonatomic) VDKTransactionType type;
@property (assign, nonatomic) NSUInteger amount;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *toUserHandle; // cell number, email, Venmo username
@property (copy, nonatomic) NSString *toUserID;

@property (copy, nonatomic) NSString *transactionID;
@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *fromUserID;

+ (instancetype)transactionWithType:(VDKTransactionType)type
                             amount:(NSUInteger)amount
                               note:(NSString *)note
                          recipient:(NSString *)recipient;

+ (instancetype)transactionWithURL:(NSURL *)url;

- (NSString *)typeString;
- (NSString *)typeStringPast;
- (NSString *)amountString;

@end
