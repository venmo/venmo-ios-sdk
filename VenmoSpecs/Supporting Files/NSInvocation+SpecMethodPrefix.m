#import <SenTestingKit/SenTestingKit.h>

@implementation NSInvocation (SpecMethodPrefix)

+ (void)load {
    [self performSelector:@selector(setTestMethodPrefix:) withObject:@"spec"];
}

@end
