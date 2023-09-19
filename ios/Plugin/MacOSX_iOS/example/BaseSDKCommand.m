//
//  BaseSDKCommand.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "BaseSDKCommand.h"

@implementation BaseSDKCommand

/**
 * Initialize the command.
 * @param app The main application class.
 * @return The initialized instance.
 */
- (id) initWithApp:(SDKCommandLineApp *)theApp
{
    if (self = [super init]) {
        app = theApp;
    }
    return self;
}

/**
 * Gets the name of the command.
 * @return The name of the command.
 */
- (NSString *) getName
{
    return name;
}

/**
 * Gets the description of the command.
 * @return The description of the command.
 */
- (NSString *) getDescription
{
    return description;
}

/**
 * Performs the command action.
 */
- (void) performCommand
{
    printf("Command '%s' is missing the performCommand implementation\n", [name UTF8String]);
}

/**
 * Returns whether the command is applicable to the
 * current application state.
 * @return YES if the command can be run, NO otherwise.
 */
- (BOOL) isApplicable
{
    printf("Command '%s' is missing the isApplicable implementation\n", [name UTF8String]);
    return NO;
}

@end
