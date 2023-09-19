#import "AddUserViewController.h"
#import "MatcherManager.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Class to comunicate with the matcher
    _matcher = [MatcherManager sharedInstance];
}

- (IBAction) AddUserClick:(id)sender {
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
    _widget.extractionMode = EMWizardRegister;
    [_widget StartExtraction];
    
    [self presentViewController:_widget animated:true completion:nil];
    // [END] widget mandatory statements
    // --------------------------------------------------------------------
}

-(void) ExtractionFinished {
    NSString *templateStringBase64=nil;
    
    
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
    templateStringBase64 = [NSString stringWithFormat:@"%@", [template base64EncodedStringWithOptions:0]];
    
    // If you need some user picture uncomment the following lines
    /*
     FPhiUCExtractionRecord *record = [_widget.results.images objectAtIndex:0];
     UIImage *picture = [record image];
     NSString *imageStringBase64 = [NSString stringWithFormat:@"%@", [UIImageJPEGRepresentation(picture, 1) base64EncodedStringWithOptions:0]];
     */
    
    
    // Create user and store in database.
    bool userCreated = [_matcher createUser:_nameTextField.text :template];
    
    if(userCreated)
        [self createUserResult:_nameTextField.text];
    else
        [self createUserResult:nil];
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


// MatchersoapLibrary Protocol Methods
-(void)createUserResult:(NSString *)identifier {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Info", nil)
                                                       message:(identifier) ? NSLocalizedString(@"RegisterOk", nil) : NSLocalizedString(@"RegisterFail", nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                             otherButtonTitles:nil
                              ];
    [alertView show];
}


@end
