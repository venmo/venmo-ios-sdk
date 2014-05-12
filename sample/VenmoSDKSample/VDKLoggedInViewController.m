#import "VDKLoggedInViewController.h"

@interface VDKLoggedInViewController ()

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButtonAction:(id)sender {
    
}

#pragma mark - Segues

- (IBAction)unwindFromPaymentVC:(UIStoryboardSegue *)segue {

}


@end
