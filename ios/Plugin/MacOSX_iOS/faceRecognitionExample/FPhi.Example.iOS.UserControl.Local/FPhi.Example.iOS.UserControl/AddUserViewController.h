#import <UIKit/UIKit.h>

#import "FPhiUCios/FPhiUCios.h"
#import "MatcherManager.h"


@interface AddUserViewController : UIViewController<FPhiUCProtocol>

@property FPhiUC *widget;
@property MatcherManager *matcher;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
