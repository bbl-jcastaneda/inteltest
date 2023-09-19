#import "AuthenticateViewController.h"
#import "UserTableViewCell.h"
#import "DtoUser.h"

@interface AuthenticateViewController ()

@property DtoUser *user;

@end

@implementation AuthenticateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Class to comunicate with the matcher
    _matcher = [MatcherManager sharedInstance];
    
    // ONLY EXAMPLE: Get availables users in database
    _viewWait.hidden = NO;
    
    _users = [_matcher getUsers];
    _viewWait.hidden = YES;
    [_usersTableView reloadData];
}

- (IBAction) AuthenticateUserClick:(UIButton *)sender {
    // ONLY EXAMPLE: Get user identifier to authenticate from table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    UserTableViewCell *cell = (UserTableViewCell *)[_usersTableView cellForRowAtIndexPath:indexPath];
    _user = [[DtoUser alloc] init];
    _user.idUser = cell.identifier;

    // [START] widget mandatory statements
    // --------------------------------------------------------------------
    NSError *error = nil;
    _widget = [[FPhiUC alloc]init :true :self :&error];
    if (error != nil) {
        switch (error.code) {
            case UCEUnknown:
                /*
                 // Uncomment this line to show a standar alertView
                 UIAlertView *alertView;
                 alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                 message:NSLocalizedString(@"UnknownError", nil)
                 delegate:self
                 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                 otherButtonTitles:nil];
                 [alertView show];
                 */
                break;
                
            case UCECameraPermission:
                /*
                 // Uncomment this line to show a standar alertView
                 UIAlertView *alertView;
                 alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                 message:NSLocalizedString(@"CameraPermissionNotAllowed", nil)
                 delegate:self
                 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                 otherButtonTitles:nil];
                 [alertView show];
                 */
                break;
        }
        return;
    }
    _widget.extractionMode = EMAuthenticate;
    [_widget StartExtraction];
    
    [self presentViewController:_widget animated:true completion:nil];
    // [END] widget mandatory statements
    // --------------------------------------------------------------------
}

-(void) ExtractionFinished {
    
    // Check for widget error
    if (!_widget.results || !_widget.results.result) {
        // Show some feedback to user (for example: new error screen, alertView)
        /*
         // Uncomment this line to show a standar alertView
         UIAlertView *alertView;
         alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                               message:NSLocalizedString(@"InternalErrorMessage", nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                     otherButtonTitles:nil];
         [alertView show];
         */
        return;
    }
    
    // Get biometric data
    NSData *template = [_widget.results.result getTemplate];
    if (template.length <= 0) {
        // Show some feedback to user (for example: new error screen, alertView)
        /*
         // Uncomment this line to show a standar alertView
         UIAlertView *alertView;
         alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                               message:NSLocalizedString(@"FaceNotFound", nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                     otherButtonTitles:nil];
         [alertView show];
         */
        return;
    }
    
    
    // If you need some user picture uncomment the following lines
    /*
     FPhiUCExtractionRecord *record = [_widget.results.images objectAtIndex:0];
     UIImage *picture = [record image];
     NSString *imageStringBase64 = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(picture, 1) base64EncodedStringWithOptions:0]];
     */
    
    
    // Authenticate the user
    bool isAuthPositive = [_matcher authenticate:_user.idUser :template];
    
    [self authenticateResult:isAuthPositive];
}

-(void)ExtractionFailed:(NSError *) error {
    // Show some feedback to user (for example: new error screen, alertView)
    /*
     // Uncomment this line to show a standar alertView
     UIAlertView *alertView;
     alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                           message:NSLocalizedString(@"InternalErrorMessage", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                 otherButtonTitles:nil];
     [alertView show];
     */
}

-(void)ExtractionCancelled {
    // Show some feedback to user (for example: new error screen, alertView)
    /*
     // Uncomment this line to show a standar alertView
     UIAlertView *alertView;
     alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                           message:NSLocalizedString(@"CancelByUser", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                 otherButtonTitles:nil];
     [alertView show];
     */
}

-(void)ExtractionTimeout {
    // Show some feedback to user (for example: new error screen, alertView)
    /*
     // Uncomment this line to show a standar alertView
     UIAlertView *alertView;
     alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                           message:NSLocalizedString(@"Timeout", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                 otherButtonTitles:nil];
     [alertView show];
    */
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_users) ? _users.count : 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
    if (!_users || indexPath.row > _users.count) return cell;

    DtoUser *user = [_users objectAtIndex:indexPath.row];
    cell.labelName.text = user.name;
    cell.buttonCell.tag = indexPath.row;
    cell.identifier = user.idUser;
    
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UserTableViewCell *cell = (UserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [_matcher deleteUser:cell.identifier];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_usersTableView reloadData];
        });
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"Delete", nil);
}


-(void)authenticateResult:(bool)isPositiveMatch {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                                       message:(isPositiveMatch) ? NSLocalizedString(@"AuthenticationOk", nil) : NSLocalizedString(@"AuthenticationFail", nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                             otherButtonTitles:nil
                              ];
    [alertView show];
}


@end
