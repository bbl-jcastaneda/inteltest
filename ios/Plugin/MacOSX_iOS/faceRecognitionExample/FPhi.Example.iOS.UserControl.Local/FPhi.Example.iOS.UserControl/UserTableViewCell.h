#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property NSString *identifier;

@property (nonatomic, weak) IBOutlet UILabel *labelName;
@property (nonatomic, weak) IBOutlet UIButton *buttonCell;

@end
