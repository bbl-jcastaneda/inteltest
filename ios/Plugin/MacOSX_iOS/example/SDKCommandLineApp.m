//
//  SDKCommandLineApp.m
//  Entrust IdentityGuard Mobile SDK
//  Command Line Example
//
//  Copyright (c) 2013 Entrust, Inc. All rights reserved.
//  Use is subject to the terms of the accompanying license agreement. Entrust Confidential.
//

#import "SDKCommandLineApp.h"
#import "ETSoftTokenSDK.h"
#import "ETIdentity.h"
#import "ETDataTypes.h"
#import "SDKUtils.h"
#import "BaseSDKCommand.h"
#import "ResetSDKCommand.h"
#import "OTPSDKCommand.h"
#import "PollSDKCommand.h"
#import "InfoSDKCommand.h"
#import "UnlockSDKCommand.h"
#import "CreateSDKCommand.h"
#import "RegisterSDKCommand.h"
#import "OfflineSDKCommand.h"

@implementation SDKCommandLineApp
{
    NSArray *commands;
    CreateSDKCommand *createCommand;
    
}

@synthesize identity;

/**
 * Start running the application.
 */
- (void) startApp
{
    // Set up the list of available commands.
    createCommand = [[CreateSDKCommand alloc] initWithApp:self];
    commands = [NSArray arrayWithObjects:
                createCommand,
                [[OTPSDKCommand alloc] initWithApp:self],
                [[PollSDKCommand alloc] initWithApp:self],
                [[RegisterSDKCommand alloc] initWithApp:self],
                [[InfoSDKCommand alloc] initWithApp:self],
                [[UnlockSDKCommand alloc] initWithApp:self],
                [[ResetSDKCommand alloc] initWithApp:self],
                [[OfflineSDKCommand alloc] initWithApp:self],
                nil];
    
    // Set the SDK settings
    
    // Turn off SDK logging because the application will handle the error
    // messages.  If you need to debug an issue, you can turn up the log
    // level.
    [ETSoftTokenSDK setLogLevel:ETLogLevelOff];
    
    // Initialize the SDK engine which sets up the encryption key.
    BOOL wasReset = [ETSoftTokenSDK initializeSDK];
    if (wasReset) {
        // Clean up any existing identities because we can't decrypt them.
        [SDKUtils deleteIdentityFile];
    }
    
    // Attempt to load a previously saved identity.
    identity = [SDKUtils loadIdentity];
    
    if (identity == nil) {
        // If there isn't an existing identity, force the user to create one now.
        printf("There is no soft token previously created.  You will be prompted\n");
        printf("to create a new soft token now.\n\n");
        
        [createCommand performCommand];
    }
    
    // The first time through display the list of available commands.
    [self printCommands];
    
    // This is the main run loop of the application.
    // It runs until the application is closed or the user
    // types quit or exit.
    while (true) {
        if (identity == nil) {
            // If the user resets the application, force them to create
            // a new soft token.
            [createCommand performCommand];
        } else {
            [self promptForCommand];
        }
    }
}

/**
 * Prompt the user to enter a command.  If the command is valid,
 * run the chosen command.
 */
- (void) promptForCommand
{
    NSString *response = [[SDKUtils promptForString:@"\nPlease enter a command:" maxLength:50] lowercaseString];
    if ([response isEqualToString:@"help"] || [response isEqualToString:@""] || [response isEqualToString:@"?"]) {
        // Show the command list.
        [self printCommands];
        return;
    }
    
    BOOL commandFound = NO;
    for (BaseSDKCommand* command in commands) {
        if ([[command getName] isEqualToString:response] && [command isApplicable]) {
            // Found the command the user requested.  Run it now.
            [command performCommand];
            commandFound = YES;
            break;
        }
    }
    if (!commandFound) {
        // The user entered an invalid command.
        printf("Invalid command '%s' entered.\n\n", [response UTF8String]);
        [self printCommands];
    }
}

/**
 * Print the list of commands to the user.
 */
- (void) printCommands
{
    printf("Available commands:\n");
    for (BaseSDKCommand* command in commands) {
        if ([command isApplicable]) {
            printf("%-7s - %s\n", [[command getName] UTF8String], [[command getDescription] UTF8String]);
        }
    }
    printf("%-7s - Show list of commands.\n", "help");
    printf("%-7s - Exit this application.\n", "quit");
}

@end
