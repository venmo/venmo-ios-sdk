#import <UIKit/UIKit.h>

@interface VenmoActivityView : UIView

+ (id)activityView; // default title: Loading...
+ (id)activityViewWithTitle:(NSString *)title;

- (void)show;
- (void)hide;
- (void)hideAnimated:(BOOL)animated;

@end
