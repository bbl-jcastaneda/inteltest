//
//  ResetSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "ResetSDKCommand.h"

/**
 * The reset command will delete the current soft token which
 * triggers the user to create a new soft token.
 */
@implementation ResetSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
-(id)initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super initWithApp:theApp]) {
        name = @"reset";
        description = @"Deletes the current soft token and creates a new one.";
    }
    return self;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    if ([SDKUtils askYesNoQuestion:@"Are you sure you want to reset? Your soft token will be deleted."]) {
        app.identity = nil;
        [SDKUtils deleteIdentityFile];
        [SDKUtils saveTransactionUrl:nil];
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
