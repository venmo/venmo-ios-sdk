#import <UIKit/UIKit.h>

@interface VDKActivityView : UIView

+ (id)activityView; // default title: Loading...
+ (id)activityViewWithTitle:(NSString *)title;

- (void)show;
- (void)hide;
- (void)hideAnimated:(BOOL)animated;

@end
