#import <Foundation/Foundation.h>

// Debug NSLog for performance. http://j.mp/mQ8Nb3
#ifdef DEBUG
#define DLog(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(xx, ...) ((void)0)
#endif
