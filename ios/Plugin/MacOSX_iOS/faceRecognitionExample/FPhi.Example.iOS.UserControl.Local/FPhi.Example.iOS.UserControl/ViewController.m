#import "ViewController.h"
#import "AddUserViewController.h"
#import "AuthenticateViewController.h"
#import "LivenessViewController.h"
#import "FPhiUCios/FPhiUCTutorial.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAddUserClick:(id)sender {
    AddUserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUserView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonAuthenticateClick:(id)sender {
    AuthenticateViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthenticateView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonLivenessClick:(id)sender {
    LivenessViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LivenessView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)buttonHelpClick:(id)sender {
    [FPhiUCTutorial ShowTutorial :self: FPhiUCTutorialLivenessOptionalMode];
}

@end
