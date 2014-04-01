#import <Foundation/Foundation.h>

extern NSString *const VDKErrorDomain;

enum {
    VDKTransactionValidationError = 1, // error validating signed transaction
    VDKTransactionFailedError          // Venmo server failed to complete transaction
};
