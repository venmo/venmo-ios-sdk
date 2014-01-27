#import <Foundation/Foundation.h>

extern NSString *const VenmoErrorDomain;

enum {
    VenmoTransactionValidationError = 1, // error validating signed transaction
    VenmoTransactionFailedError          // Venmo server failed to complete transaction
};
