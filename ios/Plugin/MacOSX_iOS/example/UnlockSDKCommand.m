//
//  UnlockSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "UnlockSDKCommand.h"

/**
 * This command allows you to generate an unlock challenge
 * code that is entered in Entrust IdentityGuard or Entrust
 * IdentityGuard Self-Service.  You will receive an unlock
 * response code which is entered into this application.
 * This application will validate the response code and
 * display whether it is valid.
 *
 * In a real application which is performing PIN validation,
 * a user may enter an invalid PIN too many times causing
 * the application to become locked.  When this happens,
 * the application can use the unlock challenge/response
 * mechanism to authenticate a user so they may reset their
 * PIN.
 */
@implementation UnlockSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"unlock";
        description = @"Generates an unlock challenge code and prompts for the unlock response code.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    NSString *unlockChallenge = [ETIdentity getUnlockChallenge];
    printf("To unlock a soft token type the following unlock challenge into\n");
    printf("Entrust IdentityGuard to generate an unlock response.\n");
    
    while (true) {
        // Generate and display the unlock challenge code.
        printf("Unlock Challenge Code: %s\n", [unlockChallenge UTF8String]);
        NSString *response = [SDKUtils promptForString:@"Enter Unlock Response Code:" maxLength:20];
        BOOL success = [app.identity confirmUnlockCode:response forChallenge:unlockChallenge];
        if (success) {
            printf("You have successfully unlocked the soft token.\n");
            // In a real application you would ask the user to enter their new PIN
            // and save it.
            return;
        }
        BOOL tryAgain = [SDKUtils askYesNoQuestion:@"An invalid unlock response was entered. Do you want to try again?"];
        if (!tryAgain) {
            return;
        }
    }
}

/**
 * Returns whether the command is applicable to the
 * current application state.
 * @return YES if the command can be run, NO otherwise.
 */
- (BOOL) isApplicable
{
    return app.identity != nil;
}

@end
