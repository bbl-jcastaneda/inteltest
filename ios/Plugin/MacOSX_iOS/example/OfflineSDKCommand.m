//
//  OfflineSDKCommand.m
//  SDKCommandLineExample
//
//  Created by John Wang on 2014-05-28.
//  Copyright (c) 2014 Entrust Inc. All rights reserved.
//

#import "OfflineSDKCommand.h"
#import "ETIdentityProvider.h"
#import "ETTransaction.h"
#import "ETSoftTokenSDK.h"

/**
 * This command allows you to generate an transaction confirmation
 * code that is entered in IdentityGuard Anybank web sample.  
 * You will perform a wire-transfer, toggle options, select offline
 * confirmation, right-click on the qr code and click 'Copy Link'
 * Paste the link onto the command line and hit return
 */

@implementation OfflineSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"offline";
        description = @"Get offline transaction confirmation with QR code link.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    NSString *qrLink = [SDKUtils promptForString:@"Please paste in the QR code link from the Anybank Sample:" maxLength:500];
    ETLaunchUrlParams *launchUrlParams = [ETSoftTokenSDK parseLaunchUrl:[NSURL URLWithString:qrLink]];
    ETOfflineTransactionUrlParams *txnParams = (ETOfflineTransactionUrlParams *)launchUrlParams;
   
    ETTransaction *transaction = [ETIdentity offlineTransactionFromUrlParams:txnParams forIdentity:app.identity];
    printf("The confirmation code you must enter to confirm this transaction is:\n");
    printf("%s", [[app.identity getConfirmationCode:transaction] UTF8String]);
}

/**
 * Returns whether the command is applicable to the
 * current application state.
 * @return YES if the command can be run, NO otherwise.
 */
- (BOOL) isApplicable
{
    return app.identity != nil && app.identity.registeredForOfflineTransactions;
}

@end
