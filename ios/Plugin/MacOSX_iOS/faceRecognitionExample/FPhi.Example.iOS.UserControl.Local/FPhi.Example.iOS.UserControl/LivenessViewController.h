#import <UIKit/UIKit.h>

#import "FPhiUCios/FPhiUCios.h"
#import "MatcherManager.h"


@interface LivenessViewController : UIViewController<FPhiUCProtocol,UITableViewDelegate, UITableViewDataSource>

@property FPhiUC *widget;
@property MatcherManager *matcher;

@property (nonatomic) NSMutableArray *users;


@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UIView *viewWait;

@end
