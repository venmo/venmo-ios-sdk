#import "VDKLoggedInViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface VDKLoggedInViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation VDKLoggedInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VENUser *user = [[Venmo sharedInstance] session].user;
    self.imageView.layer.borderColor = self.infoLabel.textColor.CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0f;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.infoLabel.text = [NSString stringWithFormat:@"Logged in as %@", user.displayName];
}

- (IBAction)unwindFromPaymentVC:(UIStoryboardSegue *)segue {

}


@end
