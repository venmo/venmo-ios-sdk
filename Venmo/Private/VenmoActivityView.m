#import <QuartzCore/CALayer.h>

#import "VenmoDefines_Internal.h"
#import "VenmoActivityView_Internal.h"

@interface VenmoActivityView (Venmo)
- (id)initWithTitle:(NSString *)title;
- (UIView *)defaultSuperview;
- (void)remove;
@end

@implementation VenmoActivityView

#pragma mark - Initializers

+ (id)activityView {
    return [self activityViewWithTitle:@"Loading..."];
}

+ (id)activityViewWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

#pragma mark - Initializers @private

- (id)initWithTitle:(NSString *)title {
    CGRect frame = CGRectMake(74.0f, 154.0f, 172.0f, 172.0f);
    if ((self = [super initWithFrame:frame])) {
        self.autoresizingMask = // keep centered during rotation
        (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5]; // translucent black
        self.layer.cornerRadius = 10.0;

        UIActivityIndicatorView *activityIndicator =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
         UIActivityIndicatorViewStyleWhiteLarge];
        DLog(@"self.center: %@", NSStringFromCGPoint(self.center));
        activityIndicator.center = [self convertPoint:self.center
                                             fromView:[UIApplication sharedApplication].keyWindow];
        DLog(@"activityIndicator.center: %@", NSStringFromCGPoint(activityIndicator.center));
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
        DLog(@"activityIndicator: %@", activityIndicator);

        frame = CGRectMake(0.0f, 128.0f, 172.0f, 20.0f);
        UILabel *activityLabel = [[UILabel alloc] initWithFrame:frame];
        activityLabel.backgroundColor = [UIColor clearColor];
        activityLabel.text = NSLocalizedString(title, nil);
        activityLabel.textColor = [UIColor whiteColor];
        activityLabel.shadowColor = [UIColor darkGrayColor];
        activityLabel.shadowOffset = CGSizeMake(0, 2);
        activityLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        activityLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:activityLabel];
    }
    return self;
}

#pragma mark - Show & Hide

- (void)show {
    UIView *superview = [self defaultSuperview];
    superview.userInteractionEnabled = NO;
    [superview addSubview:self];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.center = [keyWindow convertPoint:self.center toView:superview];
}

- (void)hide {
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0f; // fade
        } completion:^(BOOL finished){
            [self remove];
            self.alpha = 1.0f; // restore to default
        }];
    } else {
        [self remove];
    }
}

#pragma mark - Show & Hide @private

- (UIView *)defaultSuperview {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    return [[keyWindow subviews] objectAtIndex:0];
}

- (void)remove {
    self.superview.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

@end
