//
//  InfoSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "InfoSDKCommand.h"

/**
 * This command displays information about the
 * soft token identity such as the serial number,
 * one-time password length and PIN requirements.
 */
@implementation InfoSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"info";
        description = @"Prints the information about the current soft token.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    printf("Soft Token Information:\n");
    printf("%-15s = %s\n", "Serial Number", [[app.identity serialNumber] UTF8String]);
    printf("%-15s = %s\n", "Identity ID", [[app.identity identityId] UTF8String]);
    printf("%-15s = %s\n", "Device ID", [[app.identity deviceId] UTF8String]);
    printf("%-15s = %s\n", "Transactions", app.identity.registeredForTransactions? "Yes" : "No");
    printf("%-15s = %s\n", "PIN Required", app.identity.pinRequired? "Yes" : "No");
    printf("%-15s = %d digits\n", "OTP Length", app.identity.otpLength);
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
