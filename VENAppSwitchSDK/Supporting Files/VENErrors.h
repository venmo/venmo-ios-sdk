#import <Foundation/Foundation.h>

extern NSString *const VENErrorDomain;

enum {
    VENTransactionValidationError = 1, // error validating signed transaction
    VENTransactionFailedError          // Venmo server failed to complete transaction
};
